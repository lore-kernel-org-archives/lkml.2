Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2IYACv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:02:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53204 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2IYACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:02:48 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] ARM: dove: Add pcie clock support
Date: Tue, 25 Sep 2012 02:02:13 +0200
Message-Id: <1348531338-16624-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As dove now has clock gating control ensure pcie ports grab their
clocks.

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
 arch/arm/mach-dove/pcie.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-dove/pcie.c b/arch/arm/mach-dove/pcie.c
index bb15b26..0ef4435 100644
--- a/arch/arm/mach-dove/pcie.c
+++ b/arch/arm/mach-dove/pcie.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/clk.h>
 #include <video/vga.h>
 #include <asm/mach/pci.h>
 #include <asm/mach/arch.h>
@@ -188,6 +189,10 @@ static void __init add_pcie_port(int index, void __iomem *base)
 
 	if (orion_pcie_link_up(base)) {
 		struct pcie_port *pp = &pcie_port[num_pcie_ports++];
+		struct clk *clk = clk_get_sys("pcie", (index ? "1" : "0"));
+
+		if (!IS_ERR(clk))
+			clk_prepare_enable(clk);
 
 		printk(KERN_INFO "link up\n");
 
-- 
1.7.10.4

