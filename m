Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab2EWBIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:08:51 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:57059 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab2EWBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:08:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1337735328!6391861!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the ssv_dnp driver
Date: Tue, 22 May 2012 18:08:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221808.36694.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 16c4f5a..de58095 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -59,9 +59,6 @@ struct dnp_board {
 	int have_dio;
 };
 
-/* Useful for shorthand access to the particular board structure ----------- */
-#define thisboard ((const struct dnp_board *)dev->board_ptr)
-
 /* This structure is for data unique to the DNP driver --------------------- */
 struct dnp_private_data {
 
@@ -188,18 +185,12 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 
 static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct dnp_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 
 	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
 
-	/* Autoprobing: this should find out which board we have. Currently  */
-	/* only the 1486 board is supported and autoprobing is not           */
-	/* implemented :-)                                                   */
-	/* dev->board_ptr = dnp_probe(dev); */
-
-	/* Initialize the name of the board.                                 */
-	/* We can use the "thisboard" macro now.                             */
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	/* Allocate the private structure area. alloc_private() is a         */
 	/* convenient macro defined in comedidev.h.                          */
