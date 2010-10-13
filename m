Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0JMFIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:08:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0JMFHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=YaNnzUZstwjkw/uVCKDgDByOiVIXNo7WpV4zQjwrFMLA2nJuRHHKUCbdyMIW7cimGC
         XJIe+b88eIwBv3J4fZ8BKnSMG3uGgA+938xWIbR7HTM3PuzKnS2QIbJ9gflYKI3ZzXus
         JkRuGZLNPhdcXUru20APLTcezIkU1jLQhwWhc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 7/9] perf: Support for error passed over pointers
Date: Wed, 13 Oct 2010 07:06:59 +0200
Message-Id: <1286946421-32202-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the linux/err.h that carries the ERR_PTR/PTR_ERR/IS_ERR
macros so that they also become usable by perf.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Makefile                 |    1 +
 tools/perf/util/include/linux/err.h |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/err.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 28de60b..1146195 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -375,6 +375,7 @@ LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
+LIB_H += util/include/linux/err.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
diff --git a/tools/perf/util/include/linux/err.h b/tools/perf/util/include/linux/err.h
new file mode 100644
index 0000000..4e6dc36
--- /dev/null
+++ b/tools/perf/util/include/linux/err.h
@@ -0,0 +1,24 @@
+#ifndef PERF_ERR_H
+#define PERF_ERR_H
+
+
+#define MAX_ERRNO	4095
+
+#define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
+
+static inline void *ERR_PTR(long err)
+{
+	return (void *) err;
+}
+
+static inline long PTR_ERR(const void *ptr)
+{
+	return (long) ptr;
+}
+
+static inline long IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+
+#endif /* PERF_ERR_H */
-- 
1.6.2.3

