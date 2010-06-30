Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0F3P7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:59:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39839 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801Ab0F3P7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:59:08 -0400
Date: Wed, 30 Jun 2010 17:59:06 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Kalle Valo <kalle.valo@iki.fi>, Ladislav Michl <ladis@linux-mips.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 16/33] Removing dead APM
Message-ID: <51c095a4c49baacbfdd6ed332d1375ab64209753.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APM doesn't exist in Kconfig, therefore removing all references for it
from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/board-palmte.c |   84 ------------------------------------
 1 files changed, 0 insertions(+), 84 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 569b4c9..23bb0c9 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -213,90 +213,6 @@ static struct omap_lcd_config palmte_lcd_config __initdata = {
 	.ctrl_name	= "internal",
 };
 
-#ifdef CONFIG_APM
-/*
- * Values measured in 10 minute intervals averaged over 10 samples.
- * May differ slightly from device to device but should be accurate
- * enough to give basic idea of battery life left and trigger
- * potential alerts.
- */
-static const int palmte_battery_sample[] = {
-	2194, 2157, 2138, 2120,
-	2104, 2089, 2075, 2061,
-	2048, 2038, 2026, 2016,
-	2008, 1998, 1989, 1980,
-	1970, 1958, 1945, 1928,
-	1910, 1888, 1860, 1827,
-	1791, 1751, 1709, 1656,
-};
-
-#define INTERVAL		10
-#define BATTERY_HIGH_TRESHOLD	66
-#define BATTERY_LOW_TRESHOLD	33
-
-static void palmte_get_power_status(struct apm_power_info *info, int *battery)
-{
-	int charging, batt, hi, lo, mid;
-
-	charging = !gpio_get_value(PALMTE_DC_GPIO);
-	batt = battery[0];
-	if (charging)
-		batt -= 60;
-
-	hi = ARRAY_SIZE(palmte_battery_sample);
-	lo = 0;
-
-	info->battery_flag = 0;
-	info->units = APM_UNITS_MINS;
-
-	if (batt > palmte_battery_sample[lo]) {
-		info->battery_life = 100;
-		info->time = INTERVAL * ARRAY_SIZE(palmte_battery_sample);
-	} else if (batt <= palmte_battery_sample[hi - 1]) {
-		info->battery_life = 0;
-		info->time = 0;
-	} else {
-		while (hi > lo + 1) {
-			mid = (hi + lo) >> 1;
-			if (batt <= palmte_battery_sample[mid])
-				lo = mid;
-			else
-				hi = mid;
-		}
-
-		mid = palmte_battery_sample[lo] - palmte_battery_sample[hi];
-		hi = palmte_battery_sample[lo] - batt;
-		info->battery_life = 100 - (100 * lo + 100 * hi / mid) /
-			ARRAY_SIZE(palmte_battery_sample);
-		info->time = INTERVAL * (ARRAY_SIZE(palmte_battery_sample) -
-				lo) - INTERVAL * hi / mid;
-	}
-
-	if (charging) {
-		info->ac_line_status = APM_AC_ONLINE;
-		info->battery_status = APM_BATTERY_STATUS_CHARGING;
-		info->battery_flag |= APM_BATTERY_FLAG_CHARGING;
-	} else {
-		info->ac_line_status = APM_AC_OFFLINE;
-		if (info->battery_life > BATTERY_HIGH_TRESHOLD)
-			info->battery_status = APM_BATTERY_STATUS_HIGH;
-		else if (info->battery_life > BATTERY_LOW_TRESHOLD)
-			info->battery_status = APM_BATTERY_STATUS_LOW;
-		else
-			info->battery_status = APM_BATTERY_STATUS_CRITICAL;
-	}
-
-	if (info->battery_life > BATTERY_HIGH_TRESHOLD)
-		info->battery_flag |= APM_BATTERY_FLAG_HIGH;
-	else if (info->battery_life > BATTERY_LOW_TRESHOLD)
-		info->battery_flag |= APM_BATTERY_FLAG_LOW;
-	else
-		info->battery_flag |= APM_BATTERY_FLAG_CRITICAL;
-}
-#else
-#define palmte_get_power_status	NULL
-#endif
-
 static struct omap_board_config_kernel palmte_config[] __initdata = {
 	{ OMAP_TAG_LCD,		&palmte_lcd_config },
 };
-- 
1.7.0.4

