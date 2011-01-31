Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1AaCOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:14:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59856 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab1AaCOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:14:05 -0500
Date: Mon, 31 Jan 2011 13:14:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: linux-next: manual merge of the msm tree with the arm tree
Message-Id: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the msm tree got conflicts in
arch/arm/mach-msm/board-msm7x27.c, arch/arm/mach-msm/board-msm7x30.c,
arch/arm/mach-msm/board-qsd8x50.c and arch/arm/mach-msm/board-sapphire.c
between commit eda53d6d032effb653410b79e1b49e652a881744 ("ARM: P2V: avoid
initializers and assembly using PHYS_OFFSET") from the arm tree and
commit 07a3cc4814f790354d4c7be2c9dc6143a714a07a ("msm: Clean up useless
ifdefs") from the msm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/board-msm7x27.c
index 08fcd40,16d7580..0000000
--- a/arch/arm/mach-msm/board-msm7x27.c
+++ b/arch/arm/mach-msm/board-msm7x27.c
@@@ -130,9 -130,7 +130,7 @@@ static void __init msm7x2x_map_io(void
  }
  
  MACHINE_START(MSM7X27_SURF, "QCT MSM7x27 SURF")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params	= PHYS_OFFSET + 0x100,
 +	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
  	.map_io		= msm7x2x_map_io,
  	.init_irq	= msm7x2x_init_irq,
  	.init_machine	= msm7x2x_init,
@@@ -140,9 -138,7 +138,7 @@@
  MACHINE_END
  
  MACHINE_START(MSM7X27_FFA, "QCT MSM7x27 FFA")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params	= PHYS_OFFSET + 0x100,
 +	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
  	.map_io		= msm7x2x_map_io,
  	.init_irq	= msm7x2x_init_irq,
  	.init_machine	= msm7x2x_init,
@@@ -150,9 -146,7 +146,7 @@@
  MACHINE_END
  
  MACHINE_START(MSM7X25_SURF, "QCT MSM7x25 SURF")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params	= PHYS_OFFSET + 0x100,
 +	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
  	.map_io		= msm7x2x_map_io,
  	.init_irq	= msm7x2x_init_irq,
  	.init_machine	= msm7x2x_init,
@@@ -160,9 -154,7 +154,7 @@@
  MACHINE_END
  
  MACHINE_START(MSM7X25_FFA, "QCT MSM7x25 FFA")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params	= PHYS_OFFSET + 0x100,
 +	.boot_params	= PLAT_PHYS_OFFSET + 0x100,
  	.map_io		= msm7x2x_map_io,
  	.init_irq	= msm7x2x_init_irq,
  	.init_machine	= msm7x2x_init,
diff --cc arch/arm/mach-msm/board-msm7x30.c
index 25db8fd,dc9fac1..0000000
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@@ -83,9 -105,7 +105,7 @@@ static void __init msm7x30_map_io(void
  }
  
  MACHINE_START(MSM7X30_SURF, "QCT MSM7X30 SURF")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params = PHYS_OFFSET + 0x100,
 +	.boot_params = PLAT_PHYS_OFFSET + 0x100,
  	.map_io = msm7x30_map_io,
  	.init_irq = msm7x30_init_irq,
  	.init_machine = msm7x30_init,
@@@ -93,9 -113,7 +113,7 @@@
  MACHINE_END
  
  MACHINE_START(MSM7X30_FFA, "QCT MSM7X30 FFA")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params = PHYS_OFFSET + 0x100,
 +	.boot_params = PLAT_PHYS_OFFSET + 0x100,
  	.map_io = msm7x30_map_io,
  	.init_irq = msm7x30_init_irq,
  	.init_machine = msm7x30_init,
@@@ -103,9 -121,7 +121,7 @@@
  MACHINE_END
  
  MACHINE_START(MSM7X30_FLUID, "QCT MSM7X30 FLUID")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params = PHYS_OFFSET + 0x100,
 +	.boot_params = PLAT_PHYS_OFFSET + 0x100,
  	.map_io = msm7x30_map_io,
  	.init_irq = msm7x30_init_irq,
  	.init_machine = msm7x30_init,
diff --cc arch/arm/mach-msm/board-qsd8x50.c
index 15c2bbd,b464d48..0000000
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@@ -116,9 -195,7 +195,7 @@@ static void __init qsd8x50_init(void
  }
  
  MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params = PHYS_OFFSET + 0x100,
 +	.boot_params = PLAT_PHYS_OFFSET + 0x100,
  	.map_io = qsd8x50_map_io,
  	.init_irq = qsd8x50_init_irq,
  	.init_machine = qsd8x50_init,
@@@ -126,9 -203,7 +203,7 @@@
  MACHINE_END
  
  MACHINE_START(QSD8X50A_ST1_5, "QCT QSD8X50A ST1.5")
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params = PHYS_OFFSET + 0x100,
 +	.boot_params = PLAT_PHYS_OFFSET + 0x100,
  	.map_io = qsd8x50_map_io,
  	.init_irq = qsd8x50_init_irq,
  	.init_machine = qsd8x50_init,
diff --cc arch/arm/mach-msm/board-sapphire.c
index 83604f5,6781ca8..0000000
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@@ -105,9 -105,7 +105,7 @@@ static void __init sapphire_map_io(void
  
  MACHINE_START(SAPPHIRE, "sapphire")
  /* Maintainer: Brian Swetland <swetland@google.com> */
- #ifdef CONFIG_MSM_DEBUG_UART
- #endif
 -	.boot_params    = PHYS_OFFSET + 0x100,
 +	.boot_params    = PLAT_PHYS_OFFSET + 0x100,
  	.fixup          = sapphire_fixup,
  	.map_io         = sapphire_map_io,
  	.init_irq       = sapphire_init_irq,
