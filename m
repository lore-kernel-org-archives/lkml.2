Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2CZJRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:17:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2CZJRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:17:23 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Switch module.h into export.h
Date: Mon, 26 Mar 2012 11:17:05 +0200
Message-Id: <1332753425-3299-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf build is broken due to following change in
lib/rbtree.c object:

  lib: reduce the use of module.h wherever possible
  commit 8bc3bcc93a2b4e47d5d410146f6546bca6171663
  Author: Paul Gortmaker <paul.gortmaker@windriver.com>
  Date:   Wed Nov 16 21:29:17 2011 -0500

We need to move module.h header into export.h.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                    |    2 +-
 tools/perf/util/include/linux/export.h |    6 ++++++
 tools/perf/util/include/linux/module.h |    6 ------
 3 files changed, 7 insertions(+), 7 deletions(-)
 create mode 100644 tools/perf/util/include/linux/export.h
 delete mode 100644 tools/perf/util/include/linux/module.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b492e3a..2f42886 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -251,7 +251,7 @@ LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
-LIB_H += util/include/linux/module.h
+LIB_H += util/include/linux/export.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
new file mode 100644
index 0000000..b43e2dc
--- /dev/null
+++ b/tools/perf/util/include/linux/export.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_MODULE_H
+#define PERF_LINUX_MODULE_H
+
+#define EXPORT_SYMBOL(name)
+
+#endif
diff --git a/tools/perf/util/include/linux/module.h b/tools/perf/util/include/linux/module.h
deleted file mode 100644
index b43e2dc..0000000
--- a/tools/perf/util/include/linux/module.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef PERF_LINUX_MODULE_H
-#define PERF_LINUX_MODULE_H
-
-#define EXPORT_SYMBOL(name)
-
-#endif
-- 
1.7.6.5

