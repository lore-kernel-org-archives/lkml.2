Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab0GHBhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:37:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54351 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab0GHBhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:37:36 -0400
Date: Thu, 8 Jul 2010 11:37:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Mike Rapoport <mike@compulab.co.il>
Subject: linux-next: manual merge of the omap tree with the arm tree
Message-Id: <20100708113730.c2683125.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the omap tree got conflicts in
arch/arm/mach-omap2/board-3430sdp.c,
arch/arm/mach-omap2/board-3630sdp.c,
arch/arm/mach-omap2/board-am3517evm.c,
arch/arm/mach-omap2/board-cm-t35.c,
arch/arm/mach-omap2/board-devkit8000.c,
arch/arm/mach-omap2/board-igep0020.c,
arch/arm/mach-omap2/board-ldp.c,
arch/arm/mach-omap2/board-omap3beagle.c,
arch/arm/mach-omap2/board-omap3evm.c,
arch/arm/mach-omap2/board-omap3pandora.c,
arch/arm/mach-omap2/board-omap3touchbook.c,
arch/arm/mach-omap2/board-overo.c,
arch/arm/mach-omap2/board-zoom2.c and
arch/arm/mach-omap2/board-zoom3.c
between commit 1e6d923b4e5729b73518d241edf87a3ab2d5688c ("ARM: OMAP:
Convert to use ->reserve method to reserve boot time memory") from the
arm tree and commit c752ab9d5a5b6899f14fe1c6643c0fe0b499a4ba ("omap3:
introduce omap3_map_io") from the omap tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

P.S. Tony, that omap tree commit has a fairly unuseful changelog and no
SOB from its purported author ...

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-3430sdp.c
index dd9c031,e51f8e3..0000000
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@@ -814,8 -808,7 +808,8 @@@ MACHINE_START(OMAP_3430SDP, "OMAP3430 3
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap_3430sdp_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap_3430sdp_init_irq,
  	.init_machine	= omap_3430sdp_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-3630sdp.c
index 57290fb,8b7c2f9..0000000
--- a/arch/arm/mach-omap2/board-3630sdp.c
+++ b/arch/arm/mach-omap2/board-3630sdp.c
@@@ -107,8 -100,7 +100,8 @@@ MACHINE_START(OMAP_3630SDP, "OMAP 3630S
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap_sdp_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap_sdp_init_irq,
  	.init_machine	= omap_sdp_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-am3517evm.c
index 7da92de,bbfdc6e..0000000
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@@ -471,8 -465,7 +465,8 @@@ MACHINE_START(OMAP3517EVM, "OMAP3517/AM
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= am3517_evm_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= am3517_evm_init_irq,
  	.init_machine	= am3517_evm_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-cm-t35.c
index bc4c3f8,79d6b15..0000000
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@@ -836,8 -830,7 +830,8 @@@ MACHINE_START(CM_T35, "Compulab CM-T35"
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= cm_t35_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= cm_t35_init_irq,
  	.init_machine	= cm_t35_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-devkit8000.c
index 922b746,4b7103a..0000000
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@@ -824,8 -826,7 +826,8 @@@ MACHINE_START(DEVKIT8000, "OMAP3 Devkit
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= devkit8000_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= devkit8000_init_irq,
  	.init_machine	= devkit8000_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-igep0020.c
index 759e39d,b26319c..0000000
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@@ -542,8 -536,7 +536,8 @@@ MACHINE_START(IGEP0020, "IGEP v2 board"
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= igep2_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= igep2_init_irq,
  	.init_machine	= igep2_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-ldp.c
index 9cd2669,6e3930e..0000000
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@@ -416,8 -410,7 +410,8 @@@ MACHINE_START(OMAP_LDP, "OMAP LDP board
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap_ldp_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap_ldp_init_irq,
  	.init_machine	= omap_ldp_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-omap3beagle.c
index 0ab0c26,64aa557..0000000
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@@ -518,8 -512,7 +512,8 @@@ MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beag
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap3_beagle_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap3_beagle_init_irq,
  	.init_machine	= omap3_beagle_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-omap3evm.c
index a3d2e28,6cde29d..0000000
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@@ -726,8 -720,7 +720,8 @@@ MACHINE_START(OMAP3EVM, "OMAP3 EVM"
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap3_evm_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap3_evm_init_irq,
  	.init_machine	= omap3_evm_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-omap3pandora.c
index c0f4f12,f3b7a8a..0000000
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@@ -600,8 -704,7 +704,8 @@@ MACHINE_START(OMAP3_PANDORA, "Pandora H
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap3pandora_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap3pandora_init_irq,
  	.init_machine	= omap3pandora_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-omap3touchbook.c
index f05b867,820eaf1..0000000
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@@ -570,8 -564,7 +564,8 @@@ MACHINE_START(TOUCHBOOK, "OMAP3 touchbo
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap3_touchbook_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap3_touchbook_init_irq,
  	.init_machine	= omap3_touchbook_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-overo.c
index 87acb2f,b6bc315..0000000
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@@ -494,8 -526,7 +526,8 @@@ MACHINE_START(OVERO, "Gumstix Overo"
  	.phys_io	= 0x48000000,
  	.io_pg_offst	= ((0xfa000000) >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= overo_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= overo_init_irq,
  	.init_machine	= overo_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-zoom2.c
index ffe188c,bbc7826..0000000
--- a/arch/arm/mach-omap2/board-zoom2.c
+++ b/arch/arm/mach-omap2/board-zoom2.c
@@@ -94,8 -103,7 +103,8 @@@ MACHINE_START(OMAP_ZOOM2, "OMAP Zoom2 b
  	.phys_io	= ZOOM_UART_BASE,
  	.io_pg_offst	= (ZOOM_UART_VIRT >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap_zoom2_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap_zoom2_init_irq,
  	.init_machine	= omap_zoom2_init,
  	.timer		= &omap_timer,
diff --cc arch/arm/mach-omap2/board-zoom3.c
index 5b605eb,0c6858b..0000000
--- a/arch/arm/mach-omap2/board-zoom3.c
+++ b/arch/arm/mach-omap2/board-zoom3.c
@@@ -76,8 -85,7 +85,8 @@@ MACHINE_START(OMAP_ZOOM3, "OMAP Zoom3 b
  	.phys_io	= ZOOM_UART_BASE,
  	.io_pg_offst	= (ZOOM_UART_VIRT >> 18) & 0xfffc,
  	.boot_params	= 0x80000100,
- 	.map_io		= omap_zoom_map_io,
+ 	.map_io		= omap3_map_io,
 +	.reserve	= omap_reserve,
  	.init_irq	= omap_zoom_init_irq,
  	.init_machine	= omap_zoom_init,
  	.timer		= &omap_timer,
