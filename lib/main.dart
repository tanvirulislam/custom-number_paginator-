import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

final selectedPageProvider = StateProvider<int>((ref) {
  return 1;
});

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NumberPaginator(),
          ],
        ),
      ),
    );
  }
}

class NumberPaginator extends ConsumerWidget {
  const NumberPaginator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(selectedPageProvider.notifier);
    final currentPage = ref.watch(selectedPageProvider);
    const totalPages = 10;

    int displayRange = notifier.state < 4 ? 3 : notifier.state;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 490),
      child: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (notifier.state > 1)
                TextButton(
                  onPressed: () {
                    int previousPage =
                        ref.read(selectedPageProvider.notifier).state - 1;
                    if (previousPage >= 1) {
                      ref.read(selectedPageProvider.notifier).state =
                          previousPage;
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Previous"),
                ),
              _buildPageButton(1, notifier.state, ref),
              if (displayRange > 3) _buildPreviousEllipsis(ref, totalPages),
              for (int i = displayRange - 1; i <= displayRange + 1; i++)
                if (i > 1 && i < totalPages)
                  _buildPageButton(i, notifier.state, ref),
              if (displayRange < totalPages - 2)
                _buildNextEllipsis(ref, totalPages),
              _buildPageButton(totalPages, notifier.state, ref),
              const SizedBox(width: 8),
              if (currentPage != totalPages)
                TextButton(
                  onPressed: () {
                    int nextPage = notifier.state + 1;
                    if (nextPage <= totalPages) {
                      notifier.state = nextPage;
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Next"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton(int pageNumber, int currentPage, WidgetRef ref) {
    final isSelected = pageNumber == currentPage;

    return InkWell(
      onTap: () {
        ref.read(selectedPageProvider.notifier).state = pageNumber;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightGreen : Colors.transparent,
        ),
        child: Text(
          '$pageNumber',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPreviousEllipsis(WidgetRef ref, int totalPages) {
    return InkWell(
      onTap: () {
        int nextPage = ref.watch(selectedPageProvider.notifier).state - 2;
        if (nextPage <= totalPages) {
          ref.watch(selectedPageProvider.notifier).state = nextPage;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: const Text(
          '...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextEllipsis(WidgetRef ref, int totalPages) {
    return InkWell(
      onTap: () {
        if (ref.watch(selectedPageProvider) == 1) {
          int nextPage = ref.watch(selectedPageProvider.notifier).state + 2;
          if (nextPage <= totalPages) {
            ref.watch(selectedPageProvider.notifier).state = nextPage;
          }
        }
        if (ref.watch(selectedPageProvider) == 2) {
          int nextPage = ref.watch(selectedPageProvider.notifier).state + 1;
          if (nextPage <= totalPages) {
            ref.watch(selectedPageProvider.notifier).state = nextPage;
          }
        }
        int nextPage = ref.watch(selectedPageProvider.notifier).state + 2;
        if (nextPage <= totalPages) {
          ref.watch(selectedPageProvider.notifier).state = nextPage;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: const Text(
          '...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
