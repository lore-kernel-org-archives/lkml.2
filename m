Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2IMPmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:42:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48693 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2IMPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:42:32 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 09/10] arm: mvebu: split Kconfig options for Armada 370 and XP
Date: Thu, 13 Sep 2012 17:41:51 +0200
Message-Id: <1347550912-18021-10-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Until now, all the code for Armada 370 and XP was common, so we had a
single Kconfig option to support all boards using both SoCs. With the
addition of pinctrl drivers, this situation has changed: those two
SoCs are radically different in terms of pinctrl, so they have two
separate drivers. Since pinctrl drivers are typically select-ed from
the SoC Kconfig option, it makes sense to split the 370/XP option into
two separate options: one for Armada 370 and another for Armada XP.

We keep an hidden option selected by both ARMADA_370 and ARMADA_XP in
order to easily compile common code.

A followup patch actually makes use of this split to select the
appropriate pinctrl drivers.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Gregory Clement <gregory.clement@free-electrons.com>
---
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-mvebu/Kconfig |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index caa2c5e..5540a8b 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -3,13 +3,23 @@ if ARCH_MVEBU
 menu "Marvell SOC with device tree"
 
 config MACH_ARMADA_370_XP
-	bool "Marvell Armada 370 and Aramada XP boards"
+	bool
 	select ARMADA_370_XP_TIMER
 	select CPU_V7
+
+config MACH_ARMADA_370
+	bool "Marvell Armada 370 boards"
+	select MACH_ARMADA_370_XP
 	help
+	  Say 'Y' here if you want your kernel to support boards based
+	  on the Marvell Armada 370 SoC with device tree.
 
-	  Say 'Y' here if you want your kernel to support boards based on
-	  Marvell Armada 370 or Armada XP with device tree.
+config MACH_ARMADA_XP
+	bool "Marvell Armada XP boards"
+	select MACH_ARMADA_370_XP
+	help
+	  Say 'Y' here if you want your kernel to support boards based
+	  on the Marvell Armada XP SoC with device tree.
 
 endmenu
 
-- 
1.7.10.4

