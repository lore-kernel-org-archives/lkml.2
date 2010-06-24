Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0FXFax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:30:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56314 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0FXFav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FKTZmNKUHqe2Jg/PUnabk7S0PlcQbUXcQ9iIE+phZsVrzcqumWScYdH+3xljO5qmTU
         8zsGYWG6GZ/WDVq5xOg3PlB8J/hPDQOGtmL7dHLAWC3egme+C13FOAR6xV5uekZnICMr
         RYGmTf06dbB1G9bcg1A2CzWrySCx3PttbglEI=
Message-ID: <4C22ED7F.8050706@gmail.com>
Date: Thu, 24 Jun 2010 13:30:39 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Qiang Wang <rurality.wq@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] NUC900/lcd: patch to fix nuc900 lcd build error
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
