Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787Ab2FVXSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:18:09 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:45040 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2FVXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:18:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340407082!12243052!7
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/31] staging: comedi: ni_daq_700: Move the comedi_driver variable
Date: Fri, 22 Jun 2012 16:17:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221617.52547.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the comedi_driver variable to remove the need for the
forward declarations. Add some whitespace to the declaration
for aesthetic reasons.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index f9b0d67..b851e2e 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -55,10 +55,6 @@ static struct pcmcia_device *pcmcia_cur_dev;
 
 #define DIO700_SIZE 8		/*  size of io region used by board */
 
-static int dio700_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static void dio700_detach(struct comedi_device *dev);
-
 enum dio700_bustype { pcmcia_bustype };
 
 struct dio700_board {
@@ -101,16 +97,6 @@ struct dio700_private {
 
 #define devpriv ((struct dio700_private *)dev->private)
 
-static struct comedi_driver driver_dio700 = {
-	.driver_name = "ni_daq_700",
-	.module = THIS_MODULE,
-	.attach = dio700_attach,
-	.detach = dio700_detach,
-	.num_names = ARRAY_SIZE(dio700_boards),
-	.board_name = &dio700_boards[0].name,
-	.offset = sizeof(struct dio700_board),
-};
-
 #define _700_SIZE 8
 
 #define _700_DATA 0
@@ -306,6 +292,16 @@ static void dio700_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 };
 
+static struct comedi_driver driver_dio700 = {
+	.driver_name	= "ni_daq_700",
+	.module		= THIS_MODULE,
+	.attach		= dio700_attach,
+	.detach		= dio700_detach,
+	.board_name	= &dio700_boards[0].name,
+	.num_names	= ARRAY_SIZE(dio700_boards),
+	.offset		= sizeof(struct dio700_board),
+};
+
 static void dio700_release(struct pcmcia_device *link)
 {
 	dev_dbg(&link->dev, "dio700_release\n");
-- 
1.7.11

