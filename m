Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2IJQuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2IJQuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:50:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] perf tools: Add memdup function
Date: Mon, 10 Sep 2012 18:50:17 +0200
Message-Id: <1347295819-23177-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding memdup function to duplicate region of memory.

  void *memdup(const void *src, size_t len)

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/include/linux/string.h |  2 ++
 tools/perf/util/string.c               | 18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
index 3b2f590..6f19c54 100644
--- a/tools/perf/util/include/linux/string.h
+++ b/tools/perf/util/include/linux/string.h
@@ -1 +1,3 @@
 #include <string.h>
+
+void *memdup(const void *src, size_t len);
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 199bc4d..3217059 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "string.h"
+#include "linux/string.h"
 
 #define K 1024LL
 /*
@@ -335,3 +335,19 @@ char *rtrim(char *s)
 
 	return s;
 }
+
+/**
+ * memdup - duplicate region of memory
+ * @src: memory region to duplicate
+ * @len: memory region length
+ */
+void *memdup(const void *src, size_t len)
+{
+	void *p;
+
+	p = malloc(len);
+	if (p)
+		memcpy(p, src, len);
+
+	return p;
+}
-- 
1.7.11.4

