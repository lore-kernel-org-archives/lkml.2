Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2JEO7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:59:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2JEO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 10/16] clk: don't mark clkdev_add_table as init
Date: Fri,  5 Oct 2012 16:55:24 +0200
Message-Id: <1349448930-23976-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:keJqiLIVbZgeXCb4z8+IWB0iNtgUhUxyttK28IlvaiG
 vh+p/68zlYRE4TsydZgIeiSRufH5wkmmj5pJb5tBYN4JhwUR1G
 NLMGMKUL2I6J4Fpdu0gwopehXVotxOUavjS9uTnSFHIkrCmHrw
 Ol0BtoMvR/Y1MAFn/FNoVv27DUfSdmUmvStfGW3+L97jA35AYS
 2n3xQ9S12LWVtMMyM0e5f0K2Fa+jE4moFJhpUYlSlBY6PhK7Oc
 Zw4IduzPuH4/r8kruzX06rr59XBD4E0McLNBjcMb+Po8CTvhJ0
 VaU6YSjqMNRRJVy4r3yqpFtpsVdT4vH1y0+ZcxVaSMiJwWYfZt
 gJvl4mfBSeK9VVoaiFPUxUWdbYzzBrDPsDIxbkRifLIAd1sMqd
 PE3QAVs1gJgtSCa0UUpZg/4rF16vkjTm3U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c2440_clk_add is a subsys_interface method and calls clkdev_add_table,
which means we might be calling it after the __init section is
discarded.

Without this patch, building mini2440_defconfig results in:

WARNING: vmlinux.o(.text+0x9848): Section mismatch in reference from the function s3c2440_clk_add() to the function .init.text:clkdev_add_table()
The function s3c2440_clk_add() references
the function __init clkdev_add_table().
This is often because s3c2440_clk_add lacks a __init
annotation or the annotation of clkdev_add_table is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/clk/clkdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..6956857 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -179,7 +179,7 @@ void clkdev_add(struct clk_lookup *cl)
 }
 EXPORT_SYMBOL(clkdev_add);
 
-void __init clkdev_add_table(struct clk_lookup *cl, size_t num)
+void clkdev_add_table(struct clk_lookup *cl, size_t num)
 {
 	mutex_lock(&clocks_mutex);
 	while (num--) {
-- 
1.7.10

