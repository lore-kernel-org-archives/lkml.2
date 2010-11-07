Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0KGVQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:16:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22133 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0KGVQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:16:02 -0500
Date: Sun, 7 Nov 2010 22:04:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UWB: Return UWB_RSV_ALLOC_NOT_FOUND rather than crashing on
 NULL dereference if kzalloc fails
Message-ID: <alpine.LNX.2.00.1011072158211.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Crashing on a null pointer deref is never a nice thing to do. It seems to 
me that it's better to simply return UWB_RSV_ALLOC_NOT_FOUND if kzalloc() 
fails in uwb_rsv_find_best_allocation().

I may be wrong since I have no way to test this (except compile test) and 
this is unknown code to me, so please review carefully.

Please CC me on replies.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 allocator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/uwb/allocator.c b/drivers/uwb/allocator.c
index 436e4f7..e45e673 100644
--- a/drivers/uwb/allocator.c
+++ b/drivers/uwb/allocator.c
@@ -326,7 +326,8 @@ int uwb_rsv_find_best_allocation(struct uwb_rsv *rsv, struct uwb_mas_bm *availab
 	int bit_index;
 
 	ai = kzalloc(sizeof(struct uwb_rsv_alloc_info), GFP_KERNEL);
-	
+	if (!ai)
+		return UWB_RSV_ALLOC_NOT_FOUND;
 	ai->min_mas = rsv->min_mas;
 	ai->max_mas = rsv->max_mas;
 	ai->max_interval = rsv->max_interval;


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

