Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1KHLQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:16:55 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42845 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1KHLQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:16:50 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 14/20] Staging: comedi: fix printk issue in cb_pcimdas.c
Date: Tue,  8 Nov 2011 16:45:24 +0530
Message-Id: <1320750930-9764-14-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
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

