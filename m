Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162821Ab2GLXNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:13:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162734Ab2GLXFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:05:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 43/68] mtd: cafe_nand: fix an & vs | mistake
Date: Thu, 12 Jul 2012 16:02:17 -0700
Message-Id: <20120712175039.261911811@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/mtd/nand/cafe_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -102,7 +102,7 @@ static const char *part_probes[] = { "cm
 static int cafe_device_ready(struct mtd_info *mtd)
 {
 	struct cafe_priv *cafe = mtd->priv;
-	int result = !!(cafe_readl(cafe, NAND_STATUS) | 0x40000000);
+	int result = !!(cafe_readl(cafe, NAND_STATUS) & 0x40000000);
 	uint32_t irqs = cafe_readl(cafe, NAND_IRQ);
 
 	cafe_writel(cafe, irqs, NAND_IRQ);


