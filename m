Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab2JAXNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:13:13 -0400
Received: from 1wt.eu ([62.212.114.60]:35535 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab2JAXCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:19 -0400
Message-Id: <20121001225203.883987112@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 148/180] mtd: cafe_nand: fix an & vs | mistake
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 48f8b641297df49021093763a3271119a84990a2 upstream.

The intent here was clearly to set result to true if the 0x40000000 flag
was set.  But instead there was a | vs & typo and we always set result
to true.

Artem: check the spec at
wiki.laptop.org/images/5/5c/88ALP01_Datasheet_July_2007.pdf
and this fix looks correct.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/mtd/nand/cafe_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index c828d9a..97b9c7b 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -103,7 +103,7 @@ static const char *part_probes[] = { "cmdlinepart", "RedBoot", NULL };
 static int cafe_device_ready(struct mtd_info *mtd)
 {
 	struct cafe_priv *cafe = mtd->priv;
-	int result = !!(cafe_readl(cafe, NAND_STATUS) | 0x40000000);
+	int result = !!(cafe_readl(cafe, NAND_STATUS) & 0x40000000);
 	uint32_t irqs = cafe_readl(cafe, NAND_IRQ);
 
 	cafe_writel(cafe, irqs, NAND_IRQ);
-- 
1.7.2.1.45.g54fbc



