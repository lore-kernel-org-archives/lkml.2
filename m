Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2INFyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:54:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2INFyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:54:05 -0400
Date: Thu, 13 Sep 2012 22:53:39 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@gmail.com>
Message-ID: <tip-f8fcd776212bcaa1e2359e39a43c1dbd752b8773@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, irina.tirdea@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1347315303-29906-2-git-send-email-irina.tirdea@intel.com>
References: <1347315303-29906-2-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: include wrapper for magic.h
Git-Commit-ID: f8fcd776212bcaa1e2359e39a43c1dbd752b8773
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:53:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8fcd776212bcaa1e2359e39a43c1dbd752b8773
Gitweb:     http://git.kernel.org/tip/f8fcd776212bcaa1e2359e39a43c1dbd752b8773
Author:     Irina Tirdea <irina.tirdea@gmail.com>
AuthorDate: Tue, 11 Sep 2012 01:14:58 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 11:38:10 -0300

perf tools: include wrapper for magic.h

perf is currently including magic.h directly from the kernel. If the
glibc magic.h is also included, this leads to warnings that the
constants are redefined. This happens on some systems (e.g. Android).

Redefinition errors on Android:
In file included from util/util.h:79:0,
                 from util/cache.h:5,
                 from util/abspath.c:1:
util/../../../include/linux/magic.h:5:0:
error: "AFFS_SUPER_MAGIC" redefined [-Werror]
bionic/libc/include/sys/vfs.h:53:0:
note: this is the location of the previous definition
util/../../../include/linux/magic.h:19:0:
error: "EFS_SUPER_MAGIC" redefined [-Werror]
bionic/libc/include/sys/vfs.h:61:0:
note: this is the location of the previous definition
util/../../../include/linux/magic.h:26:0:
error: "HPFS_SUPER_MAGIC" redefined [-Werror]
bionic/libc/include/sys/vfs.h:67:0:
note: this is the location of the previous definition

Only two constants from magic.h are used by perf (DEBUGFS_MAGIC and
SYSFS_MAGIC). This fix provides a wrapper for magic.h that includes only
these constants instead of including the kernel header file directly.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347315303-29906-2-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                   |    1 +
 tools/perf/util/include/linux/magic.h |   12 ++++++++++++
 tools/perf/util/util.h                |    2 +-
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e4b2e8f..1d2723c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -264,6 +264,7 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
+LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
diff --git a/tools/perf/util/include/linux/magic.h b/tools/perf/util/include/linux/magic.h
new file mode 100644
index 0000000..58b64ed
--- /dev/null
+++ b/tools/perf/util/include/linux/magic.h
@@ -0,0 +1,12 @@
+#ifndef _PERF_LINUX_MAGIC_H_
+#define _PERF_LINUX_MAGIC_H_
+
+#ifndef DEBUGFS_MAGIC
+#define DEBUGFS_MAGIC          0x64626720
+#endif
+
+#ifndef SYSFS_MAGIC
+#define SYSFS_MAGIC            0x62656572
+#endif
+
+#endif
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 67a3713..70fa70b 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -70,7 +70,7 @@
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
-#include "../../../include/linux/magic.h"
+#include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
 
