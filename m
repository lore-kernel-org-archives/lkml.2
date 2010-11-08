Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0KHXUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:20:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19132 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0KHXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:20:29 -0500
Date: Tue, 9 Nov 2010 00:09:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Kirk Lee <kirk@hpc.ee.ntu.edu.tw>
Subject: [PATCH 06/17][trivial] mtd: Remove unnecessary casts of void ptr
 returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082327290.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/mtd/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tqm8xxl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/tqm8xxl.c b/drivers/mtd/maps/tqm8xxl.c
index 6014698..c08e140 100644
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -139,7 +139,7 @@ static int __init init_tqm_mtd(void)
 			goto error_mem;
 		}
 
-		map_banks[idx]->name = (char *)kmalloc(16, GFP_KERNEL);
+		map_banks[idx]->name = kmalloc(16, GFP_KERNEL);
 
 		if (!map_banks[idx]->name) {
 			ret = -ENOMEM;



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

