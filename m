Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0HCDJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:09:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47117 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0HCDJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SA1+BoN8etlKZMPpViGs703TJJGuUmYtr+8rodvpNZhhAovsK/Kgg1ySXLgZ6JKMpr
         optyTS9Vhbkx/iYTX9v9Nmkzq8ZWqeNcYxrHwISvh31fWP2b7gsuC3+3zhPb4aTNcUml
         yNTY6HIPWUJ3N5MeHMTnfaOHUz+H3PMGfJ5uM=
Subject: [PATCH] tc6393xb: fix wrong goto labels for error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ian Molton <ian@mnementh.co.uk>
Content-Type: text/plain
Date: Tue, 03 Aug 2010 11:10:41 +0800
Message-Id: <1280805041.27646.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the error handling path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tc6393xb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index fcf9068..ef6c42c 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -732,9 +732,9 @@ err_gpio_add:
 	if (tc6393xb->gpio.base != -1)
 		temp = gpiochip_remove(&tc6393xb->gpio);
 	tcpd->disable(dev);
-err_clk_enable:
-	clk_disable(tc6393xb->clk);
 err_enable:
+	clk_disable(tc6393xb->clk);
+err_clk_enable:
 	iounmap(tc6393xb->scr);
 err_ioremap:
 	release_resource(&tc6393xb->rscr);
-- 
1.5.4.3



