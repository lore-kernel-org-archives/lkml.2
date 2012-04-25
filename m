Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab2DYGX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:23:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50065 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931Ab2DYGWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:22:45 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-0e-4f9798329549
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 5/6] zsmalloc: remove unnecessary type casting
Date: Wed, 25 Apr 2012 15:23:13 +0900
Message-Id: <1335334994-22138-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335334994-22138-1-git-send-email-minchan@kernel.org>
References: <1335334994-22138-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's remove unnecessary type casting of (void *).

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index b7d31cc..ff089f8 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -644,8 +644,7 @@ void zs_free(struct zs_pool *pool, void *obj)
 	spin_lock(&class->lock);
 
 	/* Insert this object in containing zspage's freelist */
-	link = (struct link_free *)((unsigned char *)kmap_atomic(f_page)
-							+ f_offset);
+	link = (struct link_free *)(kmap_atomic(f_page)	+ f_offset);
 	link->next = first_page->freelist;
 	kunmap_atomic(link);
 	first_page->freelist = obj;
-- 
1.7.9.5

