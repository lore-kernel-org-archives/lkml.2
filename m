Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab0HXXRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:17:41 -0400
Received: from kroah.org ([198.145.64.141]:41048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430Ab0HXXCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:13 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:05 2010
Message-Id: <20100824224505.005332069@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Sauerbeck <tilman@code-monkey.de>,
        Brian Norris <norris@broadcom.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [043/114] mtd: nand: Fix probe of Samsung NAND chips
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Sauerbeck <tilman@code-monkey.de>

commit cfe3fdadb16162327773ef01a575a32000b8c7f4 upstream.

Apparently, the check for a 6-byte ID string introduced by commit
426c457a3216fac74e3d44dd39729b0689f4c7ab ("mtd: nand: extend NAND flash
detection to new MLC chips") is NOT sufficient to determine whether or
not a Samsung chip uses their new MLC detection scheme or the old,
standard scheme. This adds a condition to check cell type.

Signed-off-by: Tilman Sauerbeck <tilman@code-monkey.de>
Signed-off-by: Brian Norris <norris@broadcom.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/nand_base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2852,6 +2852,7 @@ static struct nand_flash_dev *nand_get_f
 		 */
 		if (id_data[0] == id_data[6] && id_data[1] == id_data[7] &&
 				id_data[0] == NAND_MFR_SAMSUNG &&
+				(chip->cellinfo & NAND_CI_CELLTYPE_MSK) &&
 				id_data[5] != 0x00) {
 			/* Calc pagesize */
 			mtd->writesize = 2048 << (extid & 0x03);


