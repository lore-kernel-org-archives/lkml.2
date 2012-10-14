Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2JNOl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464Ab2JNOlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:24 -0400
Message-Id: <20121014143534.078956561@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 002/147] mtd: nand: Use the mirror BBT descriptor when reading its version
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

commit 7bb9c75436212813b38700c34df4bbb6eb82debe upstream.

The code responsible for reading the version of the mirror bbt was
incorrectly using the descriptor of the main bbt.

Pass the mirror bbt descriptor to 'scan_read_raw' when reading the
version of the mirror bbt.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/nand/nand_bbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 30d1319..c126469 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -390,7 +390,7 @@ static int read_abs_bbts(struct mtd_info *mtd, uint8_t *buf,
 	/* Read the mirror version, if available */
 	if (md && (md->options & NAND_BBT_VERSION)) {
 		scan_read_raw(mtd, buf, (loff_t)md->pages[0] << this->page_shift,
-			      mtd->writesize, td);
+			      mtd->writesize, md);
 		md->version[0] = buf[bbt_get_ver_offs(mtd, md)];
 		pr_info("Bad block table at page %d, version 0x%02X\n",
 			 md->pages[0], md->version[0]);


