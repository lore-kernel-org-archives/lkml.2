Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2IYACz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:02:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48393 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2IYACx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:02:53 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] ARM: dove: Fix tauros2 device tree init
Date: Tue, 25 Sep 2012 02:02:14 +0200
Message-Id: <1348531338-16624-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the review process of dove DT patches, Tauros2 cache
init call was changed and DT support added. This patch fixes
the call to Tauros2 init and adds a DT node. Moreover, plat/irq.h
include was missing from mach-dove/common.c.
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |    5 +++++
 arch/arm/mach-dove/common.c |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 96fb824..3f41f50 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -20,6 +20,11 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 
+		l2: l2-cache {
+			compatible = "marvell,tauros2-cache";
+			marvell,tauros2-cache-features = <0>;
+		};
+
 		uart0: serial@12000 {
 			compatible = "ns16550a";
 			reg = <0x12000 0x100>;
diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index b37bef1..343a4bc 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -32,6 +32,7 @@
 #include <linux/irq.h>
 #include <plat/time.h>
 #include <linux/platform_data/usb-ehci-orion.h>
+#include <plat/irq.h>
 #include <plat/common.h>
 #include <plat/addr-map.h>
 #include "common.h"
@@ -399,7 +400,7 @@ static void __init dove_dt_init(void)
 		(dove_tclk + 499999) / 1000000);
 
 #ifdef CONFIG_CACHE_TAUROS2
-	tauros2_init();
+	tauros2_init(0);
 #endif
 	dove_setup_cpu_mbus();
 
-- 
1.7.10.4

