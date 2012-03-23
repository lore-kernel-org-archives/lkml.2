Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab2CWRQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:16:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab2CWROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:08 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 3/9] ARM: omap2/n8x0: work around modular omap mmc
Date: Fri, 23 Mar 2012 11:13:50 -0600
Message-Id: <1332522836-29517-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <linux@arm.linux.org.uk>

When the omap driver is built as a module for n8x0,
n8x0_mmc_set_power_menelaus cannot call into the driver:

arch/arm/mach-omap2/board-n8x0.c:374: undefined reference
to `omap_mmc_notify_cover_event'

As a workaround, do not provide that device in this case. This needs
to be fixed properly, e.g. by converting n8x0 to be probed through the
device tree and moving that code into the driver.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Suggested-by: Russell King <linux@arm.linux.org.uk>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-n8x0.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 6722627..8529ca0 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -193,8 +193,10 @@ static struct omap_onenand_platform_data board_onenand_data[] = {
 };
 #endif
 
-#if defined(CONFIG_MENELAUS) &&						\
-	(defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE))
+#ifdef CONFIG_MMC_OMAP_MODULE
+#warning FIXME: cannot call omap_mmc_notify_cover_event for CONFIG_MMC_OMAP_MODULE
+#endif
+#if defined(CONFIG_MENELAUS) && (defined(CONFIG_MMC_OMAP)
 
 /*
  * On both N800 and N810, only the first of the two MMC controllers is in use.
-- 
1.7.5.4

