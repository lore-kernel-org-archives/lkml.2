Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897Ab1JGIu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:50:28 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:47738 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab1JGIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:50:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAJe8jk5bdWOb/2dsb2JhbABEhHSkS4FUAQUjBAsBIyMQJQImAgI5AxsGE4gApj+RZYEthHGBFASTb4hfiGo
X-IronPort-AV: E=Sophos;i="4.68,501,1312149600"; 
   d="scan'208";a="421780801"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, "Timo Teras" <timo.teras@solidboot.com>
Subject: [PATCH v3] omap: dmtimer: convert printk to pr_err
Date: Fri,  7 Oct 2011 10:50:16 +0200
Message-Id: <1317977417-17874-1-git-send-email-vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <20111006201827.GT6324@atomide.com>
References: <20111006201827.GT6324@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a printk(KERN_ERR) message in the driver to pr_err().

v2:
* Replaced dump_stack() with WARN()

v3:
* Rebased against omap/master

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 arch/arm/plat-omap/dmtimer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index de7896f..5492ae1 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -111,7 +111,7 @@ static void omap_dm_timer_wait_for_reset(struct omap_dm_timer *timer)
 	while (!(__raw_readl(timer->sys_stat) & 1)) {
 		c++;
 		if (c > 100000) {
-			printk(KERN_ERR "Timer failed to reset\n");
+			pr_err("Timer failed to reset\n");
 			return;
 		}
 	}
-- 
1.7.6.3

