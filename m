Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1JQSOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:14:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57787 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1JQSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:14:11 -0400
Subject: [PATCH] drivers, vmw_balloon.c: Determine page allocation flag
 can_sleep outside loop.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dtor@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 00:13:47 +0600
Message-ID: <1318875227.10091.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In vmballoon_reserve_page function, flags has been passed from the callee function (vmballoon_inflate here). So, we can determine can_sleep outside the loop.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 053d36c..6983d80 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -412,6 +412,7 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 	gfp_t flags;
 	unsigned int hv_status;
 	bool locked = false;
+	flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
 
 	do {
 		if (!can_sleep)
@@ -419,7 +420,6 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 		else
 			STATS_INC(b->stats.sleep_alloc);
 
-		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
 		page = alloc_page(flags);
 		if (!page) {
 			if (!can_sleep)


