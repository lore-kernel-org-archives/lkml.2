Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835Ab0GWT7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:59:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43147 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0GWT7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:59:08 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] ARM: omap: move get_fbmem_region() to .init.text
Date: Fri, 23 Jul 2010 21:58:31 +0200
Message-Id: <1279915120-4373-8-git-send-email-u.kleine-koenig@pengutronix.de>
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

get_fbmem_region() is only called by omapfb_reserve_sdram() and
omapfb_reserve_sram() that both live in .init.text.  So get_fbmem_region
can go there, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/plat-omap/fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 4c0ae4d..e05e320 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -94,7 +94,7 @@ static int fbmem_region_reserved(unsigned long start, size_t size)
  * Get the region_idx`th region from board config/ATAG and convert it to
  * our internal format.
  */
-static int get_fbmem_region(int region_idx, struct omapfb_mem_region *rg)
+static int __init get_fbmem_region(int region_idx, struct omapfb_mem_region *rg)
 {
 	const struct omap_fbmem_config	*conf;
 	u32				paddr;
-- 
1.7.1

