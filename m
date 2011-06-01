Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162158Ab1FAIR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:17:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162101Ab1FAIRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:51 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:07 2011
Message-Id: <20110601081107.184422386@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:01 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Parth Saxena <parth.saxena@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [031/165] mtd: return badblockbits back
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1202
Lines: 35

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 26d9be11485ea8c1102c3e8eaa7667412eef4950 upstream.

In commit c7b28e25cb9beb943aead770ff14551b55fa8c79 the initialization of
the backblockbits was accidentally removed. This patch returns it back,
because otherwise some NAND drivers are broken.

This problem was reported by "Saxena, Parth <parth.saxena@ti.com>" here:
http://lists.infradead.org/pipermail/linux-mtd/2011-April/035221.html

Reported-by: Parth Saxena <parth.saxena@ti.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Tested-by: Parth Saxena <parth.saxena@ti.com>
Acked-by: Parth Saxena <parth.saxena@ti.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/nand_base.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3112,6 +3112,8 @@ ident_done:
 		chip->chip_shift += 32 - 1;
 	}
 
+	chip->badblockbits = 8;
+
 	/* Set the bad block position */
 	if (mtd->writesize > 512 || (busw & NAND_BUSWIDTH_16))
 		chip->badblockpos = NAND_LARGE_BADBLOCK_POS;


