Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2JHM0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:26:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53467 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2JHM0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:26:05 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/ni_daq_dio24.c
Date: Mon,  8 Oct 2012 21:25:58 +0900
Message-Id: <1349699158-32400-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 0ca222b..f2a80aa 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -202,7 +202,7 @@ static int dio24_cs_attach(struct pcmcia_device *link)
 {
 	struct local_info_t *local;
 
-	printk(KERN_INFO "ni_daq_dio24: HOLA SOY YO - CS-attach!\n");
+	dev_info(&link->dev, "ni_daq_dio24: HOLA SOY YO - CS-attach!\n");
 
 	dev_dbg(&link->dev, "dio24_cs_attach()\n");
 
@@ -242,7 +242,7 @@ static void dio24_config(struct pcmcia_device *link)
 {
 	int ret;
 
-	printk(KERN_INFO "ni_daq_dio24: HOLA SOY YO! - config\n");
+	dev_info(&link->dev, "ni_daq_dio24: HOLA SOY YO! - config\n");
 
 	dev_dbg(&link->dev, "dio24_config\n");
 
@@ -265,7 +265,7 @@ static void dio24_config(struct pcmcia_device *link)
 	return;
 
 failed:
-	printk(KERN_INFO "Fallo");
+	dev_info(&link->dev, "Fallo");
 	dio24_release(link);
 
 }				/* dio24_config */
-- 
1.7.9.5

