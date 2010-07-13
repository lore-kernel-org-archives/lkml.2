Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0GMBXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:23:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35292 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0GMBXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:23:16 -0400
Date: Tue, 13 Jul 2010 11:23:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tegra tree with the arm tree
Message-Id: <20100713112314.2d468a71.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/Kconfig between commit bde28b846e7e0ea6fea78f6ad1c43091fdf4d3e0
("ARM: 6218/1: Versatile Express: add support for local timers on CA9X4
daughterboard") from the arm tree and commit
c9dfc86214ffc3bcd0155b38bfe04383accc054a ("[ARM] tegra: SMP support")
from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 7e73d07,c8f28f8..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -1155,9 -1187,10 +1170,10 @@@ config LOCAL_TIMER
  	bool "Use local timer interrupts"
  	depends on SMP && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || \
  		REALVIEW_EB_A9MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
- 		ARCH_U8500 || ARCH_VEXPRESS_CA9X4)
 -		ARCH_U8500 || ARCH_TEGRA)
++		ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_TEGRA)
  	default y
- 	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || ARCH_U8500)
 -	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_OMAP4 || ARCH_U8500 || \
++	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || ARCH_U8500 || \
+ 		ARCH_TEGRA)
  	help
  	  Enable support for local timers on SMP platforms, rather then the
  	  legacy IPI broadcast method.  Local timers allows the system
