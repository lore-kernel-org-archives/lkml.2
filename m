Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2INF7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:59:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2INF7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:59:45 -0400
Date: Thu, 13 Sep 2012 22:59:15 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-b232e0732b1d763834c3d5b098d25d59337ba075@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1347295819-23177-3-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add memdup function
Git-Commit-ID: b232e0732b1d763834c3d5b098d25d59337ba075
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:59:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b232e0732b1d763834c3d5b098d25d59337ba075
Gitweb:     http://git.kernel.org/tip/b232e0732b1d763834c3d5b098d25d59337ba075
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 10 Sep 2012 18:50:17 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 12:04:41 -0300

perf tools: Add memdup function

Adding memdup function to duplicate region of memory.

  void *memdup(const void *src, size_t len)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347295819-23177-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/string.h |    2 ++
 tools/perf/util/string.c               |   18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

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
