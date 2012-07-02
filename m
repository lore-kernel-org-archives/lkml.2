Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2GBWrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:47:22 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:42181 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2GBWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:47:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1341269238!2953772!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/12] staging: comedi: das08_cs: remove unneeded pcmcia private data
Date: Mon, 2 Jul 2012 15:47:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021547.15334.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia device-specific data is no longer needed by this driver.
Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index b7efcb4..d02250e 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -147,24 +147,10 @@ failed:
 
 }
 
-struct local_info_t {
-	struct pcmcia_device *link;
-	struct bus_operations *bus;
-};
-
 static int das08_pcmcia_attach(struct pcmcia_device *link)
 {
-	struct local_info_t *local;
-
 	dev_dbg(&link->dev, "das08_pcmcia_attach()\n");
 
-	/* Allocate space for private device-specific data */
-	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
-	if (!local)
-		return -ENOMEM;
-	local->link = link;
-	link->priv = local;
-
 	cur_dev = link;
 
 	das08_pcmcia_config(link);
@@ -178,10 +164,6 @@ static void das08_pcmcia_detach(struct pcmcia_device *link)
 	dev_dbg(&link->dev, "das08_pcmcia_detach\n");
 
 	das08_pcmcia_release(link);
-
-	/* This points to the parent struct local_info_t struct */
-	kfree(link->priv);
-
 }
 
 static const struct pcmcia_device_id das08_cs_id_table[] = {
-- 
1.7.11

