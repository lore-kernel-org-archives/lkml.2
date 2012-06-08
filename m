Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab2FHTQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:16:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62667 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab2FHTOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:14:54 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2 06/10] mm: frontswap: make all branches of if statement in put page consistent
Date: Fri,  8 Jun 2012 21:15:15 +0200
Message-Id: <1339182919-11432-7-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
References: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
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
index 1f1af0e..ee1763d 100644
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
-	} else
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

