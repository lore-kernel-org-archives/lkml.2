Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab1JFK6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:58:21 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:38233 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1JFK6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:58:19 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 06:58:19 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EABKGjU5bdWOb/2dsb2JhbABEhHSkP4F9DwEjIzUCJgI7AzSIAKUikVWBLYRrgRQEk26IX4hp
X-IronPort-AV: E=Sophos;i="4.68,495,1312149600"; 
   d="scan'208";a="818801128"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Timo Teras" <timo.teras@solidboot.com>,
        "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: [PATCH] omap: dmtimer: convert printk to pr_*
Date: Thu,  6 Oct 2011 12:48:23 +0200
Message-Id: <1317898106-1891-1-git-send-email-vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all the printk(<level>) messages in the driver to pr_<level>().

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 arch/arm/plat-omap/dmtimer.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index ee9f6eb..34384b0 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -322,7 +322,7 @@ static void omap_dm_timer_wait_for_reset(struct omap_dm_timer *timer)
 	while (!(omap_dm_timer_read_reg(timer, OMAP_TIMER_SYS_STAT_REG) & 1)) {
 		c++;
 		if (c > 100000) {
-			printk(KERN_ERR "Timer failed to reset\n");
+			pr_err("Timer failed to reset\n");
 			return;
 		}
 	}
@@ -397,8 +397,7 @@ struct omap_dm_timer *omap_dm_timer_request_specific(int id)
 	spin_lock_irqsave(&dm_timer_lock, flags);
 	if (id <= 0 || id > dm_timer_count || dm_timers[id-1].reserved) {
 		spin_unlock_irqrestore(&dm_timer_lock, flags);
-		printk("BUG: warning at %s:%d/%s(): unable to get timer %d\n",
-		       __FILE__, __LINE__, __func__, id);
+		pr_warning("unable to get timer %d\n", id);
 		dump_stack();
 		return NULL;
 	}
-- 
1.7.6.3

