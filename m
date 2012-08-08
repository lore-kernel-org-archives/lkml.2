Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2HHOrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:47:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64940 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab2HHOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:47:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Stefan Roese <sr@denx.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 07/11] net/stmmac: mark probe function as __devinit
Date: Wed,  8 Aug 2012 16:47:24 +0200
Message-Id: <1344437248-20560-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:inJnpn/HTsDtvNMO87XOsVab1X71ILad0I2BWePxoOW
 xGo8ZZoLI7u9gvf5AL0AmpFRof4Gaaae2jPp4/hF97ka+fy+Bk
 Z2/dTHaSNoA1OhD3Lz5kOdmGZ2EjoVvyA3MiEU8BnD6HZKnaQv
 oyyNvPthgUN4UxkfPX2Rw2dGyrfjyP9zcbEnee6dfuLPa69ivx
 G3m122STy2TehNioRk82G7v3xamRJNBvZDqX1ZeKxnTBYQbCco
 j9g66bLPSK8ANxwEiQSyc2vzHFC+gjSWqqBHfLbAg8PkpMax6o
 FYGI20okyoyfnf4vuGzLdZzgMxAU4XeKS8KPwB7SovYv08kLvt
 3IxbB4On14lQ9iXNWGknvXWijy54ouMIHdUQohjMrmYEchWFme
 a6F6ZytkfAYf6TTsFTbePg6IRBiR1HaRqg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver probe functions are generally __devinit so they will be
discarded after initialization for non-hotplug kernels.
This was found by a new warning after patch 6a228452d "stmmac: Add
device-tree support" adds a new __devinit function that is called
from stmmac_pltfr_probe.

Without this patch, building socfpga_defconfig results in:

WARNING: drivers/net/ethernet/stmicro/stmmac/stmmac.o(.text+0x5d4c): Section mismatch in reference from the function stmmac_pltfr_probe() to the function .devinit.text:stmmac_probe_config_dt()
The function stmmac_pltfr_probe() references
the function __devinit stmmac_probe_config_dt().
This is often because stmmac_pltfr_probe lacks a __devinit
annotation or the annotation of stmmac_probe_config_dt is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Roese <sr@denx.de>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index cd01ee7..b93245c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -74,7 +74,7 @@ static int __devinit stmmac_probe_config_dt(struct platform_device *pdev,
  * the necessary resources and invokes the main to init
  * the net device, register the mdio bus etc.
  */
-static int stmmac_pltfr_probe(struct platform_device *pdev)
+static int __devinit stmmac_pltfr_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 	struct resource *res;
-- 
1.7.10

