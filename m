Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1LLFV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:25 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 18/29] Staging: comedi: fix printk issue in daqboard2000.c
Date: Mon, 12 Dec 2011 10:49:30 +0530
Message-Id: <1323667181-17252-18-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_dbg().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 0b498de..b98858d 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -583,14 +583,14 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 	secr = readl(devpriv->plx + 0x6c);
 	if (!(secr & DAQBOARD2000_EEPROM_PRESENT)) {
 #ifdef DEBUG_EEPROM
-		printk("no serial eeprom\n");
+		dev_dbg(dev->hw_dev, "no serial eeprom\n");
 #endif
 		return -EIO;
 	}
 
 	for (retry = 0; retry < 3; retry++) {
 #ifdef DEBUG_EEPROM
-		printk("Programming EEPROM try %x\n", retry);
+		dev_dbg(dev->hw_dev, "Programming EEPROM try %x\n", retry);
 #endif
 
 		daqboard2000_resetLocalBus(dev);
@@ -601,7 +601,8 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 				if (cpld_array[i] == 0xff
 				    && cpld_array[i + 1] == 0x20) {
 #ifdef DEBUG_EEPROM
-					printk("Preamble found at %d\n", i);
+					dev_dbg(dev->hw_dev, "Preamble found at %d\n",
+						i);
 #endif
 					break;
 				}
@@ -615,7 +616,7 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 			}
 			if (i >= len) {
 #ifdef DEBUG_EEPROM
-				printk("Programmed\n");
+				dev_dbg(dev->hw_dev, "Programmed\n");
 #endif
 				daqboard2000_resetLocalBus(dev);
 				daqboard2000_reloadPLX(dev);
-- 
1.7.0.4

