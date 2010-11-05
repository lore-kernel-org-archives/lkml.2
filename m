Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0KER0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:26:37 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58897 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab0KER0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:26:35 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 13:26:35 EDT
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>
Subject: [PATCH] TS-78xxx NAND resource type should be IORESOURCE_MEM
Date: Fri,  5 Nov 2010 13:14:40 -0400
Message-Id: <1288977280-5674-1-git-send-email-mspang@csclub.uwaterloo.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type was IORESOURCE_IO which is not what is expected by
plat_nand_probe(). This device has not worked since 2d098a72
("mtd: plat_nand: request memory resource before doing ioremap").

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
---
 arch/arm/mach-orion5x/ts78xx-setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index 16f1bd5..c1c1cd0 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -239,7 +239,7 @@ static struct platform_nand_data ts78xx_ts_nand_data = {
 static struct resource ts78xx_ts_nand_resources = {
 	.start		= TS_NAND_DATA,
 	.end		= TS_NAND_DATA + 4,
-	.flags		= IORESOURCE_IO,
+	.flags		= IORESOURCE_MEM,
 };
 
 static struct platform_device ts78xx_ts_nand_device = {
-- 
1.7.1

