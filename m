Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab0KRXDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:03:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40025 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0KRXC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:02:59 -0500
Date: Thu, 18 Nov 2010 15:02:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd: fix nand kernel-doc warnings
Message-Id: <20101118150221.2f38e9b0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Warning(include/linux/mtd/nand.h:543): No description found for parameter 'badblockbits'
Warning(drivers/mtd/nand/nand_bbt.c:1101): No description found for parameter 'mtd'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	David Woodhouse <dwmw2@infradead.org>
Cc:	linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/nand_bbt.c |    3 ++-
 include/linux/mtd/nand.h    |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- lnx-2637-r2g4-kerndoc.orig/include/linux/mtd/nand.h
+++ lnx-2637-r2g4-kerndoc/include/linux/mtd/nand.h
@@ -448,6 +448,8 @@ struct nand_buffers {
  *			See the defines for further explanation.
  * @badblockpos:	[INTERN] position of the bad block marker in the oob
  *			area.
+ * @badblockbits:	[INTERN] number of bits to left-shift the bad block
+ *			number
  * @cellinfo:		[INTERN] MLC/multichip data from chip ident
  * @numchips:		[INTERN] number of physical chips
  * @chipsize:		[INTERN] the size of one chip for multichip arrays
--- lnx-2637-r2g4-kerndoc.orig/drivers/mtd/nand/nand_bbt.c
+++ lnx-2637-r2g4-kerndoc/drivers/mtd/nand/nand_bbt.c
@@ -1092,7 +1092,8 @@ static void mark_bbt_region(struct mtd_i
 
 /**
  * verify_bbt_descr - verify the bad block description
- * @bd:			the table to verify
+ * @mtd:	MTD device structure
+ * @bd:		the table to verify
  *
  * This functions performs a few sanity checks on the bad block description
  * table.
