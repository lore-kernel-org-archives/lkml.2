Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab2HHHEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:04:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16900 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab2HHHEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:04:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 07 Aug 2012 23:58:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] ARM: dt: tegra: cardhu: split dts file for support multiple board versions
Date: Wed, 8 Aug 2012 12:18:46 +0530
Message-ID: <1344408527-32051-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is multiple version of cardhu starting from A01 to A07.
Cardhu A01 and A03 are not supported. Cardhu A02 will have
different sets of GPIOs for fixed regulator compare to
cardhu A04. The Cardhu A05, A06, A07 are compatibe with A04.
Based on cardhu version, the related dts file need to be chosen
like for cardhu A02, use tegra30-cardhu-a02.dts, cardhu A04 and
more, use tegra30-cardhu-a04.dts.
This patch create the DTS file A02 and A04 and convert tegra30-cardhu.dts
as dts include file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu-a02.dts           |   11 +++++++++
 arch/arm/boot/dts/tegra30-cardhu-a04.dts           |   10 ++++++++
 .../{tegra30-cardhu.dts => tegra30-cardhu.dtsi}    |   24 ++++++++++++++++++-
 arch/arm/mach-tegra/Makefile.boot                  |    3 +-
 4 files changed, 45 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu-a02.dts
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu-a04.dts
 rename arch/arm/boot/dts/{tegra30-cardhu.dts => tegra30-cardhu.dtsi} (85%)

diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
new file mode 100644
index 0000000..dd870b7
--- /dev/null
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -0,0 +1,11 @@
+/dts-v1/;
+
+/include/ "tegra30-cardhu.dtsi"
+
+/* This dts file support the cardhu A02 version of board */
+
+/ {
+	model = "NVIDIA Tegra30 Cardhu A02 evaluation board";
+	compatible = "nvidia,cardhu-a02", "nvidia,cardhu", "nvidia,tegra30";
+};
+
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a04.dts b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
new file mode 100644
index 0000000..a4cae6c
--- /dev/null
+++ b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
@@ -0,0 +1,10 @@
+/dts-v1/;
+
+/include/ "tegra30-cardhu.dtsi"
+
+/* This dts file support the cardhu A04 and later versions of board */
+
+/ {
+	model = "NVIDIA Tegra30 Cardhu A04 (A05, A06, A07) evaluation board";
+	compatible = "nvidia,cardhu-a04", "nvidia,cardhu", "nvidia,tegra30";
+};
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dts b/arch/arm/boot/dts/tegra30-cardhu.dtsi
similarity index 85%
rename from arch/arm/boot/dts/tegra30-cardhu.dts
rename to arch/arm/boot/dts/tegra30-cardhu.dtsi
index 6f9daae..c156273 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -1,7 +1,27 @@
-/dts-v1/;
-
 /include/ "tegra30.dtsi"
 
+/**
+ * This file contains common DT entry for all fab version of Cardhu.
+ * There is multiple fab version of Cardhu starting from A01 to A07.
+ * Cardhu fab version A01 and A03 are not supported. Cardhu fab version
+ * A02 will have different sets of GPIOs for fixed regulator compare to
+ * Cardhu fab version A04. The Cardhu fab version A05, A06, A07 are
+ * compatible with fab version A04. Based on Cardhu fab version, the
+ * related dts file need to be chosen like for Cardhu fab version A02,
+ * use tegra30-cardhu-a02.dts, Cardhu fab version A04 and later, use
+ * tegra30-cardhu-a04.dts.
+ * The identification of board is done in two ways, by looking the sticker
+ * on PCB and by reading board id eeprom.
+ * The stciker will have number like 600-81291-1000-002 C.3. In this 4th
+ * number is the fab version like here it is 002 and hence fab version A02.
+ * The The (downstream internal) U-Boot of Cardhu display the board-id as
+ * follows:
+ * BoardID: 0C5B, SKU: 0A01, Fab: 02, Rev: 45.00
+ * In this Fab version is 02 i.e. A02.
+ * The BoardID eeprom is interfaced through i2c5 (pwr_i2c). The location 0x8
+ * contains the Fab version. It is 1 byte wide.
+ */
+
 / {
 	model = "NVIDIA Tegra30 Cardhu evaluation board";
 	compatible = "nvidia,cardhu", "nvidia,tegra30";
diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
index 7a1bb62..6e35207 100644
--- a/arch/arm/mach-tegra/Makefile.boot
+++ b/arch/arm/mach-tegra/Makefile.boot
@@ -8,4 +8,5 @@ dtb-$(CONFIG_ARCH_TEGRA_2x_SOC) += tegra20-seaboard.dtb
 dtb-$(CONFIG_ARCH_TEGRA_2x_SOC) += tegra20-trimslice.dtb
 dtb-$(CONFIG_ARCH_TEGRA_2x_SOC) += tegra20-ventana.dtb
 dtb-$(CONFIG_ARCH_TEGRA_2x_SOC) += tegra20-whistler.dtb
-dtb-$(CONFIG_ARCH_TEGRA_3x_SOC) += tegra30-cardhu.dtb
+dtb-$(CONFIG_ARCH_TEGRA_3x_SOC) += tegra30-cardhu-a02.dtb
+dtb-$(CONFIG_ARCH_TEGRA_3x_SOC) += tegra30-cardhu-a04.dtb
-- 
1.7.1.1

