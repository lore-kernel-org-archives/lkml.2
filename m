Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab2FYXXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:23:46 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:58497 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab2FYXXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:23:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1340666623!12519166!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/33] staging: comedi: cb_das16_cs: Move the comedi_driver variable
Date: Mon, 25 Jun 2012 16:23:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251623.38443.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the comedi_driver variable to remove the need for the
forward declarations. Add some whitespace to the declaration
for aesthetic reasons.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 8661e13..92c774d 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -96,16 +96,6 @@ struct das16cs_private {
 };
 #define devpriv ((struct das16cs_private *)dev->private)
 
-static int das16cs_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static void das16cs_detach(struct comedi_device *dev);
-static struct comedi_driver driver_das16cs = {
-	.driver_name = "cb_das16_cs",
-	.module = THIS_MODULE,
-	.attach = das16cs_attach,
-	.detach = das16cs_detach,
-};
-
 static struct pcmcia_device *cur_dev;
 
 static const struct comedi_lrange das16cs_ai_range = { 4, {
@@ -623,6 +613,13 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 	return -EINVAL;
 }
 
+static struct comedi_driver driver_das16cs = {
+	.driver_name	= "cb_das16_cs",
+	.module		= THIS_MODULE,
+	.attach		= das16cs_attach,
+	.detach		= das16cs_detach,
+};
+
 static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
 {
-- 
1.7.11

