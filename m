Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2F0MK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:10:26 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48897 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755458Ab2F0MKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:10:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIb36k9bdWOb/2dsb2JhbABFtiaBB4IYAQEFJ1IQIDE8GwcSiA+5Q5FBA5UykAOCYQ
X-IronPort-AV: E=Sophos;i="4.77,484,1336341600"; 
   d="scan'208";a="533592663"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/2] staging: sm7xxfb: rename vars holding device and revision ids
Date: Wed, 27 Jun 2012 14:10:14 +0200
Message-Id: <1340799015-3138-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1340799015-3138-1-git-send-email-jmunhoz@igalia.com>
References: <1340799015-3138-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch fixes CamelCase var names in smtcfb_info holding device and
revision identifiers.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 16d2b5e..c603e8c 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -42,8 +42,9 @@ struct screen_info smtc_screen_info;
 struct smtcfb_info {
 	struct fb_info fb;
 	struct pci_dev *pdev;
+	u16 chip_id;
+	u8  chip_rev_id;
 
-	u16 chipID;
 	unsigned char __iomem *m_pMMIO;
 	char __iomem *m_pLFB;
 	char *m_pDPR;
@@ -53,8 +54,6 @@ struct smtcfb_info {
 	u_int width;
 	u_int height;
 	u_int hz;
-
-	u8 chipRevID;
 };
 
 struct vesa_mode_table	{
@@ -231,7 +230,7 @@ static void sm712_setpalette(int regno, unsigned red, unsigned green,
 
 static void smtc_set_timing(struct smtcfb_info *sfb)
 {
-	switch (sfb->chipID) {
+	switch (sfb->chip_id) {
 	case 0x710:
 	case 0x712:
 	case 0x720:
@@ -812,8 +811,8 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (!sfb)
 		goto failed_free;
 
-	sfb->chipID = ent->device;
-	sprintf(name, "sm%Xfb", sfb->chipID);
+	sfb->chip_id = ent->device;
+	sprintf(name, "sm%Xfb", sfb->chip_id);
 
 	pci_set_drvdata(pdev, sfb);
 
@@ -837,9 +836,9 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 #endif
 	/* Map address and memory detection */
 	pFramebufferPhysical = pci_resource_start(pdev, 0);
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &sfb->chipRevID);
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &sfb->chip_rev_id);
 
-	switch (sfb->chipID) {
+	switch (sfb->chip_id) {
 	case 0x710:
 	case 0x712:
 		sfb->fb.fix.mmio_start = pFramebufferPhysical + 0x00400000;
@@ -925,7 +924,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	dev_info(&pdev->dev,
 		 "Silicon Motion SM%X Rev%X primary display mode %dx%d-%d Init Complete.",
-		 sfb->chipID, sfb->chipRevID, sfb->fb.var.xres,
+		 sfb->chip_id, sfb->chip_rev_id, sfb->fb.var.xres,
 		 sfb->fb.var.yres, sfb->fb.var.bits_per_pixel);
 
 	return 0;
@@ -1001,7 +1000,7 @@ static int smtcfb_pci_resume(struct device *device)
 
 	/* reinit hardware */
 	sm7xx_init_hw();
-	switch (sfb->chipID) {
+	switch (sfb->chip_id) {
 	case 0x710:
 	case 0x712:
 		/* set MCLK = 14.31818 *  (0x16 / 0x2) */
-- 
1.7.10

