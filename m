Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1JBOsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:48:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1JBOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/30] ARM: omap2: export functions used by nand driver
Date: Sun,  2 Oct 2011 16:45:39 +0200
Message-Id: <1317566760-25681-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ERcXZbrGKFIMg0Zq3qnQf8XrlPUzjzmAYMWQP/EWMEY
 hfmrbB6EzWGrzHhpQFPded7kVVlwXg83FVD1e2GqWxbyysib+n
 LQqTyekyAXjsT3QCLQ7O6rSe0ZeHAPf6rrVZC/VgS7PrwSt92Y
 +zFHbQOGDOcx3/ZCu18vGIAsh14lU4AabzgaS+3tkDg4sm5CTW
 AQCDdhhoDA0yCFi2SrE5zmgsKAZjqSD55MjM4G/p7NrhwNoQWv
 e32PVSZmcCYu0yQar0/kuw+9vn+CnL+W0Aqus+0sCMYEskpK/U
 4jEwm/jqdq+p+IYyGG3zvV9jJzskjkDkfHM7Vie7PQNhdGnG8G
 orhMC6lZ54MoqjVHtPI/99IBMeaN/4xMnrMX9Izj6CFrb4fYT7
 PsdSUYY5sw8Cg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap nand driver uses the gpmc_enable_hwecc and
gpmc_calculate_ecc functions from the platform code,
but can be built as a module.

This only works if the functions are exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/gpmc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 130034b..4ed6880 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -882,6 +882,7 @@ int gpmc_enable_hwecc(int cs, int mode, int dev_width, int ecc_size)
 	gpmc_write_reg(GPMC_ECC_CONFIG, val);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(gpmc_enable_hwecc);
 
 /**
  * gpmc_calculate_ecc - generate non-inverted ecc bytes
@@ -912,3 +913,4 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
 	gpmc_ecc_used = -EINVAL;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(gpmc_calculate_ecc);
-- 
1.7.5.4

