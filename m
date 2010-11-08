Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0KHXVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:21:07 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19235 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0KHXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:21:05 -0500
Date: Tue, 9 Nov 2010 00:09:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, Vipin Mehta <vmehta@atheros.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 09/17][trivial] staging, ath6kl: Remove unnecessary casts of
 void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082338300.23697@swampdragon.chaosbits.net>
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

This patch removes such casts from drivers/staging/ath6kl/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 hif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index c307a55..6454a86 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -1188,7 +1188,7 @@ addHifDevice(struct sdio_func *func)
     HIF_DEVICE *hifdevice;
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: addHifDevice\n"));
     AR_DEBUG_ASSERT(func != NULL);
-    hifdevice = (HIF_DEVICE *)kzalloc(sizeof(HIF_DEVICE), GFP_KERNEL);
+    hifdevice = kzalloc(sizeof(HIF_DEVICE), GFP_KERNEL);
     AR_DEBUG_ASSERT(hifdevice != NULL);
 #if HIF_USE_DMA_BOUNCE_BUFFER
     hifdevice->dma_buffer = kmalloc(HIF_DMA_BUFFER_SIZE, GFP_KERNEL);



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

