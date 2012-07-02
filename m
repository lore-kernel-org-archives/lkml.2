Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab2GBWpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:45:10 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30623 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2GBWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:45:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1341269104!7498772!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/12] staging: comedi: das08_cs: cleanup and remove useless comments
Date: Mon, 2 Jul 2012 15:45:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021545.04297.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the comment about the PCMCIA support and reword it a bit
because of the move.

Remove a number of useless comments.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 33 ++++++++++++-------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index de094ad..f56fd40 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -20,6 +20,13 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
+    PCMCIA support code for this driver is adapted from the dummy_cs.c
+    driver of the Linux PCMCIA Card Services package.
+
+    The initial developer of the original code is David A. Hinds
+    <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+
 *****************************************************************
 
 */
@@ -97,17 +104,6 @@ static int das08_cs_attach(struct comedi_device *dev,
 	return das08_common_attach(dev, iobase);
 }
 
-/*======================================================================
-
-    The following pcmcia code for the pcm-das08 is adapted from the
-    dummy_cs.c driver of the Linux PCMCIA Card Services package.
-
-    The initial developer of the original code is David A. Hinds
-    <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
-    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
-
-======================================================================*/
-
 static void das08_pcmcia_config(struct pcmcia_device *link);
 static void das08_pcmcia_release(struct pcmcia_device *link);
 static int das08_pcmcia_suspend(struct pcmcia_device *p_dev);
@@ -140,7 +136,7 @@ static int das08_pcmcia_attach(struct pcmcia_device *link)
 	das08_pcmcia_config(link);
 
 	return 0;
-}				/* das08_pcmcia_attach */
+}
 
 static void das08_pcmcia_detach(struct pcmcia_device *link)
 {
@@ -153,7 +149,7 @@ static void das08_pcmcia_detach(struct pcmcia_device *link)
 	/* This points to the parent struct local_info_t struct */
 	kfree(link->priv);
 
-}				/* das08_pcmcia_detach */
+}
 
 
 static int das08_pcmcia_config_loop(struct pcmcia_device *p_dev,
@@ -191,13 +187,13 @@ static void das08_pcmcia_config(struct pcmcia_device *link)
 failed:
 	das08_pcmcia_release(link);
 
-}				/* das08_pcmcia_config */
+}
 
 static void das08_pcmcia_release(struct pcmcia_device *link)
 {
 	dev_dbg(&link->dev, "das08_pcmcia_release\n");
 	pcmcia_disable_device(link);
-}				/* das08_pcmcia_release */
+}
 
 static int das08_pcmcia_suspend(struct pcmcia_device *link)
 {
@@ -206,7 +202,7 @@ static int das08_pcmcia_suspend(struct pcmcia_device *link)
 	local->stop = 1;
 
 	return 0;
-}				/* das08_pcmcia_suspend */
+}
 
 static int das08_pcmcia_resume(struct pcmcia_device *link)
 {
@@ -214,15 +210,12 @@ static int das08_pcmcia_resume(struct pcmcia_device *link)
 
 	local->stop = 0;
 	return 0;
-}				/* das08_pcmcia_resume */
-
-/*====================================================================*/
+}
 
 static const struct pcmcia_device_id das08_cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x4001),
 	PCMCIA_DEVICE_NULL
 };
-
 MODULE_DEVICE_TABLE(pcmcia, das08_cs_id_table);
 
 static struct pcmcia_driver das08_cs_driver = {
-- 
1.7.11

