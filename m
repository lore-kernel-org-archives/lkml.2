Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab1JCEHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 00:07:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43440 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1JCEHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 00:07:43 -0400
Subject: [PATCH] mmc: sdhci-tegra: Add #ifdef CONFIG_OF guard for
 of_find_property
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 12:07:32 +0800
Message-ID: <1317614852.30838.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below build error with "make tegra_defconfig;make"
Add #ifdef CONFIG_OF guard for of_find_property to fix below build error:

  CC      drivers/mmc/host/sdhci-tegra.o
drivers/mmc/host/sdhci-tegra.c: In function 'sdhci_tegra_dt_parse_pdata':
drivers/mmc/host/sdhci-tegra.c:157: error: implicit declaration of function 'of_find_property'
make[3]: *** [drivers/mmc/host/sdhci-tegra.o] Error 1
make[2]: *** [drivers/mmc/host] Error 2
make[1]: *** [drivers/mmc] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error on linux-next (20110930).
Axel

 drivers/mmc/host/sdhci-tegra.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 67176afc..3883602 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -154,8 +154,11 @@ static struct tegra_sdhci_platform_data * __devinit sdhci_tegra_dt_parse_pdata(
 	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
 	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
 	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
+
+#ifdef CONFIG_OF
 	if (of_find_property(np, "support-8bit", NULL))
 		plat->is_8bit = 1;
+#endif
 
 	return plat;
 }
-- 
1.7.4.1



