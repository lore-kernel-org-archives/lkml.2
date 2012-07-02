Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2GBWqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:46:31 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:3138 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2GBWq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:46:29 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1341269169!14159294!15
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/12] staging: comedi: das08_cs: remove unused pcmcia 'stop' logic
Date: Mon, 2 Jul 2012 15:46:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021546.08927.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia support code in this driver is cut-and-paste from the
dummy_cs.c driver of the Linux PCMCIA Card Services package. It
has code in it to stop the device during suspend but nothing in
the main comedi_driver uses it.

Remove the 'stop' variable from the pcmcia private data and all
the logic that deals with it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 43322c3..044c586 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -149,7 +149,6 @@ failed:
 
 struct local_info_t {
 	struct pcmcia_device *link;
-	int stop;
 	struct bus_operations *bus;
 };
 
@@ -178,7 +177,6 @@ static void das08_pcmcia_detach(struct pcmcia_device *link)
 
 	dev_dbg(&link->dev, "das08_pcmcia_detach\n");
 
-	((struct local_info_t *)link->priv)->stop = 1;
 	das08_pcmcia_release(link);
 
 	/* This points to the parent struct local_info_t struct */
@@ -188,18 +186,11 @@ static void das08_pcmcia_detach(struct pcmcia_device *link)
 
 static int das08_pcmcia_suspend(struct pcmcia_device *link)
 {
-	struct local_info_t *local = link->priv;
-	/* Mark the device as stopped, to block IO until later */
-	local->stop = 1;
-
 	return 0;
 }
 
 static int das08_pcmcia_resume(struct pcmcia_device *link)
 {
-	struct local_info_t *local = link->priv;
-
-	local->stop = 0;
 	return 0;
 }
 
-- 
1.7.11

