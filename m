Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2FZAXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:23:21 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:57455 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab2FZAXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:23:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340670193!12499575!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/33] staging: comedi: cb_das16_cs: remove some commented out debug
Date: Mon, 25 Jun 2012 17:23:06 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251723.06818.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The das16cs_ao_winsn() function has a couple commented out
debug messages. Just remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 0d303d1..791bf11 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -341,17 +341,14 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 		else
 			status1 |= 0x0008;
 
-/*		printk("0x%04x\n",status1);*/
 		outw(status1, dev->iobase + DAS16CS_MISC1);
 		udelay(1);
 
 		for (bit = 15; bit >= 0; bit--) {
 			int b = (d >> bit) & 0x1;
 			b <<= 1;
-/*			printk("0x%04x\n",status1 | b | 0x0000);*/
 			outw(status1 | b | 0x0000, dev->iobase + DAS16CS_MISC1);
 			udelay(1);
-/*			printk("0x%04x\n",status1 | b | 0x0004);*/
 			outw(status1 | b | 0x0004, dev->iobase + DAS16CS_MISC1);
 			udelay(1);
 		}
-- 
1.7.11

