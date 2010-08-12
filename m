Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0HLCyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 22:54:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233Ab0HLCyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 22:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tfGL34SK6MAmdQ7N5nxKpsrX9SpYTGetGnRmy74QQ0uTODwplYMxMXX0xgtjvBFfuf
         eEgsL3YXgKFRePkqgEjt2sHVuAg8ZL8BEPWg89aBdPQDw20UmF3hB+MtG4/VCrNhAvrg
         Eqc6393QE0XAALrmBa+9Ny3/Wb1kwSK0PfdDs=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        nico@fluxnic.net, kernel@wantstofly.org, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, kaloz@openwrt.org, khc@pm.waw.pl,
        tj@kernel.org, gregkh@suse.de, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Artem.Bityutskiy@nokia.com,
        David.Woodhouse@intel.com, ralf@linux-mips.org, vapier@gentoo.org,
        michael.hennerich@analog.com, barry.song@analog.com,
        sonic.zhang@analog.com, cliff.cai@analog.com,
        uclinux-dist-devel@blackfin.uclinux.org, yakovenkov@gmail.com,
        w.sang@pengutronix.de, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 2/2] gen_nand: Test if nr_chips field is valid
Date: Thu, 12 Aug 2010 04:53:55 +0200
Message-Id: <1281581635-26213-2-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/mtd/nand/plat_nand.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 90e143e..317aff4 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -37,6 +37,11 @@ static int __devinit plat_nand_probe(struct platform_device *pdev)
 	struct resource *res;
 	int err = 0;
 
+	if (pdata->chip.nr_chips < 1) {
+		dev_err(&pdev->dev, "invalid number of chips specified\n");
+		return -EINVAL;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;
-- 
1.7.1

