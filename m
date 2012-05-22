Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab2EVX2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:28:24 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:16486 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab2EVX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:28:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1337729284!7217954!9
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the dt2811 driver
Date: Tue, 22 May 2012 16:28:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221628.02405.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'this_board' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 106ffea..727da9e 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -211,8 +211,6 @@ struct dt2811_board {
 	const struct comedi_lrange *unip_5;
 };
 
-#define this_board ((const struct dt2811_board *)dev->board_ptr)
-
 enum { card_2811_pgh, card_2811_pgl };
 
 struct dt2811_private {
@@ -404,6 +402,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* unsigned long irqs; */
 	/* long flags; */
 
+	const struct dt2811_board *board = comedi_board(dev);
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned long iobase;
@@ -418,7 +417,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	dev->iobase = iobase;
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 #if 0
 	outb(0, dev->iobase + DT2811_ADCSR);
@@ -527,13 +526,13 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	switch (it->options[3]) {
 	case 0:
 	default:
-		s->range_table = this_board->bip_5;
+		s->range_table = board->bip_5;
 		break;
 	case 1:
-		s->range_table = this_board->bip_2_5;
+		s->range_table = board->bip_2_5;
 		break;
 	case 2:
-		s->range_table = this_board->unip_5;
+		s->range_table = board->unip_5;
 		break;
 	}
 
