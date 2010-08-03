Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0HCFof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:44:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39074 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab0HCFoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YCGHw/H0CvWE+2pK1U1Iuk0DuNsVNo7EsnpYAgD4aMe20zGxJ34y48T1t4Rq5MGmZD
         9dobd3CfIrSQgTxrsyHK48RosvAuglPRirz8k2GypidV3taGyttF1MXIjwjyW/VbgSYy
         53lFhXR2+cMIFvnDaSoiL0iwoNf3DanaU0e8A=
Subject: [PATCH 2/2] tc6387xb: add __devinit/__devexit annotation for
	tc6387xb_probe/tc6387xb_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ian Molton <ian@mnementh.co.uk>
Content-Type: text/plain
Date: Tue, 03 Aug 2010 13:45:45 +0800
Message-Id: <1280814345.15753.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tc6387xb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 1bc71da..6315f63 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -137,7 +137,7 @@ static struct mfd_cell tc6387xb_cells[] = {
 	},
 };
 
-static int tc6387xb_probe(struct platform_device *dev)
+static int __devinit tc6387xb_probe(struct platform_device *dev)
 {
 	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
 	struct resource *iomem, *rscr;
@@ -212,7 +212,7 @@ err_no_irq:
 	return ret;
 }
 
-static int tc6387xb_remove(struct platform_device *dev)
+static int __devexit tc6387xb_remove(struct platform_device *dev)
 {
 	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 
@@ -233,7 +233,7 @@ static struct platform_driver tc6387xb_platform_driver = {
 		.name		= "tc6387xb",
 	},
 	.probe		= tc6387xb_probe,
-	.remove		= tc6387xb_remove,
+	.remove		= __devexit_p(tc6387xb_remove),
 	.suspend        = tc6387xb_suspend,
 	.resume         = tc6387xb_resume,
 };
-- 
1.5.4.3



