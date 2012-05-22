Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2EVWqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:46:15 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:48146 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2EVWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:46:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1337726768!12407901!9
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the aio_aio12_8 driver
Date: Tue, 22 May 2012 15:46:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221546.02469.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 64d82bc..d215ae1 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -80,8 +80,6 @@ static const struct aio12_8_boardtype board_types[] = {
 	 .name = "aio_aio12_8"},
 };
 
-#define	thisboard	((const struct aio12_8_boardtype  *) dev->board_ptr)
-
 struct aio12_8_private {
 	unsigned int ao_readback[4];
 };
@@ -167,6 +165,7 @@ static const struct comedi_lrange range_aio_aio12_8 = {
 static int aio_aio12_8_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
+	const struct aio12_8_boardtype *board = comedi_board(dev);
 	int iobase;
 	struct comedi_subdevice *s;
 
@@ -176,7 +175,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 		return -EIO;
 	}
 
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	dev->iobase = iobase;
 
