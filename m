Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2JBQhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2JBQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH 07/17] ARM: at91: skip at91_io_desc definition for NOMMU
Date: Tue,  2 Oct 2012 18:36:46 +0200
Message-Id: <1349195816-2225-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QlHjxEnwLmwA1epN32TkX6c5cr6WnGd/TanEiFmfhum
 KpXYiX+zzt26aCVo/w5PDALnXqKSb6A3e/itiUtN4JWXZxoLKN
 7H6FwZKsKcEpLeVjuSeXkS8KLAPSe3lh0IstvvTN/7d0saXYqD
 Ow3FxpwYj5Lah0KiYyXWfgoL4/A+E02wgEOBUyVOxY6p/FPzgb
 gfxzJxhFs7UBGMyVQqfbRRMJkirNDza3oq+EGmNqtIqfOd1AGD
 SmcdgpNT9lzlhomLbkpb6QoXs88EVfDpMGqAhDlQhmuX3Gqt0D
 XglbHZxhkxCX6AzimNTwDwPYCcKiQZvuIWjAyDFgkyeyeVqr2/
 PQNchHz5XtQMQWbF8VBKqsAFXRNW7DfHmB97X7LpP4FGgKU8Fk
 lf73XimAq/OJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NOMMU systems, we do cannot remap the MMIO space, so the
definition of at91_io_desc is unused.

Without this patch, building at91x40_defconfig results in:

arch/arm/mach-at91/setup.c:90:24: warning: 'at91_io_desc' defined but not used [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 944bffb..b9fdba0 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -87,12 +87,14 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
 	iotable_init(desc, 1);
 }
 
+#ifdef CONFIG_MMU
 static struct map_desc at91_io_desc __initdata = {
 	.virtual	= AT91_VA_BASE_SYS,
 	.pfn		= __phys_to_pfn(AT91_BASE_SYS),
 	.length		= SZ_16K,
 	.type		= MT_DEVICE,
 };
+#endif
 
 static void __init soc_detect(u32 dbgu_base)
 {
-- 
1.7.10

