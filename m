Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0CPV5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab0CPV5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:57:42 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 01/10] perf tools: Introduce xzalloc() for detecting out
	of memory
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:05:21 -0400
Message-ID: <20100316220521.32050.85155.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing xzalloc() which wrapping zalloc() for detecting out of memory.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/util/util.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0f5b2a6..630902e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -295,6 +295,13 @@ extern void *xmemdupz(const void *data, size_t len);
 extern char *xstrndup(const char *str, size_t len);
 extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
 
+static inline void *xzalloc(size_t size)
+{
+	void *buf;
+	buf = xmalloc(size);
+	return memset(buf, 0, size);
+}
+
 static inline void *zalloc(size_t size)
 {
 	return calloc(1, size);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
