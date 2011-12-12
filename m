Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1LLFT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:19:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1LLFT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:19:58 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 01/29] Staging: comedi: fix printk issue in dt3000.c
Date: Mon, 12 Dec 2011 10:49:13 +0530
Message-Id: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 6170f7b..f9c16c9 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -352,7 +352,8 @@ static int dt3k_send_cmd(struct comedi_device *dev, unsigned int cmd)
 	if ((status & DT3000_COMPLETION_MASK) == DT3000_NOERROR)
 		return 0;
 
-	printk("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
+	dev_dbg(dev->hw_dev, "dt3k_send_cmd() timeout/error status=0x%04x\n",
+		status);
 
 	return -ETIME;
 }
@@ -452,7 +453,7 @@ static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 	if (count < 0)
 		count += AI_FIFO_DEPTH;
 
-	printk("reading %d samples\n", count);
+	dev_dbg(dev->hw_dev, "reading %d samples\n", count);
 
 	rear = devpriv->ai_rear;
 
-- 
1.7.0.4

