Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab2GDFmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:42:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58659 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2GDFjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:44 -0400
X-AuditID: 9c930179-b7cceae000004195-50-4ff3d71cc529
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 06/16] tools lib traceevent: Fix printk_cmp()
Date: Wed,  4 Jul 2012 14:35:20 +0900
Message-Id: <1341380130-23863-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
 <1341380130-23863-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The printk_cmp function should use printk_map instead of func_map.
Also rename the variables for consistency.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1333940074-19052-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index ddee5a8cf135..7815b8d2eabd 100644
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
1.7.10.4

