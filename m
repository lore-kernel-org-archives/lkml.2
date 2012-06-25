Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab2FYXXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:23:05 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:45775 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab2FYXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:23:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1340666581!11493432!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/33] staging: comedi: cb_das16_cs: remove unneeded pcmcia private data
Date: Mon, 25 Jun 2012 16:22:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251622.53207.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia device-specific data is not longer needed by this
driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index df9b075..8661e13 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -623,11 +623,6 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 	return -EINVAL;
 }
 
-struct local_info_t {
-	struct pcmcia_device *link;
-	struct bus_operations *bus;
-};
-
 static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
 {
@@ -639,16 +634,8 @@ static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
 
 static int das16cs_pcmcia_attach(struct pcmcia_device *link)
 {
-	struct local_info_t *local;
 	int ret;
 
-	/* Allocate space for private device-specific data */
-	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
-	if (!local)
-		return -ENOMEM;
-	local->link = link;
-	link->priv = local;
-
 	/* Do we need to allocate an interrupt? */
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
@@ -674,8 +661,6 @@ failed:
 static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 {
 	pcmcia_disable_device(link);
-	/* This points to the parent struct local_info_t struct */
-	kfree(link->priv);
 	cur_dev = NULL;
 }
 
-- 
1.7.11

