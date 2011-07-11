Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab1GKHj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:39:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57866 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1GKHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:39:22 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 10/10] Staging: comedi: fix brace printk() issue in pcl818.c
Date: Mon, 11 Jul 2011 13:21:52 +0530
Message-Id: <1310370712-28864-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 9/9]Staging: comedi: fix printk issue in pcl818.c>
References: <[PATCH 9/9]Staging: comedi: fix printk issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 2fdb8c9..4069fee 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1777,7 +1777,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					     irq);
 					irq = 0;	/* Can't use IRQ */
 				} else {
-					printk(", irq=%u", irq);
+					printk(KERN_INFO ", irq=%u", irq);
 				}
 			}
 		}
@@ -1883,7 +1883,7 @@ no_dma:
 		if (check_single_ended(dev->iobase)) {
 			s->n_chan = this_board->n_aichan_se;
 			s->subdev_flags |= SDF_COMMON | SDF_GROUND;
-			printk(", %dchans S.E. DAC", s->n_chan);
+			printk(KERN_INFO ", %dchans S.E. DAC", s->n_chan);
 		} else {
 			s->n_chan = this_board->n_aichan_diff;
 			s->subdev_flags |= SDF_DIFF;
-- 
1.6.5.2

