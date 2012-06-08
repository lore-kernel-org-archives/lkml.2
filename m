Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab2FHFYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:24:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43181 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760708Ab2FHFHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:18 -0400
Message-Id: <20120608041846.076327466@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Maluka <D.Maluka@adbglobal.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 39/82] mtd: nand: fix scan_read_raw_oob
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Maluka <D.Maluka@adbglobal.com>

commit 34a5704d91d6f8376a4c0a0143a1dd3eb3ccb37e upstream.

It seems there is a bug in scan_read_raw_oob() in nand_bbt.c which
should cause wrong functioning of NAND_BBT_SCANALLPAGES option.

Artem: the patch did not apply and I had to amend it a bit.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/nand/nand_bbt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 20a112f..30d1319 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -324,6 +324,7 @@ static int scan_read_raw_oob(struct mtd_info *mtd, uint8_t *buf, loff_t offs,
 
 		buf += mtd->oobsize + mtd->writesize;
 		len -= mtd->writesize;
+		offs += mtd->writesize;
 	}
 	return 0;
 }


