Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0G3Azk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:55:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59578 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0G3Azj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:55:39 -0400
Date: Fri, 30 Jul 2010 10:55:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tegra tree with the arm and s5p
 trees
Message-Id: <20100730105537.54f20666.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/Kconfig between various commits from the arm and s5p trees and
commits 2d2996d53fd5643816d8ab4fa07e2e76c38bdc0c ("[ARM] tegra: SMP
support") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 63daf56,1341628..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -1122,11 -1114,11 +1136,11 @@@ config SM
  	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
  	depends on EXPERIMENTAL && (REALVIEW_EB_ARM11MP || REALVIEW_EB_A9MP ||\
  		 MACH_REALVIEW_PB11MP || MACH_REALVIEW_PBX || ARCH_OMAP4 ||\
- 		 ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_S5PV310)
 -		 ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_TEGRA)
++		 ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_S5PV310 || ARCH_TEGRA)
  	depends on GENERIC_CLOCKEVENTS
  	select USE_GENERIC_SMP_HELPERS
- 	select HAVE_ARM_SCU if (ARCH_REALVIEW || ARCH_OMAP4 || ARCH_U8500 || ARCH_VEXPRESS_CA9X4 ||\
- 			ARCH_S5PV310)
+ 	select HAVE_ARM_SCU if (ARCH_REALVIEW || ARCH_OMAP4 || ARCH_U8500 || \
 -		 ARCH_VEXPRESS_CA9X4 || ARCH_TEGRA)
++		 ARCH_VEXPRESS_CA9X4 || ARCH_S5PV310 || ARCH_TEGRA)
  	help
  	  This enables support for systems with more than one CPU. If you have
  	  a system with only one CPU, like most personal computers, say N. If
@@@ -1196,9 -1188,10 +1210,9 @@@ config LOCAL_TIMER
  	bool "Use local timer interrupts"
  	depends on SMP && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || \
  		REALVIEW_EB_A9MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
- 		ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_S5PV310)
 -		ARCH_U8500 || ARCH_TEGRA)
++		ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_S5PV310 || ARCH_TEGRA)
  	default y
- 	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || ARCH_U8500 || ARCH_S5PV310)
 -	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_OMAP4 || ARCH_U8500 || \
 -		ARCH_TEGRA)
++	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || ARCH_U8500 || ARCH_S5PV310 || ARCH_TEGRA)
  	help
  	  Enable support for local timers on SMP platforms, rather then the
  	  legacy IPI broadcast method.  Local timers allows the system
