Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0FPFhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:37:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47746 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0FPFg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HU1ms31znyR2h5OdXCqJ+ElGPpSstD+rVBveKK+5RoNiC10oKj4B6hYsIAiXPeVZvv
         otfUK3HWnDp3Jys3V1dwwfZeyHEj5MdGxLOGJxS2zT4qcVrygtk+OZpCpkC9/jYi0LAS
         7+eDyvsxon5IPg7fMuG0Swx1/J6tc6/hiFFvY=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: fix coding style issues in pcmda12.c
Date: Wed, 16 Jun 2010 00:36:54 -0500
Message-Id: <1276666614-9602-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmda12.c file that fixes up five printk() warning issues

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/pcmda12.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 7133eb0..fd12b50 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -157,7 +157,8 @@ static int pcmda12_attach(struct comedi_device *dev,
 	unsigned long iobase;
 
 	iobase = it->options[0];
-	printk("comedi%d: %s: io: %lx %s ", dev->minor, driver.driver_name,
+	printk(KERN_INFO
+	       "comedi%d: %s: io: %lx %s ", dev->minor, driver.driver_name,
 	       iobase, it->options[1] ? "simultaneous xfer mode enabled" : "");
 
 	if (!request_region(iobase, IOSIZE, driver.driver_name)) {
@@ -177,7 +178,7 @@ static int pcmda12_attach(struct comedi_device *dev,
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmda12_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_ERR "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
@@ -191,7 +192,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 	 * 96-channel version of the board.
 	 */
 	if (alloc_subdevices(dev, 1) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
@@ -207,7 +208,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 
 	zero_chans(dev);	/* clear out all the registers, basically */
 
-	printk("attached\n");
+	printk(KERN_INFO "attached\n");
 
 	return 1;
 }
@@ -222,7 +223,8 @@ static int pcmda12_attach(struct comedi_device *dev,
  */
 static int pcmda12_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_INFO
+	       "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, IOSIZE);
 	return 0;
-- 
1.5.4.3

