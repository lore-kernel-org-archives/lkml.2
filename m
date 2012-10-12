Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab2JLJXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:23:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45681 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2JLJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:23:15 -0400
Date: Fri, 12 Oct 2012 11:23:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH] perf: Handle new rbtree implementation
Message-ID: <20121012092309.GA10341@gmail.com>
References: <20121012081947.GA20570@gmail.com>
 <20121012083926.GA30327@gmail.com>
 <20121012090810.GA11763@x1.osrc.amd.com>
 <20121012091105.GA31307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012091105.GA31307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6c4d077c467d689b5dd2f89cc69713f1bf4e31d7 Mon Sep 17 00:00:00 2001
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Date: Tue, 9 Oct 2012 20:01:56 +0200
Subject: [PATCH] perf: Handle new rbtree implementation

Perf build fails with the new rbtree implementation:

  ../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such file or directory compilation terminated.

Fix by updating the Makefile and adding a btree_augmented.h
wrapper.

Reported-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>
Link: http://lkml.kernel.org/r/20121009180156.GA245@x4
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile                              | 3 ++-
 tools/perf/util/include/linux/rbtree_augmented.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d7b8b54..2472645 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -270,6 +270,7 @@ LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
+LIB_H += util/include/linux/rbtree_augmented.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
@@ -881,7 +882,7 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
diff --git a/tools/perf/util/include/linux/rbtree_augmented.h b/tools/perf/util/include/linux/rbtree_augmented.h
new file mode 100644
index 0000000..9d6fcdf
--- /dev/null
+++ b/tools/perf/util/include/linux/rbtree_augmented.h
@@ -0,0 +1,2 @@
+#include <stdbool.h>
+#include "../../../../include/linux/rbtree_augmented.h"
