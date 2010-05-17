Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0EQLe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:34:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0EQLe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uYBCrY5QjoQsxZhXKABccAN7IHk4BjRG+V7yUEjzdWrD7bgZzjO/Wg4+zp71OARaUU
         Euuigt/bgGHPJLTfj95IdxcmLiwGewroM3/tCUgzexpzhVyoS5UJC2puhiuTNlxbSQMo
         3BnKmSUm1rATnsHQzh/TpkkHN3bnvzWTGjKzU=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>,
       Ben Kero <ben.kero@gmail.com>, Tejun Heo <tj@kernel.org>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Altered the way printk is used in 8255.c
Date: Mon, 17 May 2010 19:34:27 +0800
Message-Id: <1274096068-7330-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves around the use of printk calls in 8255.c to include accurate
logging levels and in turn fixes a few warnings from checkpatch.

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/8255.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index b2e80dd..fe63830 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -396,8 +396,6 @@ static int dev_8255_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	int i;
 
-	printk("comedi%d: 8255:", dev->minor);
-
 	dev->board_name = "8255";
 
 	for (i = 0; i < COMEDI_NDEVCONFOPTS; i++) {
@@ -406,13 +404,20 @@ static int dev_8255_attach(struct comedi_device *dev,
 			break;
 	}
 	if (i == 0) {
-		printk(" no devices specified\n");
+		printk(KERN_WARNING
+		       "comedi%d: 8255: no devices specified\n", dev->minor);
 		return -EINVAL;
 	}
 
 	ret = alloc_subdevices(dev, i);
-	if (ret < 0)
+	if (ret < 0) {
+		/* FIXME this printk call should give a proper message, the
+		 * below line just maintains previous functionality */
+		printk("comedi%d: 8255:", dev->minor);
 		return ret;
+	}
+
+	printk(KERN_INFO "comedi%d: 8255:", dev->minor);
 
 	for (i = 0; i < dev->n_subdevices; i++) {
 		iobase = it->options[i];
@@ -439,7 +444,7 @@ static int dev_8255_detach(struct comedi_device *dev)
 	unsigned long iobase;
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: 8255: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: 8255: remove\n", dev->minor);
 
 	for (i = 0; i < dev->n_subdevices; i++) {
 		s = dev->subdevices + i;
-- 
1.7.0.5

