Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1LHMyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1LHMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:27 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 19/30] Staging: comedi: fix printk issue in jr3_pci.c
Date: Thu,  8 Dec 2011 18:22:14 +0530
Message-Id: <1323348745-31477-19-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the jr3_pci.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 17370b9..01b0e08 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -517,7 +517,7 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 		int errors = get_u16(&channel->errors);
 
 		if (errors != p->errors) {
-			printk("Errors: %x -> %x\n", p->errors, errors);
+			pr_debug("Errors: %x -> %x\n", p->errors, errors);
 			p->errors = errors;
 		}
 		if (errors & (watch_dog | watch_dog2 | sensor_change)) {
@@ -560,10 +560,10 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 					printk
 					    ("Setting transform for channel %d\n",
 					     p->channel_no);
-					printk("Sensor Model     = %i\n",
-					       p->model_no);
-					printk("Sensor Serial    = %i\n",
-					       p->serial_no);
+					pr_debug("Sensor Model = %i\n",
+						 p->model_no);
+					pr_debug("Sensor Serial = %i\n",
+						 p->serial_no);
 
 					/*  Transformation all zeros */
 					for (i = 0; i < ARRAY_SIZE(transf.link); i++) {
-- 
1.7.0.4

