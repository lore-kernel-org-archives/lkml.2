Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab2J0Vrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:47:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2J0Vrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:47:31 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] staging/comedi: Use dev_ printks in drivers/quatech_daqp_cs.c
Date: Sun, 28 Oct 2012 06:47:26 +0900
Message-Id: <1351374446-7955-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351374393-7918-1-git-send-email-yamanetoshi@gmail.com>
References: <1351374393-7918-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: printk() should include KERN_ facility level

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 806523c..ee9158b 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -300,7 +300,7 @@ static enum irqreturn daqp_interrupt(int irq, void *dev_id)
 			if (status & DAQP_STATUS_DATA_LOST) {
 				s->async->events |=
 				    COMEDI_CB_EOA | COMEDI_CB_OVERFLOW;
-				printk("daqp: data lost\n");
+				dev_warn(dev->class_dev, "data lost\n");
 				daqp_ai_cancel(dev, s);
 				break;
 			}
@@ -398,7 +398,8 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS))
 		;
 	if (!counter) {
-		printk("daqp: couldn't clear interrupts in status register\n");
+		dev_err(dev->class_dev,
+			"couldn't clear interrupts in status register\n");
 		return -1;
 	}
 
@@ -824,8 +825,8 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 
 	if (it->options[0] < 0 || it->options[0] >= MAX_DEV || !local) {
-		printk("comedi%d: No such daqp device %d\n",
-		       dev->minor, it->options[0]);
+		dev_err(dev->class_dev, "No such daqp device %d\n",
+			it->options[0]);
 		return -EIO;
 	}
 
-- 
1.7.9.5

