Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2HTS3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:29:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:54658 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2HTS3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:29:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1345487384!7944198!6
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] staging: comedi: aio_aio12_8: fix i/o region size
Date: Mon, 20 Aug 2012 11:29:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201129.16773.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This board has jumpers to set the board base address. These
jumpers are marked A5 through A9 and A5 is the least significant
bit of the address. This makes the address reqion for the board
32 bytes not 24.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_aio12_8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 46ef41a..c07de3e 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -206,7 +206,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	dev->board_name = board->name;
 
 	iobase = it->options[0];
-	if (!request_region(iobase, 24, dev->board_name)) {
+	if (!request_region(iobase, 32, dev->board_name)) {
 		printk(KERN_ERR "I/O port conflict");
 		return -EIO;
 	}
-- 
1.7.11

