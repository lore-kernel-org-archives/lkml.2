Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2CaRx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 13:53:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58941 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2CaRx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 13:53:57 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perl: fix build failure ("linux/module.h" not found)
Date: Sat, 31 Mar 2012 20:58:27 +0300
Message-Id: <1333216707-23469-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

    CC util/rbtree.o
../../lib/rbtree.c:24:26: fatal error: linux/export.h: No such file or directory
compilation terminated.
make: *** [util/rbtree.o] Error 1

Follow linux/module.h -> linux/export.h rename.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 tools/perf/Makefile                    |    2 +-
 tools/perf/util/include/linux/export.h |    6 ++++++
 tools/perf/util/include/linux/module.h |    6 ------
 3 files changed, 7 insertions(+), 7 deletions(-)
 create mode 100644 tools/perf/util/include/linux/export.h
 delete mode 100644 tools/perf/util/include/linux/module.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74fd7f8..3c32126 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -249,7 +249,7 @@ LIB_H += util/include/linux/const.h
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
1.7.8.5

