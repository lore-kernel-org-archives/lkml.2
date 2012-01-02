Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2ABNXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:23:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63985 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2ABNXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:23:09 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu, jj@chaosbits.net,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 6/6] Staging: comedi: fix initialise statics to 0 or NULL issue in ni_mio_cs.c.
Date: Mon,  2 Jan 2012 18:47:53 +0530
Message-Id: <1325510273-20091-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_mio_cs.c file that fixes up a initialise
statics to 0 or NULL warning found by the checkpatch.pl tool.

Breaks the build.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_mio_cs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index 53ec24b..cb3d08b 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -258,7 +258,7 @@ static void mio_cs_config(struct pcmcia_device *link);
 static void cs_release(struct pcmcia_device *link);
 static void cs_detach(struct pcmcia_device *);
 
-static struct pcmcia_device *cur_dev = NULL;
+static struct pcmcia_device *cur_dev;
 
 static int cs_attach(struct pcmcia_device *link)
 {
@@ -351,6 +351,8 @@ static int mio_cs_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("comedi%d: %s: DAQCard: io 0x%04lx, irq %u, ",
 	       dev->minor, dev->driver->driver_name, dev->iobase, irq);
 
+
+
 #if 0
 	{
 		int i;
@@ -400,7 +402,7 @@ static int mio_cs_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 }
 
 static int ni_getboardtype(struct comedi_device *dev,
-			   struct pcmcia_device *link)
+		struct pcmcia_device *link)
 {
 	int i;
 
-- 
1.7.0.4

