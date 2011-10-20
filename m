Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1JTGUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:20:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50871 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1JTGUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:20:07 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 02/24] Staging: comedi: fix printk coding style issue in
Date: Thu, 20 Oct 2011 11:48:48 +0530
Message-Id: <1319091550-2558-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the serial2002.c file that fixes up a printk warning
found by the checkpatch.pl tool.
Converted printks to pr_<level>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/serial2002.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index ade2202..6bd07ec 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -431,7 +431,8 @@ static int serial_2002_open(struct comedi_device *dev)
 		}
 
 		tty_setspeed(devpriv->tty, devpriv->speed);
-		poll_channel(devpriv->tty, 31);	/*  Start reading configuration */
+		/* Start reading configuration */
+		poll_channel(devpriv->tty, 31);
 		while (1) {
 			struct serial_data data;
 
@@ -824,7 +825,7 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: serial2002: ", dev->minor);
+	pr_debug("comedi%d: serial2002: attached\n", dev->minor);
 	dev->board_name = thisboard->name;
 	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
@@ -832,7 +833,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
 	devpriv->speed = it->options[1];
-	printk("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
+	pr_debug("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
 
 	if (alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
@@ -891,7 +892,7 @@ static int serial2002_detach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	int i;
 
-	printk("comedi%d: serial2002: remove\n", dev->minor);
+	pr_debug("comedi%d: serial2002: remove\n", dev->minor);
 	for (i = 0; i < 5; i++) {
 		s = &dev->subdevices[i];
 		kfree(s->maxdata_list);
-- 
1.7.6.4

