Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2EWBEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:04:24 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:23647 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab2EWBEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:04:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1337735062!6395475!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the serial2002 driver
Date: Tue, 22 May 2012 18:04:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221804.19324.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 6342bc5..9200310 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -47,11 +47,6 @@ struct serial2002_board {
 	const char *name;
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct serial2002_board *)dev->board_ptr)
-
 struct serial2002_range_table_t {
 
 	/*  HACK... */
@@ -783,10 +778,11 @@ static int serial2002_ei_rinsn(struct comedi_device *dev,
 static int serial2002_attach(struct comedi_device *dev,
 			     struct comedi_devconfig *it)
 {
+	const struct serial2002_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 
 	dev_dbg(dev->hw_dev, "comedi%d: attached\n", dev->minor);
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
 	dev->open = serial_2002_open;
