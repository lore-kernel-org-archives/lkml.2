Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab1KBOLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:11:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7382 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1KBOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:09:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Nov 2011 07:09:25 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 8/8] arm/tegra: add support for tegra30 based board cardhu
Date: Wed, 2 Nov 2011 16:09:07 +0200
Message-ID: <1320242948-21061-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
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
 arch/arm/boot/dts/tegra-cardhu.dts |   36 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/Kconfig        |    7 +++++++
 arch/arm/mach-tegra/Makefile.boot  |    1 +
 arch/arm/mach-tegra/board-dt.c     |    1 +
 4 files changed, 45 insertions(+), 0 deletions(-)
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
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index f2eb6d1..43a6352 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -83,6 +83,13 @@ config MACH_VENTANA
        help
          Support for the nVidia Ventana development platform
 
+config MACH_CARDHU
+       bool "Cardhu board"
+       depends on ARCH_TEGRA_3x_SOC
+       select MACH_TEGRA_DT
+       help
+         Support for the nVidia Cardhu development platform
+
 choice
         prompt "Low-level debug console UART"
         default TEGRA_DEBUG_UART_NONE
diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
index bd12c9f..b518848 100644
--- a/arch/arm/mach-tegra/Makefile.boot
+++ b/arch/arm/mach-tegra/Makefile.boot
@@ -5,3 +5,4 @@ initrd_phys-$(CONFIG_ARCH_TEGRA_2x_SOC)	:= 0x00800000
 dtb-$(CONFIG_MACH_HARMONY) += tegra-harmony.dtb
 dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
 dtb-$(CONFIG_MACH_VENTANA) += tegra-ventana.dtb
+dtb-$(CONFIG_MACH_CARDHU) += tegra-cardhu.dtb
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 1680e96..88947b5 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -142,6 +142,7 @@ static const char * tegra_dt_board_compat[] = {
 	"nvidia,harmony",
 	"nvidia,seaboard",
 	"nvidia,ventana",
+	"nvidia,cardhu",
 	NULL
 };
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

