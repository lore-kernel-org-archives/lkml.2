Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0KZNYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:24:51 -0500
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:40318 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860Ab0KZNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:24:50 -0500
Subject: [PATCH] perf: add GCC optimization to memory allocating functions
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 10:24:24 -0300
Message-ID: <1290777864.2373.2.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

We can benefit from the alloc_size attribute in xrealloc and zalloc.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 tools/perf/util/util.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7562707..41a5067 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -182,10 +182,11 @@ static inline char *gitstrchrnul(const char *s, int c)
  * Wrappers:
  */
 extern char *xstrdup(const char *str);
-extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
+extern void *xrealloc(void *ptr, size_t size) __attribute__((weak, alloc_size(2)));
 
 
-static inline void *zalloc(size_t size)
+static inline __attribute__((alloc_size(1)))
+void *zalloc(size_t size)
 {
 	return calloc(1, size);
 }
-- 
1.7.1





