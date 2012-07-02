Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab2GBWsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:48:32 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:41078 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2GBWsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:48:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1341269307!5851940!6
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/12] staging: comedi: das08_cs: move the comedi_driver variable
Date: Mon, 2 Jul 2012 15:48:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021548.27296.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/das08_cs.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index f2f33e1..9ec9b12 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -63,19 +63,6 @@ static struct pcmcia_device *cur_dev;
 #define thisboard ((const struct das08_board_struct *)dev->board_ptr)
 
 static int das08_cs_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-
-static struct comedi_driver driver_das08_cs = {
-	.driver_name = "das08_cs",
-	.module = THIS_MODULE,
-	.attach = das08_cs_attach,
-	.detach = das08_common_detach,
-	.board_name = &das08_cs_boards[0].name,
-	.num_names = ARRAY_SIZE(das08_cs_boards),
-	.offset = sizeof(struct das08_board_struct),
-};
-
-static int das08_cs_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
 	int ret;
@@ -104,6 +91,16 @@ static int das08_cs_attach(struct comedi_device *dev,
 	return das08_common_attach(dev, iobase);
 }
 
+static struct comedi_driver driver_das08_cs = {
+	.driver_name	= "das08_cs",
+	.module		= THIS_MODULE,
+	.attach		= das08_cs_attach,
+	.detach		= das08_common_detach,
+	.board_name	= &das08_cs_boards[0].name,
+	.num_names	= ARRAY_SIZE(das08_cs_boards),
+	.offset		= sizeof(struct das08_board_struct),
+};
+
 static int das08_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
 {
-- 
1.7.11

