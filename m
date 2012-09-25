Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2IYADP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:03:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48393 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2IYADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:03:03 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] ARM: dove: Add crypto engine to DT
Date: Tue, 25 Sep 2012 02:02:18 +0200
Message-Id: <1348531338-16624-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of DT support for the crypto engine on dove and remove
the obsolete init call.

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
 arch/arm/boot/dts/dove.dtsi |    9 +++++++++
 arch/arm/mach-dove/common.c |    1 -
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index c59c529..5a00022 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -145,5 +145,14 @@
 			nr-ports = <1>;
 			status = "disabled";
 		};
+
+		crypto: crypto@30000 {
+			compatible = "marvell,orion-crypto";
+			reg = <0x30000 0x10000>,
+			      <0xc8000000 0x800>;
+			reg-names = "regs", "sram";
+			interrupts = <31>;
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index ffec26f..f723fe1 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -416,7 +416,6 @@ static void __init dove_dt_init(void)
 	dove_ehci0_init();
 	dove_ehci1_init();
 	dove_pcie_init(1, 1);
-	dove_crypto_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table,
 			     dove_auxdata_lookup, NULL);
-- 
1.7.10.4

