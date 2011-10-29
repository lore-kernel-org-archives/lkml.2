Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab1J2NZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 09:25:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58669 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab1J2NZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 09:25:52 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/7] Staging: comedi: fix printk issue in serial2002.c
Date: Sat, 29 Oct 2011 18:55:24 +0530
Message-Id: <1319894729-1744-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319894729-1744-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319894729-1744-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the serial2002.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_version.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/serial2002.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index ade2202..d880c2f 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -824,7 +824,7 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: serial2002: ", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: attached\n", dev->minor);
 	dev->board_name = thisboard->name;
 	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
@@ -832,7 +832,8 @@ static int serial2002_attach(struct comedi_device *dev,
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
 	devpriv->speed = it->options[1];
-	printk("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
+	dev_dbg(dev->hw_dev, "/dev/ttyS%d @ %d\n", devpriv->port,
+		devpriv->speed);
 
 	if (alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
@@ -891,7 +892,7 @@ static int serial2002_detach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	int i;
 
-	printk("comedi%d: serial2002: remove\n", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 	for (i = 0; i < 5; i++) {
 		s = &dev->subdevices[i];
 		kfree(s->maxdata_list);
-- 
1.7.0.4

