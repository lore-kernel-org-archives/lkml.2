Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab0G3As1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:48:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50307 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab0G3AsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:48:25 -0400
Date: Fri, 30 Jul 2010 10:48:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changhwan Youn <chaos.youn@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20100730104821.c5264ac3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/Kconfig between commits c9c6fe5033191d82e1d819105485c795062107fd
("ARM: Remove support for LinkUp Systems L7200 SDP") and
bde28b846e7e0ea6fea78f6ad1c43091fdf4d3e0  ("ARM: 6218/1: Versatile
Express: add support for local timers on CA9X4 daughterboard") from the
arm tree and commit 9d2ef2d3944bb387df220fdeec93abc38b62b627 ("ARM:
S5PV310: Add new Kconfig and Makefiles") from the s5p tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index e39caa8,c797a8b..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -1171,9 -1198,9 +1196,9 @@@ config LOCAL_TIMER
  	bool "Use local timer interrupts"
  	depends on SMP && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || \
  		REALVIEW_EB_A9MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
- 		ARCH_U8500 || ARCH_VEXPRESS_CA9X4)
 -		ARCH_U8500 || ARCH_S5PV310)
++		ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_S5PV310)
  	default y
- 	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || ARCH_U8500)
 -	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_OMAP4 || ARCH_U8500 || ARCH_S5PV310)
++	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || ARCH_U8500 || ARCH_S5PV310)
  	help
  	  Enable support for local timers on SMP platforms, rather then the
  	  legacy IPI broadcast method.  Local timers allows the system
@@@ -1184,10 -1211,11 +1209,11 @@@ source kernel/Kconfig.preemp
  
  config HZ
  	int
- 	default 200 if ARCH_EBSA110 || ARCH_S3C2410 || ARCH_S5P6440 || ARCH_S5P6442 || ARCH_S5PV210
 -	default 128 if ARCH_L7200
+ 	default 200 if ARCH_EBSA110 || ARCH_S3C2410 || ARCH_S5P6440 || ARCH_S5P6442 || \
+ 		       ARCH_S5PV210 || ARCH_S5PV310
  	default OMAP_32K_TIMER_HZ if ARCH_OMAP && OMAP_32K_TIMER
  	default AT91_TIMER_HZ if ARCH_AT91
 +	default SHMOBILE_TIMER_HZ if ARCH_SHMOBILE
  	default 100
  
  config THUMB2_KERNEL
