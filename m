Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab0FXFmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:42:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54870 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0FXFmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nbmqK1+v0F9y45GXXY+1pdhljnbFI3BUobJkI4GlTQSwDyT3HVDiSlmzV+xZjcFgJ2
         KQhufzKwvYabnZDGy1LuYzM3w7z835msrrmeSpUSZ+5l1Ggk0BviKYxcsTpWyRpvjR/h
         11u9ue/hi/51+IcMfvk3HajDNS4zon2p6k6xw=
Message-ID: <4C22F020.5090708@gmail.com>
Date: Thu, 24 Jun 2010 13:41:52 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Wan ZongShun <mcuos.com@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Qiang Wang <rurality.wq@gmail.com>,
       linux-fbdev@vger.kernel.org
Subject: [PATCH] NUC900/lcd: patch to fix nuc900 lcd build error
References: <4C22ED7F.8050706@gmail.com>
In-Reply-To: <4C22ED7F.8050706@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I have to resent it to the correct LCD mail list.

Hi Andrew,

This patch is to fix nuc900 lcd build error.
Since the 'nuc900_driver_clksrc_div()' API can not be
merged into mainline successfully, so I remove this clock
source selection hook in this driver. That means nuc900
lcd driver has to select default clock source from external
crystal now.

Thanks!

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/video/nuc900fb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index d4cde79..81687ed 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -596,8 +596,6 @@ static int __devinit nuc900fb_probe(struct platform_device *pdev)
 		goto release_regs;
 	}

-	nuc900_driver_clksrc_div(&pdev->dev, "ext", 0x2);
-
 	fbi->clk = clk_get(&pdev->dev, NULL);
 	if (!fbi->clk || IS_ERR(fbi->clk)) {
 		printk(KERN_ERR "nuc900-lcd:failed to get lcd clock source\n");
-- 
1.6.3.3

