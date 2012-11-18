Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2KRPZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:25:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58821 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2KRPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:25:32 -0500
From: Hitoshi Mitake <h.mitake@gmail.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Hitoshi Mitake <h.mitake@gmail.com>
Subject: [PATCH 0/3] perf, tools/testing: merge futextest into perf bench and tools/testing
Date: Mon, 19 Nov 2012 00:24:29 +0900
Message-Id: <1353252272-5480-1-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi perf and futex folks, very sorry for my slow posting...

This patchset merge futextest[1] of Darren Hart into perf bench and
tools/testing/selftests with some refactorings.

The benchmarking part of futextest is now "perf bench futex" in the
2nd patch. And the part of functionality test is ported to
tools/testing/selftests in the 3rd patch. The 1st one is for
preparation. It adds useful header files which implements atomic
operations and futex syscall wrappers to tools/include/tools directory
for both of perf bench and tools/testing.

[1]: http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git

Hitoshi Mitake (3):
  tools: add new headers for futex and atomic operations
  perf bench: port futex_wait.c of futextest to perf bench
  tools/testing: port functionality tests of futextest to
    tools/testing/selftests

 tools/include/tools/atomic.h                       |   95 +++++
 tools/include/tools/futex.h                        |  278 +++++++++++++++
 tools/perf/Makefile                                |    1 +
 tools/perf/bench/bench.h                           |    1 +
 tools/perf/bench/futex-wait.c                      |  295 +++++++++++++++
 tools/perf/builtin-bench.c                         |   13 +
 tools/testing/selftests/Makefile                   |    2 +-
 tools/testing/selftests/futex/.gitignore           |    9 +
 tools/testing/selftests/futex/Makefile             |   32 ++
 tools/testing/selftests/futex/futex_requeue_pi.c   |  376 ++++++++++++++++++++
 .../futex/futex_requeue_pi_mismatched_ops.c        |  151 ++++++++
 .../futex/futex_requeue_pi_signal_restart.c        |  202 +++++++++++
 .../testing/selftests/futex/futex_testing_common.c |   45 +++
 .../testing/selftests/futex/futex_testing_common.h |    9 +
 .../futex/futex_wait_private_mapped_file.c         |  137 +++++++
 tools/testing/selftests/futex/futex_wait_timeout.c |  101 ++++++
 .../futex/futex_wait_uninitialized_heap.c          |  139 +++++++
 .../selftests/futex/futex_wait_wouldblock.c        |   94 +++++
 tools/testing/selftests/futex/logging.c            |   93 +++++
 tools/testing/selftests/futex/logging.h            |   88 +++++
 tools/testing/selftests/futex/run.sh               |   92 +++++
 21 files changed, 2252 insertions(+), 1 deletions(-)
 create mode 100644 tools/include/tools/atomic.h
 create mode 100644 tools/include/tools/futex.h
 create mode 100644 tools/perf/bench/futex-wait.c
 create mode 100644 tools/testing/selftests/futex/.gitignore
 create mode 100644 tools/testing/selftests/futex/Makefile
 create mode 100644 tools/testing/selftests/futex/futex_requeue_pi.c
 create mode 100644 tools/testing/selftests/futex/futex_requeue_pi_mismatched_ops.c
 create mode 100644 tools/testing/selftests/futex/futex_requeue_pi_signal_restart.c
 create mode 100644 tools/testing/selftests/futex/futex_testing_common.c
 create mode 100644 tools/testing/selftests/futex/futex_testing_common.h
 create mode 100644 tools/testing/selftests/futex/futex_wait_private_mapped_file.c
 create mode 100644 tools/testing/selftests/futex/futex_wait_timeout.c
 create mode 100644 tools/testing/selftests/futex/futex_wait_uninitialized_heap.c
 create mode 100644 tools/testing/selftests/futex/futex_wait_wouldblock.c
 create mode 100644 tools/testing/selftests/futex/logging.c
 create mode 100644 tools/testing/selftests/futex/logging.h
 create mode 100755 tools/testing/selftests/futex/run.sh

-- 
1.7.5.1

