Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab2GBWtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:49:04 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:37535 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2GBWtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:49:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1341269341!13205343!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/12] staging: comedi: das08_cs: remove thisboard macro
Date: Mon, 2 Jul 2012 15:48:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021548.58369.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro relies on a local variable having a specific
name and yields a pointer derived from that local variable. Replace
the macro with a local variable where used. Use the comedi_board()
helper to get the pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 9ec9b12..f5700de 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -60,11 +60,10 @@ Command support does not exist, but could be added for this board.
 
 static struct pcmcia_device *cur_dev;
 
-#define thisboard ((const struct das08_board_struct *)dev->board_ptr)
-
 static int das08_cs_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
+	const struct das08_board_struct *thisboard = comedi_board(dev);
 	int ret;
 	unsigned long iobase;
 	struct pcmcia_device *link = cur_dev;	/*  XXX hack */
-- 
1.7.11

