Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2FTUu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:50:29 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:61546 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2FTUu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:50:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1340225399!3633376!50
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: ssv_dnp: remove empty private data
Date: Wed, 20 Jun 2012 13:50:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201350.04298.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data struct 'dnp_private_data' contains no information.
Remove it and the alloc_private() call.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ssv_dnp.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 72dbccc..84b9f2a 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -59,14 +59,6 @@ struct dnp_board {
 	int have_dio;
 };
 
-/* This structure is for data unique to the DNP driver --------------------- */
-struct dnp_private_data {
-
-};
-
-/* Shorthand macro for faster access to the private data ------------------- */
-#define devpriv ((dnp_private *)dev->private)
-
 /* ------------------------------------------------------------------------- */
 /* The insn_bits interface allows packed reading/writing of DIO channels.    */
 /* The comedi core can convert between insn_bits and insn_read/write, so you */
@@ -189,11 +181,6 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = board->name;
 
-	/* Allocate the private structure area. alloc_private() is a         */
-	/* convenient macro defined in comedidev.h.                          */
-	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret)
 		return ret;
-- 
1.7.11

