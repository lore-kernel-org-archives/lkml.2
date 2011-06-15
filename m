Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1FOVMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:12:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40017 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1FOVMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:12:38 -0400
From: Ambresh K <ambresh@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP4: DMTIMER: enable autoidle mode
Date: Wed, 15 Jun 2011 14:12:35 -0700
Message-ID: <1308172355-1694-1-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

Currently autoidle is only enabled for OMAP2/3; by enabling autoidle,
the automatic L4 clock gating strategy is applied based on L4 activity,
otherwise L4 clock to module will be a free running.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 arch/arm/plat-omap/dmtimer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index ee9f6eb..02d0f7a 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -342,8 +342,8 @@ static void omap_dm_timer_reset(struct omap_dm_timer *timer)
 	l |= 0x02 << 3;  /* Set to smart-idle mode */
 	l |= 0x2 << 8;   /* Set clock activity to perserve f-clock on idle */
 
-	/* Enable autoidle on OMAP2 / OMAP3 */
-	if (cpu_is_omap24xx() || cpu_is_omap34xx())
+	/* Enable autoidle on OMAP2 CPUs. */
+	if (cpu_class_is_omap2())
 		l |= 0x1 << 0;
 
 	/*
-- 
1.6.0

