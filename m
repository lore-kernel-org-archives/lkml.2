Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1KCGkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:40:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38721 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1KCGkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:51 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 14/14] Staging: comedi: fix printk issue in cb_pcimdas.c
Date: Thu,  3 Nov 2011 12:10:02 +0530
Message-Id: <1320302402-5025-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_version.
Removed ifdef CBPCIMDAS_DEBUG and unecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 5d25e78..8ba6942 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -341,16 +341,19 @@ found:
  */
 static int cb_pcimdas_detach(struct comedi_device *dev)
 {
-#ifdef CBPCIMDAS_DEBUG
 	if (devpriv) {
-		printk("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
-		printk("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
-		printk("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
-		printk("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
-		printk("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
+		dev_dbg(dev->hw_dev, "devpriv->BADR0 = 0x%lx\n",
+			devpriv->BADR0);
+		dev_dbg(dev->hw_dev, "devpriv->BADR1 = 0x%lx\n",
+			devpriv->BADR1);
+		dev_dbg(dev->hw_dev, "devpriv->BADR2 = 0x%lx\n",
+			devpriv->BADR2);
+		dev_dbg(dev->hw_dev, "devpriv->BADR3 = 0x%lx\n",
+			devpriv->BADR3);
+		dev_dbg(dev->hw_dev, "devpriv->BADR4 = 0x%lx\n",
+			devpriv->BADR4);
 	}
-#endif
-	printk("comedi%d: cb_pcimdas: remove\n", dev->minor);
+
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
-- 
1.7.0.4

