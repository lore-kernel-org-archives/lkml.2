Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2JISCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:02:03 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:57365 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2JISB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:01:59 -0400
Date: Tue, 9 Oct 2012 20:01:56 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: Handln new rbtree implementation
Message-ID: <20121009180156.GA245@x4>
References: <20121009170734.GB32508@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009170734.GB32508@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf build fails with the new rbtree implementation:

../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such
file or
directory                                                                                      
compilation terminated.                                                  
make[2]: *** [util/rbtree.o] Error 1                                    
make[1]: *** [perf_install] Error 2                                     
make: *** [tools/perf_install] Error 2

Fix by updating the Makefile and adding a btree_augmented.h wrapper.

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 tools/perf/Makefile                                  | 3 ++-
 tools/perf/util/include/linux/rbtree.h               | 1 -
 tools/perf/util/include/linux/rbtree_augmented.h     | 2 ++
 tools/perf/util/scripting-engines/trace-event-perl.c | 2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/util/include/linux/rbtree_augmented.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 86258c2..9546ff5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -268,6 +268,7 @@ LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
+LIB_H += util/include/linux/rbtree_augmented.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
@@ -906,7 +907,7 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
index 9bcdc84..2a030c5 100644
--- a/tools/perf/util/include/linux/rbtree.h
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -1,3 +1,2 @@
 #include <stdbool.h>
-#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
diff --git a/tools/perf/util/include/linux/rbtree_augmented.h b/tools/perf/util/include/linux/rbtree_augmented.h
new file mode 100644
index 0000000..9d6fcdf
--- /dev/null
+++ b/tools/perf/util/include/linux/rbtree_augmented.h
@@ -0,0 +1,2 @@
+#include <stdbool.h>
+#include "../../../../include/linux/rbtree_augmented.h"
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index f80605e..f53889d 100644
-- 
Markus
