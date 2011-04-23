Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1DWQcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:32:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35115 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1DWQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:45 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/18] perf: Export debugfs utilities
Date: Sat, 23 Apr 2011 18:28:12 +0200
Message-Id: <1303576100-425-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export /proc/mounts parser and other debugfs-related helpers for general
use.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile                                     |    9 ++++-
 tools/lib/lk/Makefile                              |   41 ++++++++++++++++++++
 tools/{perf/util => lib/lk}/debugfs.c              |    2 +-
 tools/{perf/util => lib/lk}/debugfs.h              |    7 ++-
 tools/{perf/util => lib/lk}/types.h                |    6 +-
 tools/{perf/util => lib/lk}/usage.c                |    0
 tools/{perf/util => lib/lk}/util.c                 |    2 +-
 tools/{perf/util => lib/lk}/util.h                 |    0
 tools/lib/perf/shared.h                            |    9 ++++
 tools/lib/trace/event-info.c                       |    2 +-
 tools/lib/trace/event-parse.c                      |    2 +-
 tools/lib/trace/event-read.c                       |    2 +-
 tools/perf/Makefile                                |    9 +----
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-annotate.c                      |    4 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin-diff.c                          |    2 +-
 tools/perf/builtin-evlist.c                        |    3 +-
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-probe.c                         |    4 +-
 tools/perf/builtin-record.c                        |    2 +-
 tools/perf/builtin-report.c                        |    2 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-script.c                        |    2 +-
 tools/perf/builtin-stat.c                          |    2 +-
 tools/perf/builtin-timechart.c                     |    2 +-
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/builtin.h                               |    2 +-
 tools/perf/perf.c                                  |   21 +++++++---
 tools/perf/perf.h                                  |    2 +-
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/annotate.h                         |    2 +-
 tools/perf/util/build-id.c                         |    2 +-
 tools/perf/util/cache.h                            |    3 +-
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/cgroup.c                           |    4 +-
 tools/perf/util/config.c                           |    2 +-
 tools/perf/util/cpumap.c                           |    2 +-
 tools/perf/util/debug.c                            |    2 +-
 tools/perf/util/evlist.c                           |    2 +-
 tools/perf/util/evsel.c                            |    2 +-
 tools/perf/util/evsel.h                            |    2 +-
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/header.h                           |    2 +-
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/include/linux/ctype.h              |    2 +-
 tools/perf/util/map.h                              |    2 +-
 tools/perf/util/parse-events.c                     |    4 +-
 tools/perf/util/parse-options.c                    |    2 +-
 tools/perf/util/probe-event.c                      |    4 +-
 tools/perf/util/probe-finder.c                     |    2 +-
 tools/perf/util/probe-finder.h                     |    2 +-
 tools/perf/util/pstack.c                           |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 tools/perf/util/session.c                          |    2 +-
 tools/perf/util/setup.py                           |    2 +-
 tools/perf/util/sort.h                             |    2 +-
 tools/perf/util/strfilter.c                        |    2 +-
 tools/perf/util/string.c                           |    2 +-
 tools/perf/util/svghelper.h                        |    2 +-
 tools/perf/util/thread.c                           |    2 +-
 tools/perf/util/top.h                              |    2 +-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/ui/browser.c                       |    2 +-
 tools/perf/util/ui/browser.h                       |    2 +-
 tools/perf/util/ui/browsers/hists.c                |    2 +-
 tools/perf/util/values.c                           |    2 +-
 tools/perf/util/values.h                           |    2 +-
 tools/perf/util/xyarray.c                          |    2 +-
 74 files changed, 150 insertions(+), 94 deletions(-)
 create mode 100644 tools/lib/lk/Makefile
 rename tools/{perf/util => lib/lk}/debugfs.c (99%)
 rename tools/{perf/util => lib/lk}/debugfs.h (85%)
 rename tools/{perf/util => lib/lk}/types.h (83%)
 rename tools/{perf/util => lib/lk}/usage.c (100%)
 rename tools/{perf/util => lib/lk}/util.c (98%)
 rename tools/{perf/util => lib/lk}/util.h (100%)
 create mode 100644 tools/lib/perf/shared.h

diff --git a/tools/Makefile b/tools/Makefile
index 48f0720..f302177 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -9,12 +9,18 @@ BASIC_CFLAGS = -I$(CURDIR)/lib
 BASIC_CFLAGS += -I$(CURDIR)/perf/util/include
 export BASIC_CFLAGS
 
-perf: libtrace .FORCE
+PYRF_OBJS =
+export PYRF_OBJS
+
+perf: libtrace liblk .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
 firewire: .FORCE
 	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1)
 
+liblk: .FORCE
+	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1)
+
 libtrace: .FORCE
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
 
@@ -36,6 +42,7 @@ x86_energy: .FORCE
 clean:
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)power/x86/turbostat/ $(QUIET_SUBDIR1) clean
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
new file mode 100644
index 0000000..b192853
--- /dev/null
+++ b/tools/lib/lk/Makefile
@@ -0,0 +1,41 @@
+include ../../scripts/Makefile.lib
+
+# guard against environment variables
+LIB_H=
+LIB_OBJS=
+
+LIB_H += debugfs.h
+LIB_H += util.h
+LIB_H += types.h
+
+LIB_OBJS += debugfs.o
+LIB_OBJS += usage.o
+LIB_OBJS += util.o
+
+PYRF_OBJS += util.o
+
+LIBFILE = $(LIB_OUTPUT)liblk.a
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS) $(LIBFILE)
+
+.PHONY: clean
diff --git a/tools/perf/util/debugfs.c b/tools/lib/lk/debugfs.c
similarity index 99%
rename from tools/perf/util/debugfs.c
rename to tools/lib/lk/debugfs.c
index a88fefc..569b6b2 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -1,6 +1,6 @@
 #include "util.h"
 #include "debugfs.h"
-#include "cache.h"
+#include <perf/shared.h>
 
 static int debugfs_premounted;
 static char debugfs_mountpoint[MAX_PATH+1];
diff --git a/tools/perf/util/debugfs.h b/tools/lib/lk/debugfs.h
similarity index 85%
rename from tools/perf/util/debugfs.h
rename to tools/lib/lk/debugfs.h
index 83a0287..8d12a5b 100644
--- a/tools/perf/util/debugfs.h
+++ b/tools/lib/lk/debugfs.h
@@ -1,7 +1,8 @@
-#ifndef __DEBUGFS_H__
-#define __DEBUGFS_H__
+#ifndef __LK_DEBUGFS_H__
+#define __LK_DEBUGFS_H__
 
 #include <sys/mount.h>
+#include <sys/types.h>
 
 #ifndef MAX_PATH
 # define MAX_PATH 256
@@ -22,4 +23,4 @@ extern int debugfs_read(const char *entry, char *buffer, size_t size);
 extern void debugfs_force_cleanup(void);
 extern int debugfs_make_path(const char *element, char *buffer, int size);
 
-#endif /* __DEBUGFS_H__ */
+#endif /* __LK_DEBUGFS_H__ */
diff --git a/tools/perf/util/types.h b/tools/lib/lk/types.h
similarity index 83%
rename from tools/perf/util/types.h
rename to tools/lib/lk/types.h
index 5f3689a..587ebc8 100644
--- a/tools/perf/util/types.h
+++ b/tools/lib/lk/types.h
@@ -1,5 +1,5 @@
-#ifndef __PERF_TYPES_H
-#define __PERF_TYPES_H
+#ifndef __LK_TYPES_H
+#define __LK_TYPES_H
 
 #include <stdint.h>
 
@@ -16,4 +16,4 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
-#endif /* __PERF_TYPES_H */
+#endif /* __LK_TYPES_H */
diff --git a/tools/perf/util/usage.c b/tools/lib/lk/usage.c
similarity index 100%
rename from tools/perf/util/usage.c
rename to tools/lib/lk/usage.c
diff --git a/tools/perf/util/util.c b/tools/lib/lk/util.c
similarity index 98%
rename from tools/perf/util/util.c
rename to tools/lib/lk/util.c
index 5b3ea49..87c30b1 100644
--- a/tools/perf/util/util.c
+++ b/tools/lib/lk/util.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include <sys/mman.h>
 
 int mkdir_p(char *path, mode_t mode)
diff --git a/tools/perf/util/util.h b/tools/lib/lk/util.h
similarity index 100%
rename from tools/perf/util/util.h
rename to tools/lib/lk/util.h
diff --git a/tools/lib/perf/shared.h b/tools/lib/perf/shared.h
new file mode 100644
index 0000000..77344ff
--- /dev/null
+++ b/tools/lib/perf/shared.h
@@ -0,0 +1,9 @@
+#ifndef __PERF_SHARED_H
+#define __PERF_SHARED_H
+
+/*
+ * Common defines shared between perf and the libs
+ */
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+
+#endif /* __PERF_SHARED_H */
diff --git a/tools/lib/trace/event-info.c b/tools/lib/trace/event-info.c
index 5270a64..dbc6ba9 100644
--- a/tools/lib/trace/event-info.c
+++ b/tools/lib/trace/event-info.c
@@ -39,7 +39,7 @@
 
 #include "../../perf/perf.h"
 #include "trace-event.h"
-#include "../perf/util/debugfs.h"
+#include <lk/debugfs.h>
 #include "../perf/util/evsel.h"
 
 #define VERSION "0.5"
diff --git a/tools/lib/trace/event-parse.c b/tools/lib/trace/event-parse.c
index 4a52cb8..da49703 100644
--- a/tools/lib/trace/event-parse.c
+++ b/tools/lib/trace/event-parse.c
@@ -30,7 +30,7 @@
 
 #undef _GNU_SOURCE
 #include "../../perf/perf.h"
-#include "../../perf/util/util.h"
+#include <lk/util.h>
 #include "trace-event.h"
 
 int header_page_ts_offset;
diff --git a/tools/lib/trace/event-read.c b/tools/lib/trace/event-read.c
index f65dcaa..1eda805 100644
--- a/tools/lib/trace/event-read.c
+++ b/tools/lib/trace/event-read.c
@@ -37,7 +37,7 @@
 #include <errno.h>
 
 #include "../../perf/perf.h"
-#include "../../perf/util/util.h"
+#include <lk/util.h>
 #include "trace-event.h"
 
 static int input_fd;
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2c82f7f..692b1ad 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -176,7 +176,7 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a
+EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a
 
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
@@ -212,18 +212,15 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/debugfs.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
-LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
-LIB_H += util/util.h
 LIB_H += util/xyarray.h
 LIB_H += util/header.h
 LIB_H += util/help.h
@@ -255,7 +252,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
@@ -276,7 +272,6 @@ LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/strfilter.o
 LIB_OBJS += $(OUTPUT)util/top.o
-LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
@@ -296,7 +291,6 @@ LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
@@ -346,7 +340,6 @@ PYRF_OBJS += $(OUTPUT)util/evlist.o
 PYRF_OBJS += $(OUTPUT)util/evsel.o
 PYRF_OBJS += $(OUTPUT)util/python.o
 PYRF_OBJS += $(OUTPUT)util/thread_map.o
-PYRF_OBJS += $(OUTPUT)util/util.o
 PYRF_OBJS += $(OUTPUT)util/xyarray.o
 
 #
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index db82021..96e0ff3 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -8,7 +8,7 @@
 #include <ctype.h>
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <lk/util.h>
 #include "../util/parse-options.h"
 #include "../util/header.h"
 #include "bench.h"
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index d1d1b30..37f12ad 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -10,7 +10,7 @@
  */
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <lk/util.h>
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 0c7454f..3367404 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -11,7 +11,7 @@
  */
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <lk/util.h>
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e18eb7e..2003f27 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -7,9 +7,9 @@
  */
 #include "builtin.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..4ae8ea2 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -17,7 +17,7 @@
  */
 
 #include "perf.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/parse-options.h"
 #include "builtin.h"
 #include "bench/bench.h"
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e821999..7005bdf 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -12,7 +12,7 @@
 #include "util/session.h"
 #include "util/sort.h"
 #include "util/symbol.h"
-#include "util/util.h"
+#include <lk/util.h>
 
 #include <stdlib.h>
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 4c5e9e0..356573c 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -4,8 +4,7 @@
  */
 #include "builtin.h"
 
-#include "util/util.h"
-
+#include <lk/util.h>
 #include <linux/list.h>
 
 #include "perf.h"
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 49062b6..47b50ec 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 1981fe4..e09ed03 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index f73806f..cdadb47 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2c0e64d..21e199a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -34,12 +34,12 @@
 #undef _GNU_SOURCE
 #include "perf.h"
 #include "builtin.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/strlist.h"
 #include "util/strfilter.h"
 #include "util/symbol.h"
 #include "util/debug.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4497a38..9ebfc4d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -12,7 +12,7 @@
 #include "perf.h"
 
 #include "util/build-id.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 498c6f7..876d3e2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -7,7 +7,7 @@
  */
 #include "builtin.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 
 #include "util/annotate.h"
 #include "util/color.h"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26fb319..b56426a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1,7 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/cache.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f4c0d50..8ff8e1b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -11,7 +11,7 @@
 #include "util/thread.h"
 #include <trace/trace-event.h>
 #include "util/parse-options.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/evlist.h"
 #include "util/evsel.h"
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 03f0e45..8a9b057 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -39,7 +39,7 @@
 
 #include "perf.h"
 #include "builtin.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9782c9a..27283c5 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -14,7 +14,7 @@
 
 #include "builtin.h"
 
-#include "util/util.h"
+#include <lk/util.h>
 
 #include "util/color.h"
 #include <linux/list.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7fd50c1..22f4528 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -30,7 +30,7 @@
 #include "util/thread.h"
 #include "util/thread_map.h"
 #include "util/top.h"
-#include "util/util.h"
+#include <lk/util.h>
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 4702e24..a34c6b5 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -1,7 +1,7 @@
 #ifndef BUILTIN_H
 #define BUILTIN_H
 
-#include "util/util.h"
+#include <lk/util.h>
 #include "util/strbuf.h"
 
 extern const char perf_version_string[];
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ec635b7..9b47067 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,7 +13,8 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
+#include <perf/shared.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -417,14 +418,17 @@ static int run_argv(int *argcp, const char ***argv)
 }
 
 /* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
-static void get_debugfs_mntpt(void)
+static bool get_debugfs_mntpt(void)
 {
 	const char *path = debugfs_mount(NULL);
 
-	if (path)
+	if (path) {
 		strncpy(debugfs_mntpt, path, sizeof(debugfs_mntpt));
-	else
-		debugfs_mntpt[0] = '\0';
+		return true;
+	}
+
+	debugfs_mntpt[0] = '\0';
+	return false;
 }
 
 int main(int argc, const char **argv)
@@ -434,8 +438,11 @@ int main(int argc, const char **argv)
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
-	/* get debugfs mount point from /proc/mounts */
-	get_debugfs_mntpt();
+
+	/* Establish a debugfs mountpoint */
+	if (!get_debugfs_mntpt())
+		die("cannot find valid debugfs mountpoint");
+
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a5fc660..7078b4f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -91,7 +91,7 @@ void get_term_dimensions(struct winsize *ws);
 #include <sys/syscall.h>
 
 #include "../../include/linux/perf_event.h"
-#include "util/types.h"
+#include <lk/types.h>
 #include <stdbool.h>
 
 struct perf_mmap {
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e01af2b..e9f5d02 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -7,7 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 
-#include "util.h"
+#include <lk/util.h>
 #include "build-id.h"
 #include "color.h"
 #include "cache.h"
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c2c2868..b139a25 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -2,7 +2,7 @@
 #define __PERF_ANNOTATE_H
 
 #include <stdbool.h>
-#include "types.h"
+#include <lk/types.h>
 #include "symbol.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index a91cd99..1a381a4 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2009, 2010 Red Hat Inc.
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
-#include "util.h"
+#include <lk/util.h>
 #include <stdio.h>
 #include "build-id.h"
 #include "event.h"
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index ced8cee..02d764b 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -2,7 +2,7 @@
 #define __PERF_CACHE_H
 
 #include <stdbool.h>
-#include "util.h"
+#include <lk/util.h>
 #include "strbuf.h"
 #include "../perf.h"
 #include <linux/compiler.h>
@@ -16,7 +16,6 @@
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
 #define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
 #define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
-#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9f7106a..c5fad20 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,7 +15,7 @@
 #include <errno.h>
 #include <math.h>
 
-#include "util.h"
+#include <lk/util.h>
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain,
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 96bee5c..99267b3 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -1,9 +1,9 @@
-#include "util.h"
+#include <lk/util.h>
 #include "../perf.h"
 #include "parse-options.h"
 #include "evsel.h"
 #include "cgroup.h"
-#include "debugfs.h" /* MAX_PATH, STR() */
+#include <lk/debugfs.h> /* MAX_PATH, STR() */
 #include "evlist.h"
 
 int nr_cgroups;
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index e02d78c..bb2f5a0 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -5,7 +5,7 @@
  * Copyright (C) Johannes Schindelin, 2005
  *
  */
-#include "util.h"
+#include <lk/util.h>
 #include "cache.h"
 #include "exec_cmd.h"
 
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 6893eec..02755d5 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 155749d..45dfab7 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -10,7 +10,7 @@
 #include "color.h"
 #include "event.h"
 #include "debug.h"
-#include "util.h"
+#include <lk/util.h>
 
 int verbose;
 bool dump_trace = false, quiet = false;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 65a8031..7a270ed 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -11,8 +11,8 @@
 #include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
-#include "util.h"
 #include "debug.h"
+#include <lk/util.h>
 
 #include <sys/mman.h>
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 13ee267..e76773c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -9,7 +9,7 @@
 
 #include "evsel.h"
 #include "evlist.h"
-#include "util.h"
+#include <lk/util.h>
 #include "cpumap.h"
 #include "thread_map.h"
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f79bb2c..526deed 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -4,7 +4,7 @@
 #include <linux/list.h>
 #include <stdbool.h>
 #include "../../../include/linux/perf_event.h"
-#include "types.h"
+#include <lk/types.h>
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ac26a5c..4c89af6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -10,7 +10,7 @@
 
 #include "evlist.h"
 #include "evsel.h"
-#include "util.h"
+#include <lk/util.h>
 #include "header.h"
 #include "../perf.h"
 #include <trace/trace-event.h>
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 456661d..418f488 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -4,7 +4,7 @@
 #include "../../../include/linux/perf_event.h"
 #include <sys/types.h>
 #include <stdbool.h>
-#include "types.h"
+#include <lk/types.h>
 #include "event.h"
 
 #include <linux/bitmap.h>
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 627a02e..b3a16a3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,5 +1,5 @@
 #include "annotate.h"
-#include "util.h"
+#include <lk/util.h>
 #include "build-id.h"
 #include "hist.h"
 #include "session.h"
diff --git a/tools/perf/util/include/linux/ctype.h b/tools/perf/util/include/linux/ctype.h
index a53d4ee..0698f26 100644
--- a/tools/perf/util/include/linux/ctype.h
+++ b/tools/perf/util/include/linux/ctype.h
@@ -1 +1 @@
-#include "../util.h"
+#include <lk/util.h>
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index b397c03..7e78d8b 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -6,7 +6,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include "types.h"
+#include <lk/types.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 952b4ae..18f2d1c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,5 +1,5 @@
 #include "../../../include/linux/hw_breakpoint.h"
-#include "util.h"
+#include <lk/util.h>
 #include "../perf.h"
 #include "evlist.h"
 #include "evsel.h"
@@ -10,7 +10,7 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 
 struct event_symbol {
 	u8		type;
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 99d02aa..25b57fc 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "parse-options.h"
 #include "cache.h"
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9c074ea..b815435 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -34,7 +34,7 @@
 #include <elf.h>
 
 #undef _GNU_SOURCE
-#include "util.h"
+#include <lk/util.h>
 #include "event.h"
 #include "string.h"
 #include "strlist.h"
@@ -43,7 +43,7 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include <trace/trace-event.h>	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a7c7145..bc1ef2ad 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -36,7 +36,7 @@
 #include <linux/bitops.h>
 #include "event.h"
 #include "debug.h"
-#include "util.h"
+#include <lk/util.h>
 #include "symbol.h"
 #include "probe-finder.h"
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 605730a..717b487 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -2,7 +2,7 @@
 #define _PROBE_FINDER_H
 
 #include <stdbool.h>
-#include "util.h"
+#include <lk/util.h>
 #include "probe-event.h"
 
 #define MAX_PATH_LEN		 256
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index 13d36fa..aacedb8 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -4,7 +4,7 @@
  * (c) 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
 
-#include "util.h"
+#include <lk/util.h>
 #include "pstack.h"
 #include <linux/kernel.h>
 #include <stdlib.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 0c1ba9b..0cbf11c 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
+#include <lk/util.h>
 #include <trace/trace-event.h>
 
 #include <EXTERN.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 79caf91..c8e6d35 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -28,7 +28,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
+#include <lk/util.h>
 #include <trace/trace-event.h>
 
 PyMODINIT_FUNC initperf_trace_context(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fff6674..46c80de 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -11,7 +11,7 @@
 #include "evsel.h"
 #include "session.h"
 #include "sort.h"
-#include "util.h"
+#include <lk/util.h>
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index bbc982f..78a9b98 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -9,7 +9,7 @@ cflags += getenv('CFLAGS', '').split()
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
-			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c'],
+			     '../lib/lk/util.c', 'util/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
                  )
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0b91053..ecfd0c6 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -2,7 +2,7 @@
 #define __PERF_SORT_H
 #include "../builtin.h"
 
-#include "util.h"
+#include <lk/util.h>
 
 #include "color.h"
 #include <linux/list.h>
diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
index 834c8eb..3d4939d 100644
--- a/tools/perf/util/strfilter.c
+++ b/tools/perf/util/strfilter.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "string.h"
 #include "strfilter.h"
 
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index b9a985d..109e486 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <lk/util.h>
 #include "string.h"
 
 #define K 1024LL
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index e078198..ac74b40 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_SVGHELPER_H
 #define __PERF_SVGHELPER_H
 
-#include "types.h"
+#include <lk/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index d5d3b22..604d3c7 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include "session.h"
 #include "thread.h"
-#include "util.h"
+#include <lk/util.h>
 #include "debug.h"
 
 static struct thread *thread__new(pid_t pid)
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index bfbf95b..180b1cb8 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_TOP_H
 #define __PERF_TOP_H 1
 
-#include "types.h"
+#include <lk/types.h>
 #include "../perf.h"
 #include <stddef.h>
 #include <pthread.h>
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 205ec96..f9b8950 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
+#include <lk/util.h>
 #include <trace/trace-event.h>
 
 struct scripting_context *scripting_context;
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 611219f..036bb5c 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -8,7 +8,7 @@
 #include "browser.h"
 #include "helpline.h"
 #include "../color.h"
-#include "../util.h"
+#include <lk/util.h>
 #include <stdio.h>
 
 static int ui_browser__percent_color(double percent, bool current)
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index fc63dda..4b5834c 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -4,7 +4,7 @@
 #include <stdbool.h>
 #include <newt.h>
 #include <sys/types.h>
-#include "../types.h"
+#include <lk/types.h>
 
 #define HE_COLORSET_TOP		50
 #define HE_COLORSET_MEDIUM	51
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 5d767c6..453aad2 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -12,7 +12,7 @@
 #include "../../hist.h"
 #include "../../pstack.h"
 #include "../../sort.h"
-#include "../../util.h"
+#include <lk/util.h>
 
 #include "../browser.h"
 #include "../helpline.h"
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index bdd3347..f544f92 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -1,6 +1,6 @@
 #include <stdlib.h>
 
-#include "util.h"
+#include <lk/util.h>
 #include "values.h"
 
 void perf_read_values_init(struct perf_read_values *values)
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index 2fa967e..f762cb7 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_VALUES_H
 #define __PERF_VALUES_H
 
-#include "types.h"
+#include <lk/types.h>
 
 struct perf_read_values {
 	int threads;
diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
index 22afbf6..979a90f 100644
--- a/tools/perf/util/xyarray.c
+++ b/tools/perf/util/xyarray.c
@@ -1,5 +1,5 @@
 #include "xyarray.h"
-#include "util.h"
+#include <lk/util.h>
 
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
 {
-- 
1.7.4.rc2

