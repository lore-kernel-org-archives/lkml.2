Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab2DLAGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:06:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933639Ab2DKXPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:15:22 -0400
Message-Id: <20120411231020.226745194@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wolfram Sang <w.sang@pengutronix.de>,
        Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 12/78] mtd: nand: gpmi: use correct member for checking NAND_BBT_USE_FLASH
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 5289966ea576a062b80319975b31b661c196ff9d upstream.

This has been moved from .options to .bbt_options meanwhile. So, it
currently checks for something totally different (NAND_OWN_BUFFERS) and
decides according to that.

Artem Bityutskiy: the options were moved in
a40f734 mtd: nand: consolidate redundant flash-based BBT flags

Artem Bityutskiy: CCing -stable

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1124,7 +1124,7 @@ static int gpmi_block_markbad(struct mtd
 		chip->bbt[block >> 2] |= 0x01 << ((block & 0x03) << 1);
 
 	/* Do we have a flash based bad block table ? */
-	if (chip->options & NAND_BBT_USE_FLASH)
+	if (chip->bbt_options & NAND_BBT_USE_FLASH)
 		ret = nand_update_bbt(mtd, ofs);
 	else {
 		chipnr = (int)(ofs >> chip->chip_shift);


