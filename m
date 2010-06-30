Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0F3P7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:59:30 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39866 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801Ab0F3P72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:59:28 -0400
Date: Wed, 30 Jun 2010 17:59:25 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Kalle Valo <kalle.valo@iki.fi>, Ladislav Michl <ladis@linux-mips.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 17/33] Removing dead SX1_OLD_FLASH
Message-ID: <5b21086199b139a61888c16e92d3efe6b205dae2.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SX1_OLD_FLASH doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/board-sx1.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 2fb1e5f..1de809d 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -295,31 +295,6 @@ static struct physmap_flash_data sx1_flash_data = {
 	.nr_parts	= ARRAY_SIZE(sx1_partitions),
 };
 
-#ifdef CONFIG_SX1_OLD_FLASH
-/* MTD Intel StrataFlash - old flashes */
-static struct resource sx1_old_flash_resource[] = {
-	[0] = {
-		.start	= OMAP_CS0_PHYS,	/* Physical */
-		.end	= OMAP_CS0_PHYS + SZ_16M - 1,,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= OMAP_CS1_PHYS,
-		.end	= OMAP_CS1_PHYS + SZ_8M - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device sx1_flash_device = {
-	.name		= "physmap-flash",
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &sx1_flash_data,
-	},
-	.num_resources	= 2,
-	.resource	= &sx1_old_flash_resource,
-};
-#else
 /* MTD Intel 4000 flash - new flashes */
 static struct resource sx1_new_flash_resource = {
 	.start		= OMAP_CS0_PHYS,
@@ -336,7 +311,6 @@ static struct platform_device sx1_flash_device = {
 	.num_resources	= 1,
 	.resource	= &sx1_new_flash_resource,
 };
-#endif
 
 /*----------- USB -------------------------*/
 
-- 
1.7.0.4

