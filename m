Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2FJKvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:51:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2FJKuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:50:12 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3 06/10] mm: frontswap: make all branches of if statement in put page consistent
Date: Sun, 10 Jun 2012 12:51:04 +0200
Message-Id: <1339325468-30614-7-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it has a complex structure where different things are compared
at each branch. Simplify that and make both branches look similar.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index e6353d9..d8dc986 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -140,16 +140,16 @@ int __frontswap_store(struct page *page)
 		inc_frontswap_succ_stores();
 		if (!dup)
 			atomic_inc(&sis->frontswap_pages);
-	} else if (dup) {
+	} else {
 		/*
 		  failed dup always results in automatic invalidate of
 		  the (older) page from frontswap
 		 */
-		frontswap_clear(sis, offset);
-		atomic_dec(&sis->frontswap_pages);
-		inc_frontswap_failed_stores();
-	} else {
 		inc_frontswap_failed_stores();
+		if (dup) {
+			frontswap_clear(sis, offset);
+			atomic_dec(&sis->frontswap_pages);
+		}
 	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
-- 
1.7.8.6

