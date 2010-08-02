Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0HBQCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:02:33 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64511 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab0HBQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:02:29 -0400
Date: Mon, 2 Aug 2010 18:02:27 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Barry Song <barry.song@analog.com>,
        Sonic Zhang <sonic.zhang@analog.com>, Cliff Cai <cliff.cai@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 4/6] arch/blackfin: Remove dead CONFIG_REGULATOR_ADP_SWITCH
Message-ID: <6687666b92a0346df6ed876380aecc40e4f9f180.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REGULATOR_ADP_SWITCH doesn't exist in Kconfig, therefore removing all
references for it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/blackfin/mach-bf537/boards/stamp.c |  103 -------------------------------
 1 files changed, 0 insertions(+), 103 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 9eaf5b0..09c6b46 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -35,9 +35,6 @@
 #include <asm/reboot.h>
 #include <asm/portmux.h>
 #include <asm/dpmc.h>
-#ifdef CONFIG_REGULATOR_ADP_SWITCH
-#include <linux/regulator/adp_switch.h>
-#endif
 #ifdef CONFIG_REGULATOR_AD5398
 #include <linux/regulator/ad5398.h>
 #endif
@@ -2146,97 +2143,6 @@ static struct platform_device bfin_ac97 = {
 };
 #endif
 
-#if defined(CONFIG_REGULATOR_ADP_SWITCH) || defined(CONFIG_REGULATOR_ADP_SWITCH_MODULE)
-#define REGULATOR_ADP122        "adp122"
-#define REGULATOR_ADP150        "adp150"
-
-static struct regulator_consumer_supply adp122_consumers = {
-		.supply = REGULATOR_ADP122,
-};
-
-static struct regulator_consumer_supply adp150_consumers = {
-		.supply = REGULATOR_ADP150,
-};
-
-static struct regulator_init_data adp_switch_regulator_data[] = {
-	{
-		.constraints = {
-			.name = REGULATOR_ADP122,
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-			.min_uA = 0,
-			.max_uA = 300000,
-		},
-		.num_consumer_supplies = 1,	/* only 1 */
-		.consumer_supplies     = &adp122_consumers,
-		.driver_data	       = (void *)GPIO_PF2, /* gpio port only */
-	},
-	{
-		.constraints = {
-			.name = REGULATOR_ADP150,
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-			.min_uA = 0,
-			.max_uA = 150000,
-		},
-		.num_consumer_supplies = 1,	/* only 1 */
-		.consumer_supplies     = &adp150_consumers,
-		.driver_data	       = (void *)GPIO_PF3, /* gpio port only */
-	},
-};
-
-static struct adp_switch_platform_data adp_switch_pdata = {
-	.regulator_num = ARRAY_SIZE(adp_switch_regulator_data),
-	.regulator_data = adp_switch_regulator_data,
-};
-
-static struct platform_device adp_switch_device = {
-	.name = "adp_switch",
-	.id = 0,
-	.dev = {
-		.platform_data = &adp_switch_pdata,
-	},
-};
-
-#if defined(CONFIG_REGULATOR_USERSPACE_CONSUMER) || \
-	defined(CONFIG_REGULATOR_USERSPACE_CONSUMER_MODULE)
-static struct regulator_bulk_data adp122_bulk_data = {
-	.supply = REGULATOR_ADP122,
-};
-
-static struct regulator_userspace_consumer_data adp122_userspace_comsumer_data = {
-	.name = REGULATOR_ADP122,
-	.num_supplies = 1,
-	.supplies = &adp122_bulk_data,
-};
-
-static struct platform_device adp122_userspace_consumer_device = {
-	.name = "reg-userspace-consumer",
-	.id = 0,
-	.dev = {
-		.platform_data = &adp122_userspace_comsumer_data,
-	},
-};
-
-static struct regulator_bulk_data adp150_bulk_data = {
-	.supply = REGULATOR_ADP150,
-};
-
-static struct regulator_userspace_consumer_data adp150_userspace_comsumer_data = {
-	.name = REGULATOR_ADP150,
-	.num_supplies = 1,
-	.supplies = &adp150_bulk_data,
-};
-
-static struct platform_device adp150_userspace_consumer_device = {
-	.name = "reg-userspace-consumer",
-	.id = 1,
-	.dev = {
-		.platform_data = &adp150_userspace_comsumer_data,
-	},
-};
-#endif
-#endif
-
-
 static struct platform_device *stamp_devices[] __initdata = {
 
 	&bfin_dpmc,
@@ -2367,15 +2273,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&ad5398_userspace_consumer_device,
 #endif
 #endif
-
-#if defined(CONFIG_REGULATOR_ADP_SWITCH) || defined(CONFIG_REGULATOR_ADP_SWITCH_MODULE)
-	&adp_switch_device,
-#if defined(CONFIG_REGULATOR_USERSPACE_CONSUMER) || \
-	defined(CONFIG_REGULATOR_USERSPACE_CONSUMER_MODULE)
-	&adp122_userspace_consumer_device,
-	&adp150_userspace_consumer_device,
-#endif
-#endif
 };
 
 static int __init stamp_init(void)
-- 
1.7.0.4

