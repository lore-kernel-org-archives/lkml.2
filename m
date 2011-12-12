Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1LLFVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:15 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 16/29] Staging: comedi: fix brace coding style issue in ni_at_a2150.c
Date: Mon, 12 Dec 2011 10:49:28 +0530
Message-Id: <1323667181-17252-16-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 26f204c..ca4ddc2 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -396,11 +396,12 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  initialize dma */
 	if (dma) {
 		if (dma == 4 || dma > 7) {
-			printk(" invalid dma channel %u\n", dma);
+			dev_err(dev->hw_dev, "invalid dma channel %u\n", dma);
 			return -EINVAL;
 		}
 		if (request_dma(dma, driver_a2150.driver_name)) {
-			printk(" failed to allocate dma channel %u\n", dma);
+			dev_dbg(dev->hw_dev, "failed to allocate dma channel %u\n",
+				dma);
 			return -EINVAL;
 		}
 		devpriv->dma = dma;
-- 
1.7.0.4

