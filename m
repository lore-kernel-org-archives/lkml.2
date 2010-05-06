Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0EFRiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0EFRiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:38:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/13] arm: removing redundant ifdefs
Date: Thu,  6 May 2010 19:36:07 +0200
Message-Id: <1273167377-14270-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/arm/include/asm/processor.h              |    2 --
 arch/arm/mach-ixp23xx/include/mach/platform.h |    3 ---
 arch/arm/plat-omap/include/plat/clock.h       |    5 -----
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 6a89567..7dcae33 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -22,11 +22,9 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
-#ifdef __KERNEL__
 #define STACK_TOP	((current->personality & ADDR_LIMIT_32BIT) ? \
 			 TASK_SIZE : TASK_SIZE_26)
 #define STACK_TOP_MAX	TASK_SIZE
-#endif
 
 union debug_insn {
 	u32	arm;
diff --git a/arch/arm/mach-ixp23xx/include/mach/platform.h b/arch/arm/mach-ixp23xx/include/mach/platform.h
index db9d941..9f05ea4 100644
--- a/arch/arm/mach-ixp23xx/include/mach/platform.h
+++ b/arch/arm/mach-ixp23xx/include/mach/platform.h
@@ -43,7 +43,6 @@ extern struct sys_timer ixp23xx_timer;
 
 #define IXP23XX_UART_XTAL		14745600
 
-#ifndef __ASSEMBLY__
 /*
  * Is system memory on the XSI or CPP bus?
  */
@@ -51,7 +50,5 @@ static inline unsigned ixp23xx_cpp_boot(void)
 {
 	return (*IXP23XX_EXP_CFG0 & IXP23XX_EXP_CFG0_XSI_NOT_PRES);
 }
-#endif
-
 
 #endif
diff --git a/arch/arm/plat-omap/include/plat/clock.h b/arch/arm/plat-omap/include/plat/clock.h
index 34f7fa9..b18bf6a 100644
--- a/arch/arm/plat-omap/include/plat/clock.h
+++ b/arch/arm/plat-omap/include/plat/clock.h
@@ -133,17 +133,12 @@ struct clk {
 	__s8			usecount;
 	u8			fixed_div;
 	u8			flags;
-#ifdef CONFIG_ARCH_OMAP2PLUS
 	void __iomem		*clksel_reg;
 	u32			clksel_mask;
 	const struct clksel	*clksel;
 	struct dpll_data	*dpll_data;
 	const char		*clkdm_name;
 	struct clockdomain	*clkdm;
-#else
-	__u8			rate_offset;
-	__u8			src_offset;
-#endif
 #if defined(CONFIG_PM_DEBUG) && defined(CONFIG_DEBUG_FS)
 	struct dentry		*dent;	/* For visible tree hierarchy */
 #endif
-- 
1.6.6.1

