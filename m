Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0F3QEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:04:23 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40217 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804Ab0F3QEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:04:20 -0400
Date: Wed, 30 Jun 2010 18:04:18 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Linus Walleij <linus.walleij@stericsson.com>,
       Russell King <linux@arm.linux.org.uk>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 33/33] Removing dead MACH_U300_USE_I2S_AS_MASTER
Message-ID: <41be9a8afe8951b4ad23d43fcb57aca9a662cf43.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MACH_U300_USE_I2S_AS_MASTER doesn't exist in Kconfig, therefore
removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-u300/clock.c |   91 --------------------------------------------
 1 files changed, 0 insertions(+), 91 deletions(-)

diff --git a/arch/arm/mach-u300/clock.c b/arch/arm/mach-u300/clock.c
index 5af71d5..80972a0 100644
--- a/arch/arm/mach-u300/clock.c
+++ b/arch/arm/mach-u300/clock.c
@@ -216,85 +216,6 @@ static u16 syscon_clk_get_rate(void)
 	return val;
 }
 
-#ifdef CONFIG_MACH_U300_USE_I2S_AS_MASTER
-static void enable_i2s0_vcxo(void)
-{
-	u16 val;
-	unsigned long iflags;
-
-	spin_lock_irqsave(&syscon_clkreg_lock, iflags);
-	/* Set I2S0 to use the VCXO 26 MHz clock */
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val |= U300_SYSCON_CCR_TURN_VCXO_ON;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val |= U300_SYSCON_CCR_I2S0_USE_VCXO;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	val |= U300_SYSCON_CEFR_I2S0_CLK_EN;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	spin_unlock_irqrestore(&syscon_clkreg_lock, iflags);
-}
-
-static void enable_i2s1_vcxo(void)
-{
-	u16 val;
-	unsigned long iflags;
-
-	spin_lock_irqsave(&syscon_clkreg_lock, iflags);
-	/* Set I2S1 to use the VCXO 26 MHz clock */
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val |= U300_SYSCON_CCR_TURN_VCXO_ON;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val |= U300_SYSCON_CCR_I2S1_USE_VCXO;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	val |= U300_SYSCON_CEFR_I2S1_CLK_EN;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	spin_unlock_irqrestore(&syscon_clkreg_lock, iflags);
-}
-
-static void disable_i2s0_vcxo(void)
-{
-	u16 val;
-	unsigned long iflags;
-
-	spin_lock_irqsave(&syscon_clkreg_lock, iflags);
-	/* Disable I2S0 use of the VCXO 26 MHz clock */
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val &= ~U300_SYSCON_CCR_I2S0_USE_VCXO;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	/* Deactivate VCXO if noone else is using VCXO */
-	if (!(val & U300_SYSCON_CCR_I2S1_USE_VCXO))
-		val &= ~U300_SYSCON_CCR_TURN_VCXO_ON;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	val &= ~U300_SYSCON_CEFR_I2S0_CLK_EN;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	spin_unlock_irqrestore(&syscon_clkreg_lock, iflags);
-}
-
-static void disable_i2s1_vcxo(void)
-{
-	u16 val;
-	unsigned long iflags;
-
-	spin_lock_irqsave(&syscon_clkreg_lock, iflags);
-	/* Disable I2S1 use of the VCXO 26 MHz clock */
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val &= ~U300_SYSCON_CCR_I2S1_USE_VCXO;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	/* Deactivate VCXO if noone else is using VCXO */
-	if (!(val & U300_SYSCON_CCR_I2S0_USE_VCXO))
-		val &= ~U300_SYSCON_CCR_TURN_VCXO_ON;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CCR);
-	val = readw(U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	val &= ~U300_SYSCON_CEFR_I2S0_CLK_EN;
-	writew(val, U300_SYSCON_VBASE + U300_SYSCON_CEFR);
-	spin_unlock_irqrestore(&syscon_clkreg_lock, iflags);
-}
-#endif /* CONFIG_MACH_U300_USE_I2S_AS_MASTER */
-
-
 static void syscon_clk_rate_set_mclk(unsigned long rate)
 {
 	u16 val;
@@ -383,12 +304,6 @@ void clk_disable(struct clk *clk)
 		if (likely((u32)clk->parent))
 			clk_disable(clk->parent);
 	}
-#ifdef CONFIG_MACH_U300_USE_I2S_AS_MASTER
-	if (unlikely(!strcmp(clk->name, "I2S0")))
-		disable_i2s0_vcxo();
-	if (unlikely(!strcmp(clk->name, "I2S1")))
-		disable_i2s1_vcxo();
-#endif
 	spin_unlock_irqrestore(&clk->lock, iflags);
 }
 EXPORT_SYMBOL(clk_disable);
@@ -411,12 +326,6 @@ int clk_enable(struct clk *clk)
 			/* clocks without enable function are always on */
 			if (clk->enable)
 				clk->enable(clk);
-#ifdef CONFIG_MACH_U300_USE_I2S_AS_MASTER
-			if (unlikely(!strcmp(clk->name, "I2S0")))
-				enable_i2s0_vcxo();
-			if (unlikely(!strcmp(clk->name, "I2S1")))
-				enable_i2s1_vcxo();
-#endif
 		}
 	}
 	spin_unlock_irqrestore(&clk->lock, iflags);
-- 
1.7.0.4

