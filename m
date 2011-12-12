Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1LLFYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:24:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1LLFUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:42 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 09/29] Staging: comedi: fix printk issue in daqboard2000.c
Date: Mon, 12 Dec 2011 10:49:21 +0530
Message-Id: <1323667181-17252-9-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_dbg().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 9958bd5..270d5d8 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -506,7 +506,7 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 
 static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 {
-	printk("daqboard2000_resetLocalBus\n");
+	dev_dbg(dev->hw_dev, "daqboard2000_resetLocalBus\n");
 	writel(DAQBOARD2000_SECRLocalBusHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRLocalBusLo, devpriv->plx + 0x6c);
@@ -515,7 +515,7 @@ static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 
 static void daqboard2000_reloadPLX(struct comedi_device *dev)
 {
-	printk("daqboard2000_reloadPLX\n");
+	dev_dbg(dev->hw_dev, "daqboard2000_reloadPLX\n");
 	writel(DAQBOARD2000_SECRReloadLo, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRReloadHi, devpriv->plx + 0x6c);
@@ -526,7 +526,7 @@ static void daqboard2000_reloadPLX(struct comedi_device *dev)
 
 static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 {
-	printk("daqboard2000_pulseProgPin 1\n");
+	dev_dbg(dev->hw_dev, "daqboard2000_pulseProgPin 1\n");
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
-- 
1.7.0.4

