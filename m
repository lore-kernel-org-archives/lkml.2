Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab2KAULP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502Ab2KAULN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:11:13 -0400
From: Milan Broz <mbroz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, kzak@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: [RFC PATCH 0/4] Remove cryptoloop support
Date: Thu,  1 Nov 2012 21:11:00 +0100
Message-Id: <cover.1351799189.git.mbroz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after several "is cryptoloop supported/secure/maintained" discussions
(which regularly repeats for years on various occasions) we should do something.

So let's remove cryptoloop support from kernel :-)

Current mainline userspace (util-linux) is going to remove encryption support
in next losetup version (already removed in git tree), encryption support is
already deprecated in the last release.

There are known problems with cryptoloop (like predictable IV or hardcoded sizes),
and if you read even some very old notes, nothing changed for years.
(e.g. this page http://mareichelt.com/pub/texts.cryptoloop.html)

Dm-crypt/cryptsetup provides replacement for long time already.
It allocates loop device automatically for file images and with proper parameters
it can map existing images - even some old which are not supported by current
cryptoloop. On the other side it requires device-mapper modules (dm_mod, dm_crypt).

Alternative (out of tree) loop-AES already replaces most of the kernel
and userpsace code by own patches anyway.

I am not fan of removing old code this way but I do not see alternative here.
Please comment if you see better solution...

Thanks,
Milan

Milan Broz (4):
  Remove cryptoloop module.
  Remove cryptoloop config option.
  Deprecate loop crypto ioctl fields.
  Remove transfer module support in loop.

 arch/arm/configs/colibri_pxa270_defconfig      |    1 -
 arch/arm/configs/ezx_defconfig                 |    1 -
 arch/arm/configs/imote2_defconfig              |    1 -
 arch/arm/configs/lpc32xx_defconfig             |    1 -
 arch/arm/configs/netx_defconfig                |    1 -
 arch/arm/configs/nhk8815_defconfig             |    1 -
 arch/arm/configs/trizeps4_defconfig            |    1 -
 arch/ia64/configs/bigsur_defconfig             |    1 -
 arch/ia64/configs/generic_defconfig            |    1 -
 arch/ia64/configs/gensparse_defconfig          |    1 -
 arch/ia64/configs/tiger_defconfig              |    1 -
 arch/ia64/configs/xen_domu_defconfig           |    1 -
 arch/m68k/configs/amiga_defconfig              |    1 -
 arch/m68k/configs/apollo_defconfig             |    1 -
 arch/m68k/configs/atari_defconfig              |    1 -
 arch/m68k/configs/bvme6000_defconfig           |    1 -
 arch/m68k/configs/hp300_defconfig              |    1 -
 arch/m68k/configs/mac_defconfig                |    1 -
 arch/m68k/configs/multi_defconfig              |    1 -
 arch/m68k/configs/mvme147_defconfig            |    1 -
 arch/m68k/configs/mvme16x_defconfig            |    1 -
 arch/m68k/configs/q40_defconfig                |    1 -
 arch/m68k/configs/sun3_defconfig               |    1 -
 arch/m68k/configs/sun3x_defconfig              |    1 -
 arch/mips/configs/bcm47xx_defconfig            |    1 -
 arch/mips/configs/bigsur_defconfig             |    1 -
 arch/mips/configs/fuloong2e_defconfig          |    1 -
 arch/mips/configs/ip27_defconfig               |    1 -
 arch/mips/configs/ip32_defconfig               |    1 -
 arch/mips/configs/jazz_defconfig               |    1 -
 arch/mips/configs/lemote2f_defconfig           |    1 -
 arch/mips/configs/malta_defconfig              |    1 -
 arch/mips/configs/markeins_defconfig           |    1 -
 arch/mips/configs/nlm_xlp_defconfig            |    1 -
 arch/mips/configs/nlm_xlr_defconfig            |    1 -
 arch/mips/configs/rm200_defconfig              |    1 -
 arch/mips/configs/sead3_defconfig              |    1 -
 arch/parisc/configs/712_defconfig              |    1 -
 arch/parisc/configs/b180_defconfig             |    1 -
 arch/parisc/configs/c3000_defconfig            |    1 -
 arch/parisc/configs/default_defconfig          |    1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig   |    1 -
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig  |    1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig |    1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig |    1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig   |    1 -
 arch/powerpc/configs/c2k_defconfig             |    1 -
 arch/powerpc/configs/chroma_defconfig          |    1 -
 arch/powerpc/configs/ppc6xx_defconfig          |    1 -
 arch/score/configs/spct6600_defconfig          |    1 -
 arch/sh/configs/sdk7786_defconfig              |    1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig      |    1 -
 arch/sh/configs/titan_defconfig                |    1 -
 arch/sparc/configs/sparc32_defconfig           |    1 -
 arch/sparc/configs/sparc64_defconfig           |    1 -
 arch/tile/configs/tilegx_defconfig             |    1 -
 arch/tile/configs/tilepro_defconfig            |    1 -
 arch/um/defconfig                              |    1 -
 drivers/block/Kconfig                          |   23 --
 drivers/block/Makefile                         |    1 -
 drivers/block/cryptoloop.c                     |  216 ---------------
 drivers/block/loop.c                           |  344 +++---------------------
 include/linux/loop.h                           |   31 ---
 include/uapi/linux/loop.h                      |   18 +-
 64 files changed, 44 insertions(+), 647 deletions(-)
 delete mode 100644 drivers/block/cryptoloop.c

-- 
1.7.10.4

