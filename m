Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0CXMEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:04:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37724 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0CXMEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=S4myfVX02uRyIsEFWARyGhqTBgBZhGUOAbhBY7KDZGjLaob5sfKZUuRUx0SBVKL4ld
         XGdXfaulaPnDcCCxPzIZx8YOjcibxRNJWoN7sz63MgsOtOpQyke+fQ/+6c/kWXPlyqMa
         GoyXrdJlHIEzdvRr9ncWcDvtGPggy/MMR6St4=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/23] Staging: comedi: fix brace, print(k), indent and over 80 character coding style issues in adq12b.c
Date: Wed, 24 Mar 2010 12:04:29 +0000
Message-Id: <1269432269-3417-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adq12b.c file that fixes up brace, print(k), indent and over 80 character warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adq12b.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 00b2009..ac3d42d 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -200,19 +200,21 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unipolar = it->options[1];
 	differential = it->options[2];
 
-	printk("comedi%d: adq12b called with options base=0x%03lx, %s and %s\n",
+	printk(KERN_ERR "comedi%d: adq12b called with options base=0x%03lx, "
+								"%s and %s\n",
 	       dev->minor, iobase, (unipolar == 1) ? "unipolar" : "bipolar",
 	       (differential == 1) ? "differential" : "single-ended");
 
 	/* if no address was specified, try the default 0x300 */
 	if (iobase == 0) {
-		printk
-		    ("comedi%d: adq12b warning: I/O base address not specified. Trying the default 0x300.\n",
-		     dev->minor);
+		printk("comedi%d: adq12b warning: "
+			"I/O base address not specified. "
+			"Trying the default 0x300.\n",
+						dev->minor);
 		iobase = 0x300;
 	}
 
-	printk("comedi%d: adq12b: 0x%04lx ", dev->minor, iobase);
+	printk(KERN_ERR "comedi%d: adq12b: 0x%04lx ", dev->minor, iobase);
 	if (!request_region(iobase, ADQ12B_SIZE, "adq12b")) {
 		printk("I/O port conflict\n");
 		return -EIO;
@@ -259,11 +261,10 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->n_chan = thisboard->ai_se_chans;
 	}
 
-	if (unipolar) {
+	if (unipolar)
 		s->range_table = &range_adq12b_ai_unipolar;
-	} else {
+	else
 		s->range_table = &range_adq12b_ai_bipolar;
-	}
 
 	s->maxdata = (1 << thisboard->ai_bits) - 1;
 
@@ -289,7 +290,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_digital;
 	s->insn_bits = adq12b_do_insn_bits;
 
-	printk("attached\n");
+	printk(KERN_ERR "attached\n");
 
 	return 0;
 }
@@ -309,7 +310,7 @@ static int adq12b_detach(struct comedi_device *dev)
 
 	kfree(devpriv);
 
-	printk("comedi%d: adq12b: removed\n", dev->minor);
+	printk(KERN_ERR "comedi%d: adq12b: removed\n", dev->minor);
 
 	return 0;
 }
@@ -344,17 +345,20 @@ static int adq12b_ai_rinsn(struct comedi_device *dev,
 		/* wait for end of convertion */
 		i = 0;
 		do {
-/* udelay(1); */
+			/* udelay(1); */
 			status = inb(dev->iobase + ADQ12B_STINR);
 			status = status & ADQ12B_EOC;
 		} while (status == 0 && ++i < TIMEOUT);
-/* } while (++i < 10); */
+			/* } while (++i < 10); */
 
 		/* read data */
 		hi = inb(dev->iobase + ADQ12B_ADHIG);
 		lo = inb(dev->iobase + ADQ12B_ADLOW);
 
-		/* printk("debug: chan=%d range=%d status=%d hi=%d lo=%d\n", channel, range, status,  hi, lo); */
+		/*
+		 *printk("debug: chan=%d range=%d status=%d hi=%d lo=%d\n",
+		 *channel, range, status,  hi, lo);
+		 */
 		data[n] = (hi << 8) | lo;
 
 	}
-- 
1.6.3.3

