Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2KYURr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 15:17:47 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:57958 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab2KYURp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 15:17:45 -0500
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.hauer@pengutronix.de, julien.boibessot@armadeus.com,
        eric.jarrige@armadeus.org, Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH 3/4] imx27-dt: configure i2c1 gpio on armadeus apf27
Date: Sun, 25 Nov 2012 21:17:04 +0100
Message-Id: <1353874625-14754-4-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
References: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---
 arch/arm/mach-imx/imx27-dt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/imx27-dt.c b/arch/arm/mach-imx/imx27-dt.c
index f212f81..2eb7014 100644
--- a/arch/arm/mach-imx/imx27-dt.c
+++ b/arch/arm/mach-imx/imx27-dt.c
@@ -17,6 +17,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 #include <mach/common.h>
+#include <mach/iomux-mx27.h>
 #include <mach/mx27.h>
 
 static const struct of_dev_auxdata imx27_auxdata_lookup[] __initconst = {
@@ -48,6 +49,10 @@ int apf27_lan8700_wakeup(struct phy_device *phydev)
 static void __init apf27_init(void)
 {
 	phy_register_fixup_for_id("imx27-fec.0-1:1f", apf27_lan8700_wakeup);
+
+	/* configure i2c1 gpio */
+	mxc_gpio_mode((GPIO_PORTD | GPIO_OUT | GPIO_PF | 17));
+	mxc_gpio_mode((GPIO_PORTD | GPIO_OUT | GPIO_PF | 18));
 }
 
 static void __init imx27_dt_init(void)
-- 
1.7.4.4

