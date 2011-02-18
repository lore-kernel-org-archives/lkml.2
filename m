Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1BRBqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:46:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1BRBqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:46:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T6e9xAJHpvGIEpcWEjrwHSY2pgDAS55vDzbwSb1KnnWN5rjjL9Sm9D1xswt8MFrzPz
         FgJpFAvyM/KH7HHqxzRM1RPU9/PxhFc7Gp3aqxeQvkHelS4ujWQw7d6oLv2O5dA+cMvd
         XE+AKcYzO60ZeMFwb8HAwatVv/t5l/qJke0fo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] mm: fix dubious code in __count_immobile_pages()
Date: Fri, 18 Feb 2011 10:46:26 +0900
Message-Id: <1297993586-3514-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pfn_valid_within() failed 'iter' was incremented twice.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_alloc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8b02771ccea..bf83d1c1d648 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5380,10 +5380,9 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
 		unsigned long check = pfn + iter;
 
-		if (!pfn_valid_within(check)) {
-			iter++;
+		if (!pfn_valid_within(check))
 			continue;
-		}
+
 		page = pfn_to_page(check);
 		if (!page_count(page)) {
 			if (PageBuddy(page))
-- 
1.7.4

