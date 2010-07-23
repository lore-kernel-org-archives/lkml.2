Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859Ab0GWUBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:01:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43153 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab0GWT7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:59:09 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] ARM: omap: move omapfb_reserve_sdram() to .init.text
Date: Fri, 23 Jul 2010 21:58:29 +0200
Message-Id: <1279915120-4373-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omapfb_reserve_sdram() is only called by omap1_map_common_io() and
_omap2_map_common_io() that both live in .init.text.  So this is save
for omapfb_reserve_sdram(), too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/plat-omap/fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index e8a390d..4df210f 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -359,7 +359,7 @@ static int __init omap_init_fb(void)
 
 arch_initcall(omap_init_fb);
 
-void omapfb_reserve_sdram(void) {}
+void __init omapfb_reserve_sdram(void) {}
 unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
 				  unsigned long sram_vstart,
 				  unsigned long sram_size,
@@ -375,7 +375,7 @@ void omapfb_set_platform_data(struct omapfb_platform_data *data)
 {
 }
 
-void omapfb_reserve_sdram(void) {}
+void __init omapfb_reserve_sdram(void) {}
 unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
 				  unsigned long sram_vstart,
 				  unsigned long sram_size,
-- 
1.7.1

