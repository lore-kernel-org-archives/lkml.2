Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0HBBPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:15:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54390 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0HBBP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AwxE69CpZM4Xbp/YEP5HJ75MtVIgCAyXow9qbueLiMEwG6sabWa0f/Uu+YcufldTXD
         BovGwiBHnt8M2DkcagAigwzgqG8RlxKQOXBKRoYlGRgJCqze3g5O4wvFMhO75y98iZVc
         jIu1NRxGk1zm15Ytyet76ZiaW2bd8r82F+Ebg=
Subject: [PATCH RESEND] jz4740-hwmon: check kmalloc() result
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain
Date: Mon, 02 Aug 2010 09:16:35 +0800
Message-Id: <1280711795.6538.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 16482398f86ac6cc3b08b10352efd01b56d67473 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 2 Aug 2010 09:02:26 +0800
Subject: [PATCH] jz4740-hwmon: check kmalloc() result

If kmalloc() fails exit with -ENOMEM.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next.
This resend separates the fix for jz4740-hwmon and jz474-adc in 2 patches.

 drivers/hwmon/jz4740-hwmon.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index 72a4335..1c8b3d9 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -107,6 +107,10 @@ static int __devinit jz4740_hwmon_probe(struct platform_device *pdev)
 	struct jz4740_hwmon *hwmon;
 
 	hwmon = kmalloc(sizeof(*hwmon), GFP_KERNEL);
+	if (!hwmon) {
+		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
 
 	hwmon->cell = pdev->dev.platform_data;
 
-- 
1.5.4.3



