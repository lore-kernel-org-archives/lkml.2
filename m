Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1LHMyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1LHMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:33 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 20/30] Staging: comedi: fix printk issue in jr3_pci.c
Date: Thu,  8 Dec 2011 18:22:15 +0530
Message-Id: <1323348745-31477-20-git-send-email-ravishankar.km@greenturtles.in>
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
 drivers/staging/comedi/drivers/jr3_pci.c |   46 ++++++++++++++---------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 01b0e08..8273fb9 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -592,25 +592,23 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 
 					min_full_scale =
 					    get_min_full_scales(channel);
-					printk("Obtained Min. Full Scales:\n");
-					printk("%i   ", (min_full_scale).fx);
-					printk("%i   ", (min_full_scale).fy);
-					printk("%i   ", (min_full_scale).fz);
-					printk("%i   ", (min_full_scale).mx);
-					printk("%i   ", (min_full_scale).my);
-					printk("%i   ", (min_full_scale).mz);
-					printk("\n");
+					pr_debug("Obtained Min. Full Scales:\n");
+					pr_debug("%i\n", (min_full_scale).fx);
+					pr_debug("%i\n", (min_full_scale).fy);
+					pr_debug("%i\n", (min_full_scale).fz);
+					pr_debug("%i\n", (min_full_scale).mx);
+					pr_debug("%i\n", (min_full_scale).my);
+					pr_debug("%i\n", (min_full_scale).mz);
 
 					max_full_scale =
 					    get_max_full_scales(channel);
-					printk("Obtained Max. Full Scales:\n");
-					printk("%i   ", (max_full_scale).fx);
-					printk("%i   ", (max_full_scale).fy);
-					printk("%i   ", (max_full_scale).fz);
-					printk("%i   ", (max_full_scale).mx);
-					printk("%i   ", (max_full_scale).my);
-					printk("%i   ", (max_full_scale).mz);
-					printk("\n");
+					pr_debug("Obtained Max. Full Scales:\n");
+					pr_debug("%i\n", (max_full_scale).fx);
+					pr_debug("%i\n", (max_full_scale).fy);
+					pr_debug("%i\n", (max_full_scale).fz);
+					pr_debug("%i\n", (max_full_scale).mx);
+					pr_debug("%i\n", (max_full_scale).my);
+					pr_debug("%i\n", (max_full_scale).mz);
 
 					set_full_scales(channel,
 							max_full_scale);
@@ -666,14 +664,14 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 					{
 						int i;
 						for (i = 0; i < 9; i++) {
-							printk("%d %d - %d\n",
-							       i,
-							       p->
-							       range[i].range.
-							       min,
-							       p->
-							       range[i].range.
-							       max);
+							pr_debug("%d %d - %d\n",
+								 i,
+								 p->
+								 range[i].range.
+								 min,
+								 p->
+								 range[i].range.
+								 max);
 						}
 					}
 
-- 
1.7.0.4

