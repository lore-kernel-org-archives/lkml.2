Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2IQOXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:23:38 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2IQOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:35 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBSdSECAxPBsHEogEulqSCQOVYok1iVQ
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870755"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/7] staging: sm7xxfb: clean smtcfb_fix's id initialization
Date: Mon, 17 Sep 2012 16:12:48 +0200
Message-Id: <1347891173-13916-3-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

Setting up smtcfb_fix's id happens through smtc_alloc_fb_info. It adds
complexity and unnecesary code.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index b809e2c..f6ecac3 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -77,7 +77,7 @@ static struct fb_var_screeninfo smtcfb_var = {
 };
 
 static struct fb_fix_screeninfo smtcfb_fix = {
-	.id             = "sm712fb",
+	.id             = "smXXXfb",
 	.type           = FB_TYPE_PACKED_PIXELS,
 	.visual         = FB_VISUAL_TRUECOLOR,
 	.line_length    = 800 * 3,
@@ -681,7 +681,7 @@ static struct fb_ops smtcfb_ops = {
 /*
  * alloc struct smtcfb_info and assign the default value
  */
-static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
+static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev)
 {
 	struct smtcfb_info *sfb;
 
@@ -698,7 +698,6 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 	sfb->fb.fbops = &smtcfb_ops;
 
 	sfb->fb.fix = smtcfb_fix;
-	strcpy(sfb->fb.fix.id, name);
 
 	sfb->fb.var = smtcfb_var;
 
@@ -781,7 +780,6 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 {
 	struct smtcfb_info *sfb;
 	u_long smem_size = 0x00800000;	/* default 8MB */
-	char name[16];
 	int err;
 	unsigned long pFramebufferPhysical;
 
@@ -791,9 +789,9 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
-	sprintf(name, "sm%Xfb", ent->device);
+	sprintf(smtcfb_fix.id, "sm%Xfb", ent->device);
 
-	sfb = smtc_alloc_fb_info(pdev, name);
+	sfb = smtc_alloc_fb_info(pdev);
 
 	if (!sfb) {
 		err = -ENOMEM;
-- 
1.7.10.4

