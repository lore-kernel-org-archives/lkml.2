Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823Ab0GWUBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:01:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43161 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab0GWT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:59:11 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, janboe <janboe.ye@gmail.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] ARM: omap: move omapfb_reserve_sram() to .init.text
Date: Fri, 23 Jul 2010 21:58:30 +0200
Message-Id: <1279915120-4373-7-git-send-email-u.kleine-koenig@pengutronix.de>
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

omapfb_reserve_sram() is only called by omap_detect_sram() which lives in
.init.text.  So this is save for omapfb_reserve_sram(), too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/plat-omap/fb.c   |    6 +++---
 arch/arm/plat-omap/sram.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 4df210f..4c0ae4d 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -233,7 +233,7 @@ void __init omapfb_reserve_sdram(void)
  * this point, since the driver built as a module would have problem with
  * freeing / reallocating the regions.
  */
-unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+unsigned long __init omapfb_reserve_sram(unsigned long sram_pstart,
 				  unsigned long sram_vstart,
 				  unsigned long sram_size,
 				  unsigned long pstart_avail,
@@ -360,7 +360,7 @@ static int __init omap_init_fb(void)
 arch_initcall(omap_init_fb);
 
 void __init omapfb_reserve_sdram(void) {}
-unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+unsigned long __init omapfb_reserve_sram(unsigned long sram_pstart,
 				  unsigned long sram_vstart,
 				  unsigned long sram_size,
 				  unsigned long start_avail,
@@ -376,7 +376,7 @@ void omapfb_set_platform_data(struct omapfb_platform_data *data)
 }
 
 void __init omapfb_reserve_sdram(void) {}
-unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+unsigned long __init omapfb_reserve_sram(unsigned long sram_pstart,
 				  unsigned long sram_vstart,
 				  unsigned long sram_size,
 				  unsigned long start_avail,
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index 226b2e8..ccd6623 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -79,7 +79,7 @@ static unsigned long omap_sram_base;
 static unsigned long omap_sram_size;
 static unsigned long omap_sram_ceil;
 
-extern unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+extern unsigned long __init omapfb_reserve_sram(unsigned long sram_pstart,
 					 unsigned long sram_vstart,
 					 unsigned long sram_size,
 					 unsigned long pstart_avail,
-- 
1.7.1

