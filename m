Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab0D3SNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:13:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56737 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875Ab0D3SMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t9aTioWZ3KFnovCWOmWeX6oHICXI9VFMEukDXRvPP8rGmR/+osMA9umZJSfrOb2IJf
         o+64Tnmm6rFTPuMvqnLiAbDwyfCDSQfKNUcnWxsKGpYr4nQK3QyvJ0PN2tJSLLBWxtmp
         MXYzUUEDjt098eKWAz5JcBr+SX39+TSry/TdY=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, shawn.bohrer@gmail.com, fmhess@users.sourceforge.net,
       andrea.gelmini@gelma.net, eparis@redhat.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: added log level to printk's in comedi_fops.c
Date: Thu, 29 Apr 2010 18:17:16 +0800
Message-Id: <1272536236-19879-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches comedi_fops.c to add kernel log level to some printk calls

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 287a1af..1b3aed4 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -736,7 +736,8 @@ static int check_insn_config_length(struct comedi_insn *insn,
 		/* by default we allow the insn since we don't have checks for
 		 * all possible cases yet */
 	default:
-		printk("comedi: no check for data length of config insn id "
+		printk(KERN_WARNING
+		       "comedi: no check for data length of config insn id "
 		       "%i is implemented.\n"
 		       " Add a check to %s in %s.\n"
 		       " Assuming n=%i is correct.\n", data[0], __func__,
@@ -1925,7 +1926,7 @@ static int __init comedi_init(void)
 	}
 	comedi_class = class_create(THIS_MODULE, "comedi");
 	if (IS_ERR(comedi_class)) {
-		printk("comedi: failed to create class");
+		printk(KERN_ERR "comedi: failed to create class");
 		cdev_del(&comedi_cdev);
 		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
 					 COMEDI_NUM_MINORS);
@@ -1971,7 +1972,8 @@ module_exit(comedi_cleanup);
 
 void comedi_error(const struct comedi_device *dev, const char *s)
 {
-	printk("comedi%d: %s: %s\n", dev->minor, dev->driver->driver_name, s);
+	printk(KERN_ERR "comedi%d: %s: %s\n", dev->minor,
+	       dev->driver->driver_name, s);
 }
 
 void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
-- 
1.7.0.5

