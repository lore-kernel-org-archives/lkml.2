Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1BSW0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 17:26:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26063 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1BSW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 17:26:27 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/21] ARM: tegra: clock: Remove unnecessary uses of #ifdef CONFIG_DEBUG_FS
Date: Sat, 19 Feb 2011 14:26:02 -0800
Message-Id: <1298154371-5641-15-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298154371-5641-1-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
To: linux-tegra@vger.kernel.org
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.c         |    6 ++----
 arch/arm/mach-tegra/clock.h         |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c |    4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index f6c934a..8d01a49 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -135,7 +135,7 @@ void clk_init(struct clk *c)
 
 	if (!c->ops || !c->ops->enable) {
 		c->refcnt++;
-		c->set = 1;
+		c->set = true;
 		if (c->parent)
 			c->state = c->parent->state;
 		else
@@ -169,9 +169,7 @@ int clk_enable(struct clk *c)
 				goto out;
 			}
 			c->state = ON;
-#ifdef CONFIG_DEBUG_FS
-			c->set = 1;
-#endif
+			c->set = true;
 		}
 	}
 	c->refcnt++;
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index bb755c2..ebe6ea8 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -80,8 +80,8 @@ struct clk {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dent;
-	bool			set;
 #endif
+	bool			set;
 	struct clk_ops		*ops;
 	unsigned long		rate;
 	unsigned long		max_rate;
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index dd53af3..196c249 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -1218,9 +1218,7 @@ static void tegra_clk_shared_bus_init(struct clk *c)
 	c->max_rate = c->parent->max_rate;
 	c->u.shared_bus_user.rate = c->parent->max_rate;
 	c->state = OFF;
-#ifdef CONFIG_DEBUG_FS
-	c->set = 1;
-#endif
+	c->set = true;
 
 	spin_lock_irqsave(&c->parent->spinlock, flags);
 
-- 
1.7.3.1

