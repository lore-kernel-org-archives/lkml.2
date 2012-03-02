Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2CBWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:25:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61356 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2CBWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:25:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.176.163 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 3/5] ARM: tegra: build localtimer support only when needed
Date: Fri,  2 Mar 2012 17:25:52 -0500
Message-Id: <1330727152-11181-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330727075-10974-1-git-send-email-alan@signal11.us>
References: <1330727075-10974-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

It is possible to build a tegra kernel without localtimer
support, so the tegra specific parts should only be built
when that is indeed enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/mach-tegra/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index e120ff5..829066f 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -13,7 +13,8 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-tegra20-tables.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= pinmux-tegra30-tables.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
-obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
+obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
+obj-$(CONFIG_LOCAL_TIMERS)		+= localtimer.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+= dma.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
-- 
1.7.0.4

