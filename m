Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab2DICzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:55:55 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64221 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2DICyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:39 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-bd-4f824f6c4977
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] parse-events: Fix printk_cmp()
Date: Mon,  9 Apr 2012 11:54:29 +0900
Message-Id: <1333940074-19052-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The printk_cmp function should use printk_map instead of func_map.
Also rename the variables for consistency.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 5214771..f90af1a 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -507,12 +507,12 @@ struct printk_list {
 
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
1.7.7.6

