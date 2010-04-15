Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0DOBlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:41:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63388 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0DOBlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:41:21 -0400
From: Mike Chan <mike@android.com>
Cc: khilman@deeprootsystems.com, tony@atomide.com, paul@pwsan.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, Mike Chan <mike@android.com>
Subject: [PATCH 2/2] omap: pm34xx: Remove PER wakeup dependency on CORE.
Date: Wed, 14 Apr 2010 18:41:05 -0700
Message-Id: <1271295665-26187-2-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271295665-26187-1-git-send-email-mike@android.com>
References: <1271295665-26187-1-git-send-email-mike@android.com>
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove this wakeup dependency since now, when
GPIO2-6 are enabled for IO-pad wakeup, PER domain is gauranteed
to be awake or be woken up to service.

The previous dependency did not handle all corner cases. Since there
was no sleep dependency between CORE and PER domains, if PER enters
RET and CORE is ON, PER will not be active for GPIO handling.

Signed-off-by: Mike Chan <mike@android.com>
---
 arch/arm/mach-omap2/pm34xx.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 4ef322a..176870f 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -1086,14 +1086,6 @@ static int __init omap3_pm_init(void)
 	omap3_idle_init();
 
 	clkdm_add_wkdep(neon_clkdm, mpu_clkdm);
-	/*
-	 * REVISIT: This wkdep is only necessary when GPIO2-6 are enabled for
-	 * IO-pad wakeup.  Otherwise it will unnecessarily waste power
-	 * waking up PER with every CORE wakeup - see
-	 * http://marc.info/?l=linux-omap&m=121852150710062&w=2
-	*/
-	clkdm_add_wkdep(per_clkdm, core_clkdm);
-
 	if (omap_type() != OMAP2_DEVICE_TYPE_GP) {
 		omap3_secure_ram_storage =
 			kmalloc(0x803F, GFP_KERNEL);
-- 
1.7.0.1

