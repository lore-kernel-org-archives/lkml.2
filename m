Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1BIRQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:16:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab1BIRQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:16:16 -0500
From: Harald Hoyer <harald@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Hoyer <harald@redhat.com>
Subject: [PATCH] drivers/scsi/ch.c: print real device name
Date: Wed,  9 Feb 2011 18:18:53 +0100
Message-Id: <1297271933-16804-1-git-send-email-harald@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the real name "sch[0-9]*" instead of "ch[0-9]".

Signed-off-by: Harald Hoyer <harald@redhat.com>
---
 drivers/scsi/ch.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index a15474e..21ce545 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -87,12 +87,12 @@ static const char * vendor_labels[CH_TYPES-4] = {
 #define DPRINTK(fmt, arg...)						\
 do {									\
 	if (debug)							\
-		printk(KERN_DEBUG "%s: " fmt, ch->name, ##arg);		\
+		printk(KERN_DEBUG "s%s: " fmt, ch->name, ##arg);		\
 } while (0)
 #define VPRINTK(level, fmt, arg...)					\
 do {									\
 	if (verbose)							\
-		printk(level "%s: " fmt, ch->name, ##arg);		\
+		printk(level "s%s: " fmt, ch->name, ##arg);		\
 } while (0)
 
 /* ------------------------------------------------------------------- */
@@ -940,7 +940,7 @@ static int ch_probe(struct device *dev)
 		ch_init_elem(ch);
 
 	dev_set_drvdata(dev, ch);
-	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
+	sdev_printk(KERN_INFO, sd, "Attached scsi changer s%s\n", ch->name);
 
 	return 0;
 remove_idr:
