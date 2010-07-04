Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab0GDQgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 12:36:17 -0400
Received: from s5.cableone.net ([24.116.0.231]:48694 "EHLO s5.cableone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab0GDQgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 12:36:16 -0400
X-Greylist: delayed 1585 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jul 2010 12:36:16 EDT
From: James K Pruitt <pruittjk@cableone.net>
To: gregkh@suse.de, mauricedawson2699@googlemail.com, stewart_r@aliencamel.com,
       mithlesh@linsyssoft.com, u.kleine-koenig@pengutronix.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pruittjk@cableone.net
Subject: [PATCH] staging: comedi: fixed KERN_ facility level warning
Date: Sun,  4 Jul 2010 11:09:51 -0500
Message-Id: <1278259791-29441-1-git-send-email-pruittjk@cableone.net>
X-Mailer: git-send-email 1.7.1
X-Vpipe: Scanner said ok (av_avast)
X-IP-stats: Incoming Last 2, First 1, in=1, out=0, spam=0 ip=69.92.219.139
X-Originating-IP: 69.92.219.139
X-Abuse-Info: Send abuse complaints to abuse@cableone.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes a "KERN_" facility level
warning on line 529 found by the checkpatch.pl utility.

Signed-off-by: James K Pruitt <pruittjk@cableone.net>
---
 drivers/staging/comedi/drivers/ni_labpc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 67c8a53..086a7be 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -526,8 +526,8 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	unsigned long dma_flags, isr_flags;
 	short lsb, msb;
 
-	printk("comedi%d: ni_labpc: %s, io 0x%lx", dev->minor, thisboard->name,
-	       iobase);
+	printk(KERN_INFO "comedi%d: ni_labpc: %s, io 0x%lx", dev->minor,
+						thisboard->name, iobase);
 	if (irq)
 		printk(", irq %u", irq);
 	if (dma_chan)
-- 
1.7.1

