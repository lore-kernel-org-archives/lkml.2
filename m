Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1LNPKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:10:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3569 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab1LNPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:10:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 14 Dec 2011 07:10:25 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v7 14/14] arm/tegra: add support for tegra30 based board cardhu
Date: Wed, 14 Dec 2011 17:03:26 +0200
Message-ID: <1323875032-18221-15-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
References: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the tegra30 based cardhu development board. Cardhu is a tablet
formfactor reference design for tegra30. The patch provides a device tree for
the board, updates Makefile.boot to build the dtb, includes the platform in
Kconfig and updates board-dt.c.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/boot/dts/tegra-cardhu.dts     |   36 ++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/Makefile.boot      |    1 +
 arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
 3 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra-cardhu.dts

diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
new file mode 100644
index 0000000..70c41fc
--- /dev/null
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -0,0 +1,36 @@
+/dts-v1/;
+
+/include/ "tegra30.dtsi"
+
+/ {
+	model = "NVIDIA Tegra30 Cardhu evaluation board";
+	compatible = "nvidia,cardhu", "nvidia,tegra30";
+
+	memory {
+		reg = < 0x80000000 0x40000000 >;
+	};
+
+	serial@70006000 {
+		clock-frequency = < 408000000 >;
+	};
+
+	i2c@7000c000 {
+		clock-frequency = <100000>;
+	};
+
+	i2c@7000c400 {
+		clock-frequency = <100000>;
+	};
+
+	i2c@7000c500 {
+		clock-frequency = <100000>;
+	};
+
+	i2c@7000c700 {
+		clock-frequency = <100000>;
+	};
+
+	i2c@7000d000 {
+		clock-frequency = <100000>;
+	};
+};
diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
index cf51a00..9a82094 100644
--- a/arch/arm/mach-tegra/Makefile.boot
+++ b/arch/arm/mach-tegra/Makefile.boot
@@ -7,3 +7,4 @@ dtb-$(CONFIG_MACH_PAZ00) += tegra-paz00.dtb
 dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
 dtb-$(CONFIG_MACH_TRIMSLICE) += tegra-trimslice.dtb
 dtb-$(CONFIG_MACH_VENTANA) += tegra-ventana.dtb
+dtb-$(CONFIG_ARCH_TEGRA_3x_SOC) += tegra-cardhu.dtb
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index f44a29c..3c197e2 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -47,6 +47,7 @@ static void __init tegra30_dt_init(void)
 }
 
 static const char *tegra30_dt_board_compat[] = {
+	"nvidia,cardhu",
 	NULL
 };
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

