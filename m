Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1HHVBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:01:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33295 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1HHVBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:01:17 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: Tegra: Force PORT_TEGRA as the UART type
Date: Mon,  8 Aug 2011 15:01:05 -0600
Message-Id: <1312837265-11984-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8250.c recently gained an explicit PORT_TEGRA port type. Specifically
request this in all Tegra boards' UART platform data.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
NOTE: This depends on "[PATCH 1/5] ARM: tegra: paz00: add support serial
port on JP1", which was recently posted by Marc Dietrich, since that added
one of the platform data array entries being modified by this patch.

 arch/arm/mach-tegra/board-harmony.c   |    3 ++-
 arch/arm/mach-tegra/board-paz00.c     |    6 ++++--
 arch/arm/mach-tegra/board-seaboard.c  |    3 ++-
 arch/arm/mach-tegra/board-trimslice.c |    3 ++-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index f528a5a..987dab5 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -49,7 +49,8 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.membase	= IO_ADDRESS(TEGRA_UARTD_BASE),
 		.mapbase	= TEGRA_UARTD_BASE,
 		.irq		= INT_UARTD,
-		.flags		= UPF_BOOT_AUTOCONF,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
+		.type		= PORT_TEGRA,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index b7494c2..c6a6d82 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -49,7 +49,8 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.membase	= IO_ADDRESS(TEGRA_UARTA_BASE),
 		.mapbase	= TEGRA_UARTA_BASE,
 		.irq		= INT_UARTA,
-		.flags		= UPF_BOOT_AUTOCONF,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
+		.type		= PORT_TEGRA,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
@@ -58,7 +59,8 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.membase	= IO_ADDRESS(TEGRA_UARTD_BASE),
 		.mapbase	= TEGRA_UARTD_BASE,
 		.irq		= INT_UARTD,
-		.flags		= UPF_BOOT_AUTOCONF,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
+		.type		= PORT_TEGRA,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index 237a94a..25446df 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -44,7 +44,8 @@
 static struct plat_serial8250_port debug_uart_platform_data[] = {
 	{
 		/* Memory and IRQ filled in before registration */
-		.flags		= UPF_BOOT_AUTOCONF,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
+		.type		= PORT_TEGRA,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index 89a6d2a..91875b9 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -46,7 +46,8 @@ static struct plat_serial8250_port debug_uart_platform_data[] = {
 		.membase	= IO_ADDRESS(TEGRA_UARTA_BASE),
 		.mapbase	= TEGRA_UARTA_BASE,
 		.irq		= INT_UARTA,
-		.flags		= UPF_BOOT_AUTOCONF,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE,
+		.type		= PORT_TEGRA,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= 216000000,
-- 
1.7.0.4

