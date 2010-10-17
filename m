Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0JQXb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 19:31:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49042 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0JQXb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 19:31:56 -0400
Date: Mon, 18 Oct 2010 10:31:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the davinci tree with the arm tree
Message-Id: <20101018103152.33fa12cd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Today's linux-next merge of the davinci tree got a conflicts in
arch/arm/mach-davinci/board-da830-evm.c and
arch/arm/mach-davinci/board-da850-evm.c between commit
861bd81ee62a0d6759144c22909a8a3938951656 ("arm: remove
machine_desc.io_pg_offst and .phys_io") from the arm tree and commit
48ea89eabee96019a4a84615af921f8703320abb ("davinci: introduce support for
AM1x ARM9 microprocessors") from the davinci tree.

Just context changes,  I fixed them up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/board-da830-evm.c
index 7f3cdbf,1bb89d3..0000000
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@@ -596,7 -608,9 +608,7 @@@ static void __init da830_evm_map_io(voi
  	da830_init();
  }
  
- MACHINE_START(DAVINCI_DA830_EVM, "DaVinci DA830/OMAP-L137 EVM")
+ MACHINE_START(DAVINCI_DA830_EVM, "DaVinci DA830/OMAP-L137/AM17x EVM")
 -	.phys_io	= IO_PHYS,
 -	.io_pg_offst	= (__IO_ADDRESS(IO_PHYS) >> 18) & 0xfffc,
  	.boot_params	= (DA8XX_DDR_BASE + 0x100),
  	.map_io		= da830_evm_map_io,
  	.init_irq	= cp_intc_init,
diff --cc arch/arm/mach-davinci/board-da850-evm.c
index b26f5cb,ef97c7f..0000000
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@@ -816,7 -868,9 +868,7 @@@ static void __init da850_evm_map_io(voi
  	da850_init();
  }
  
- MACHINE_START(DAVINCI_DA850_EVM, "DaVinci DA850/OMAP-L138 EVM")
+ MACHINE_START(DAVINCI_DA850_EVM, "DaVinci DA850/OMAP-L138/AM18x EVM")
 -	.phys_io	= IO_PHYS,
 -	.io_pg_offst	= (__IO_ADDRESS(IO_PHYS) >> 18) & 0xfffc,
  	.boot_params	= (DA8XX_DDR_BASE + 0x100),
  	.map_io		= da850_evm_map_io,
  	.init_irq	= cp_intc_init,
