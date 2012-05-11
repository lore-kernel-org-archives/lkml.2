Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2EKKlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35076 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab2EKKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:27 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 14/25] Staging: comedi: fix printk issue in serial2002.c
Date: Fri, 11 May 2012 16:08:02 +0530
Message-Id: <1336732693-7408-15-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the serial2002.c file that fixes up a
printk warning found by the checkpatch.pl tool.

This patch converts a printks to pr_<level> and used dev_<level>
function wherver possible.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/serial2002.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index a034b10..5a5a781 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -287,7 +287,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
 
 		length++;
 		if (data < 0) {
-			printk(KERN_ERR "serial2002 error\n");
+			pr_err("serial2002 error\n");
 			break;
 		} else if (data & 0x80) {
 			result.value = (result.value << 7) | (data & 0x7f);
@@ -360,7 +360,7 @@ static int serial_2002_open(struct comedi_device *dev)
 	devpriv->tty = filp_open(port, O_RDWR, 0);
 	if (IS_ERR(devpriv->tty)) {
 		result = (int)PTR_ERR(devpriv->tty);
-		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
+		dev_err(dev->hw_dev, "file open error = %d\n", result);
 	} else {
 		struct config_t {
 
-- 
1.7.0.4

