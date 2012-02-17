Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2BQOqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:46:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2BQOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:46:39 -0500
From: Bernhard Walle <walle@corscience.de>
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP2+: GPMC: Export gpmc_enable_hwecc and gpmc_calculate_ecc
Date: Fri, 17 Feb 2012 15:44:19 +0100
Message-Id: <1329489859-23929-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.9.1
X-Provags-ID: V02:K0:QbSNsNqXL08h1cV3FpV2vmOW9A/SMK93APAPvwZA6li
 xolY9K0y2RxEsSxy1QoXQAZQwexPknivX185Ey0nBand80Oehb
 WiSAXwLNf03d6SIin0lII66tgPkTUWl4XVc4JF8BwgujXpbg0g
 4wenI8LhVtbq2n+M0jT2s9NydARO/oZ4EnkkebAyFvz6Bar+v7
 E9eUsLdUba/RmNyn28aE8JaW6pq+gwMH9h6epSFsiySDC3ej7J
 l1jRmks8gbhYet5dEusXWf3OR/fUbjQUoImEV911OaieMOslYU
 FrbDvN0XTVT3Ym9BPN8iOjIAmJqBElXX8LF+QqLN3CERAI1J06
 M1M2AdArWwrMivY5an09nN8j4xno0RbZgvLWGbYN4AYnPr07Qh
 p9sJuj7iBwQMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to compile kernel/drivers/mtd/nand/omap2.ko as module, that
two symbols need to be exported. Otherwise, I get following error
message

    ERROR: "gpmc_calculate_ecc" [drivers/mtd/nand/omap2.ko] undefined!
    ERROR: "gpmc_enable_hwecc" [drivers/mtd/nand/omap2.ko] undefined!

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 arch/arm/mach-omap2/gpmc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index dfffbbf..00d5108 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -888,6 +888,7 @@ int gpmc_enable_hwecc(int cs, int mode, int dev_width, int ecc_size)
 	gpmc_write_reg(GPMC_ECC_CONFIG, val);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(gpmc_enable_hwecc);
 
 /**
  * gpmc_calculate_ecc - generate non-inverted ecc bytes
@@ -918,3 +919,4 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
 	gpmc_ecc_used = -EINVAL;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(gpmc_calculate_ecc);
-- 
1.7.9.1

