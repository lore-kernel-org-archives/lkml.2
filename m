Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2FYXKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:10:46 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:28376 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2FYXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:10:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1340665843!6297827!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/33] staging: comedi: cb_das16_cs: remove some useless comments
Date: Mon, 25 Jun 2012 16:10:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251610.38013.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some useless comments and whitespace.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 61 ++++++----------------------
 1 file changed, 13 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 2ac30f4..2063215 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -19,6 +19,13 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
+    PCMCIA support code for the is adapted from the dummy_cs.c driver
+    of the Linux PCMCIA Card Services package.
+
+    The initial developer of the original code is David A. Hinds
+    <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+
 */
 /*
 Driver: cb_das16_cs
@@ -616,58 +623,20 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 	return -EINVAL;
 }
 
-/* PCMCIA stuff */
-
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
 static void das16cs_pcmcia_config(struct pcmcia_device *link);
 static void das16cs_pcmcia_release(struct pcmcia_device *link);
 static int das16cs_pcmcia_suspend(struct pcmcia_device *p_dev);
 static int das16cs_pcmcia_resume(struct pcmcia_device *p_dev);
 
-/*
-   The attach() and detach() entry points are used to create and destroy
-   "instances" of the driver, where each instance represents everything
-   needed to manage one actual PCMCIA card.
-*/
-
 static int das16cs_pcmcia_attach(struct pcmcia_device *);
 static void das16cs_pcmcia_detach(struct pcmcia_device *);
 
-/*
-   You'll also need to prototype all the functions that will actually
-   be used to talk to your device.  See 'memory_cs' for a good example
-   of a fully self-sufficient driver; the other drivers rely more or
-   less on other parts of the kernel.
-*/
-
 struct local_info_t {
 	struct pcmcia_device *link;
 	int stop;
 	struct bus_operations *bus;
 };
 
-/*======================================================================
-
-    das16cs_pcmcia_attach() creates an "instance" of the driver, allocating
-    local data structures for one device.  The device is registered
-    with Card Services.
-
-    The dev_link structure is initialized, but we don't actually
-    configure the card at this point -- we wait until we receive a
-    card insertion event.
-
-======================================================================*/
-
 static int das16cs_pcmcia_attach(struct pcmcia_device *link)
 {
 	struct local_info_t *local;
@@ -686,7 +655,7 @@ static int das16cs_pcmcia_attach(struct pcmcia_device *link)
 	das16cs_pcmcia_config(link);
 
 	return 0;
-}				/* das16cs_pcmcia_attach */
+}
 
 static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 {
@@ -696,8 +665,7 @@ static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 	das16cs_pcmcia_release(link);
 	/* This points to the parent struct local_info_t struct */
 	kfree(link->priv);
-}				/* das16cs_pcmcia_detach */
-
+}
 
 static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
@@ -734,13 +702,13 @@ static void das16cs_pcmcia_config(struct pcmcia_device *link)
 
 failed:
 	das16cs_pcmcia_release(link);
-}				/* das16cs_pcmcia_config */
+}
 
 static void das16cs_pcmcia_release(struct pcmcia_device *link)
 {
 	dev_dbg(&link->dev, "das16cs_pcmcia_release\n");
 	pcmcia_disable_device(link);
-}				/* das16cs_pcmcia_release */
+}
 
 static int das16cs_pcmcia_suspend(struct pcmcia_device *link)
 {
@@ -750,7 +718,7 @@ static int das16cs_pcmcia_suspend(struct pcmcia_device *link)
 	local->stop = 1;
 
 	return 0;
-}				/* das16cs_pcmcia_suspend */
+}
 
 static int das16cs_pcmcia_resume(struct pcmcia_device *link)
 {
@@ -758,16 +726,13 @@ static int das16cs_pcmcia_resume(struct pcmcia_device *link)
 
 	local->stop = 0;
 	return 0;
-}				/* das16cs_pcmcia_resume */
-
-/*====================================================================*/
+}
 
 static const struct pcmcia_device_id das16cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x0039),
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x4009),
 	PCMCIA_DEVICE_NULL
 };
-
 MODULE_DEVICE_TABLE(pcmcia, das16cs_id_table);
 
 static struct pcmcia_driver das16cs_driver = {
-- 
1.7.11

