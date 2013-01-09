Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab3AIUo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:44:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934120Ab3AIUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 14/14] ARM: tegra: trimslice: Initialize PCIe from DT
Date: Wed,  9 Jan 2013 21:43:14 +0100
Message-Id: <1357764194-12677-15-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:QXNWuyRfoCoPMrhKx+Qqs1TtC7knjtIl476g4j89lGH
 g/JUZWgjeYg7+WDCjWZ8Ylkj7gLQ3cE1Y+Jfh5zYkG+rAd/hqZ
 mQmkYBUU+LA+xARAwSGRxKfFsTGfutXBRog2aaiBLtlaLng6wo
 vpM5xh6MDyz4546L+5IVqCZ23yTwvR6eHoE9pIMuAfqFWxy0Vj
 YhNf5MFrfHAvp/V4OCGEzYaLjTOUqsO0gUv1cDhYfdHaN74cjw
 xat4J8Ly03F1p0PU1mHBscThTjZvPg1kghK92be+BcN2H/Cbe+
 c5okVqCDkx3XfFxLhIpYyJ5tzvc/TZifMhL5zkfh8XCjCNPaJN
 6pk/ICWG83mhedKYEE//17zZ9PnzaHOP19xY9vTgBzTfio+rO+
 SI3IGHGfFZyshtPDZJhkv1ML6CfMUorCCW2qTjs9AQsqOmZpj4
 dQh9z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the device tree support in place, probe the PCIe controller from
the device tree and remove the corresponding workaround in the board
file.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v3:
- update for new DT binding

Changes in v2:
- new patch
---
 arch/arm/boot/dts/tegra20-trimslice.dts | 12 ++++++++++++
 arch/arm/mach-tegra/board-dt-tegra20.c  |  8 --------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 4b6c486..ebb4c17 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -301,6 +301,18 @@
 		};
 	};
 
+	pcie-controller {
+		status = "okay";
+
+		pci@0 {
+			status = "okay";
+		};
+
+		pci@1 {
+			status = "okay";
+		};
+	};
+
 	usb@c5000000 {
 		status = "okay";
 		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 9e8256ab..67090fe 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -145,13 +145,6 @@ static void __init tegra_dt_init(void)
 				tegra20_auxdata_lookup, NULL);
 }
 
-static void __init trimslice_init(void)
-{
-#ifdef CONFIG_TEGRA_PCI
-	platform_device_register(&tegra_pcie_device);
-#endif
-}
-
 static void __init paz00_init(void)
 {
 	tegra_paz00_wifikill_init();
@@ -161,7 +154,6 @@ static struct {
 	char *machine;
 	void (*init)(void);
 } board_init_funcs[] = {
-	{ "compulab,trimslice", trimslice_init },
 	{ "compal,paz00", paz00_init },
 };
 
-- 
1.8.1

