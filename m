Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab2EWCms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:42:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49362 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933534Ab2EWCjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:06 -0400
X-AuditID: 9c93016f-b7c3cae000001954-8c-4fbc4dc69a11
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/22] lib/traceevent: Fix printk_cmp()
Date: Wed, 23 May 2012 11:36:44 +0900
Message-Id: <1337740619-27925-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The printk_cmp function should use printk_map instead of func_map.
Also rename the variables for consistency.

Link: http://lkml.kernel.org/r/1333940074-19052-3-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8282523f489d..58fa6eb6aa59 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -511,12 +511,12 @@ struct printk_list {
 
 static int printk_cmp(const void *a, const void *b)
 {
-	const struct func_map *fa = a;
-	const struct func_map *fb = b;
+	const struct printk_map *pa = a;
+	const struct printk_map *pb = b;
 
-	if (fa->addr < fb->addr)
+	if (pa->addr < pb->addr)
 		return -1;
-	if (fa->addr > fb->addr)
+	if (pa->addr > pb->addr)
 		return 1;
 
 	return 0;
-- 
1.7.10.1

