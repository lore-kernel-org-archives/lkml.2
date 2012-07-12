Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162034Ab2GLWmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:42:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162013Ab2GLWm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 120/187] mtd: cafe_nand: fix an & vs | mistake
Date: Thu, 12 Jul 2012 15:34:36 -0700
Message-Id: <20120712191533.493857541@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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


