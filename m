Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0EYFZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:25:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32491 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EYFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:25:31 -0400
Date: Mon, 24 May 2010 22:22:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/nand_base: fix kernel-doc warnings & typos
Message-Id: <20100524222251.5c99b939.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BFB5F1F.00BF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mtd/nand_base.c kernel-doc warnings and typos.

Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'mtd'
Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'ofs'
Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'len'
Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'invert'
Warning(drivers/mtd/nand/nand_base.c:930): No description found for parameter 'mtd'
Warning(drivers/mtd/nand/nand_base.c:930): No description found for parameter 'ofs'
Warning(drivers/mtd/nand/nand_base.c:930): No description found for parameter 'len'
Warning(drivers/mtd/nand/nand_base.c:987): No description found for parameter 'mtd'
Warning(drivers/mtd/nand/nand_base.c:987): No description found for parameter 'ofs'
Warning(drivers/mtd/nand/nand_base.c:987): No description found for parameter 'len'
Warning(drivers/mtd/nand/nand_base.c:2087): No description found for parameter 'len'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/nand_base.c |   39 ++++++++++++++++-----------------
 scripts/kernel-doc           |    2 +
 2 files changed, 22 insertions(+), 19 deletions(-)

--- lnx-2634-g8-kerndoc.orig/drivers/mtd/nand/nand_base.c
+++ lnx-2634-g8-kerndoc/drivers/mtd/nand/nand_base.c
@@ -876,17 +876,17 @@ static int nand_wait(struct mtd_info *mt
 }
 
 /**
- * __nand_unlock - [REPLACABLE] unlocks specified locked blockes
+ * __nand_unlock - [REPLACEABLE] unlocks specified locked blocks
  *
- * @param mtd - mtd info
- * @param ofs - offset to start unlock from
- * @param len - length to unlock
- * @invert -  when = 0, unlock the range of blocks within the lower and
+ * @mtd: mtd info
+ * @ofs: offset to start unlock from
+ * @len: length to unlock
+ * @invert:   when = 0, unlock the range of blocks within the lower and
  *                      upper boundary address
- *            whne = 1, unlock the range of blocks outside the boundaries
+ *            when = 1, unlock the range of blocks outside the boundaries
  *                      of the lower and upper boundary address
  *
- * @return - unlock status
+ * return - unlock status
  */
 static int __nand_unlock(struct mtd_info *mtd, loff_t ofs,
 					uint64_t len, int invert)
@@ -918,13 +918,13 @@ static int __nand_unlock(struct mtd_info
 }
 
 /**
- * nand_unlock - [REPLACABLE] unlocks specified locked blockes
+ * nand_unlock - [REPLACEABLE] unlocks specified locked blocks
  *
- * @param mtd - mtd info
- * @param ofs - offset to start unlock from
- * @param len - length to unlock
+ * @mtd: mtd info
+ * @ofs: offset to start unlock from
+ * @len: length to unlock
  *
- * @return - unlock status
+ * return - unlock status
  */
 int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
@@ -969,16 +969,16 @@ out:
 }
 
 /**
- * nand_lock - [REPLACABLE] locks all blockes present in the device
+ * nand_lock - [REPLACEABLE] locks all blocks present in the device
  *
- * @param mtd - mtd info
- * @param ofs - offset to start unlock from
- * @param len - length to unlock
+ * @mtd: mtd info
+ * @ofs: offset to start unlock from
+ * @len: length to unlock
  *
- * @return - lock status
+ * return - lock status
  *
- * This feature is not support in many NAND parts. 'Micron' NAND parts
- * do have this feature, but it allows only to lock all blocks not for
+ * This feature is not supported in many NAND parts. 'Micron' NAND parts
+ * do have this feature, but it allows only to lock all blocks, not for
  * specified range for block.
  *
  * Implementing 'lock' feature by making use of 'unlock', for now.
@@ -2080,6 +2080,7 @@ static int nand_write_page(struct mtd_in
  * nand_fill_oob - [Internal] Transfer client buffer to oob
  * @chip:	nand chip structure
  * @oob:	oob data buffer
+ * @len:	oob data write length
  * @ops:	oob ops structure
  */
 static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob, size_t len,
--- lnx-2634-g8-kerndoc.orig/scripts/kernel-doc
+++ lnx-2634-g8-kerndoc/scripts/kernel-doc
@@ -1454,6 +1454,8 @@ sub dump_enum($$) {
     my $file = shift;
 
     $x =~ s@/\*.*?\*/@@gos;	# strip comments.
+    $x =~ s/^#\s*define\s+.*$//; # strip #define macros inside enums
+
     if ($x =~ /enum\s+(\w+)\s*{(.*)}/) {
 	$declaration_name = $1;
 	my $members = $2;
