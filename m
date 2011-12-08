Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1LHMxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1LHMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:09 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 04/30] Staging: comedi: fix printk issue in daqboard2000.c
Date: Thu,  8 Dec 2011 18:21:59 +0530
Message-Id: <1323348745-31477-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Removed ifdef DEBUG_EEPROM.
Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 265c650..7066d8f 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -573,17 +573,12 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 	/* Check to make sure the serial eeprom is present on the board */
 	secr = readl(devpriv->plx + 0x6c);
 	if (!(secr & DAQBOARD2000_EEPROM_PRESENT)) {
-#ifdef DEBUG_EEPROM
-		printk("no serial eeprom\n");
-#endif
+		pr_debug("no serial eeprom\n");
 		return -EIO;
 	}
 
 	for (retry = 0; retry < 3; retry++) {
-#ifdef DEBUG_EEPROM
-		printk("Programming EEPROM try %x\n", retry);
-#endif
-
+		pr_debug("Programming EEPROM try %x\n", retry);
 		daqboard2000_resetLocalBus(dev);
 		daqboard2000_reloadPLX(dev);
 		daqboard2000_pulseProgPin(dev);
@@ -591,9 +586,7 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 			for (i = 0; i < len; i++) {
 				if (cpld_array[i] == 0xff
 				    && cpld_array[i + 1] == 0x20) {
-#ifdef DEBUG_EEPROM
-					printk("Preamble found at %d\n", i);
-#endif
+					pr_debug("Preamble found at %d\n", i);
 					break;
 				}
 			}
@@ -604,9 +597,7 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 					break;
 			}
 			if (i >= len) {
-#ifdef DEBUG_EEPROM
-				printk("Programmed\n");
-#endif
+				pr_debug("Programmed\n");
 				daqboard2000_resetLocalBus(dev);
 				daqboard2000_reloadPLX(dev);
 				result = 0;
-- 
1.7.0.4

