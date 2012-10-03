Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2JCWYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:24:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64513 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2JCWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:23:58 -0400
Message-ID: <506CBAFC.8010908@zankel.net>
Date: Wed, 03 Oct 2012 15:23:56 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] xtensa patchset for 3.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the changes for the Xtensa architecture for v3.7.

Thanks,
-Chris



The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

   Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

   git@github.com:czankel/xtensa-linux tags/xtensa-next-20121003

for you to fetch changes up to 9ad79b58510b2845e5ffa77654596d7184a827ab:

   xtensa: drop CONFIG_EMBEDDED_RAMDISK (2012-10-03 15:13:09 -0700)

----------------------------------------------------------------
Patchset for the Xtensa architecture for 3.7

----------------------------------------------------------------
Chris Zankel (1):
       MAINTAINERS: add Max Filippov as an xtensa port maintainer

Max Filippov (25):
       xtensa: fix linker script transformation for .text.unlikely
       xtensa: ISS: only build networking if configured
       xtensa/PCI: fix WT caching attribute
       xtensa: fix xtensa_irq_unmask calls
       xtensa: ISS: fix __simc implementation
       modpost: fix modpost warnings for xtensa
       xtensa: fix ioremap
       xtensa: adopt generic io routines
       xtensa: set NO_IOPORT to 'n' by default
       xtensa: add ARCH_WANT_OPTIONAL_GPIOLIB to xtensa config
       xtensa: change default platform clock frequency to 10MHz
       xtensa: ISS: add dummy serial.h for ISS platform
       xtensa: ISS: add platform_pcibios_init
       xtensa: ISS: change keyboard polling rate
       xtensa: ISS: exit simulator in case of halt or poweroff
       xtensa: ISS: drop unused io.c
       xtensa: fix parallel make
       xtensa: fix CODA build
       hisax: disable build for big-endian xtensa
       xtensa: rename MISC SR definition to avoid name clashes
       parport: disable for xtensa arch
       xtensa: add missing symbol exports
       xtensa: provide dummy gcc intrinsics
       xtensa: fix TIOCGSERIAL and TIOCSSERIAL definitions
       xtensa: drop CONFIG_EMBEDDED_RAMDISK

  MAINTAINERS                                        |    2 +
  arch/xtensa/Kconfig                                |   23 +--
  arch/xtensa/Makefile                               |   10 +-
  arch/xtensa/boot/Makefile                          |    2 +-
  arch/xtensa/boot/boot-elf/Makefile                 |   24 +--
  arch/xtensa/boot/boot-elf/boot.lds.S               |    7 -
  arch/xtensa/boot/boot-redboot/Makefile             |   12 +-
  arch/xtensa/boot/boot-redboot/boot.ld              |    7 -
  arch/xtensa/boot/boot-redboot/bootstrap.S          |   10 --
  arch/xtensa/boot/ramdisk/Makefile                  |   23 ---
  arch/xtensa/configs/s6105_defconfig                |    5 -
  arch/xtensa/include/asm/io.h                       |  172 
+++-----------------
  arch/xtensa/include/asm/ioctls.h                   |    4 +-
  arch/xtensa/include/asm/regs.h                     |    2 +-
  arch/xtensa/kernel/Makefile                        |    3 +-
  arch/xtensa/kernel/io.c                            |   75 ---------
  arch/xtensa/kernel/irq.c                           |    4 +-
  arch/xtensa/kernel/pci-dma.c                       |    4 +
  arch/xtensa/kernel/pci.c                           |    2 +-
  arch/xtensa/kernel/platform.c                      |    4 +-
  arch/xtensa/kernel/setup.c                         |   12 --
  arch/xtensa/kernel/vmlinux.lds.S                   |    5 -
  arch/xtensa/kernel/xtensa_ksyms.c                  |   25 +++
  arch/xtensa/platforms/iss/Makefile                 |    4 +-
  arch/xtensa/platforms/iss/console.c                |   15 +-
  .../platforms/iss/include/platform/simcall.h       |   53 ++++++
  arch/xtensa/platforms/iss/io.c                     |   32 ----
  arch/xtensa/platforms/iss/network.c                |   49 ------
  arch/xtensa/platforms/iss/setup.c                  |   14 +-
  drivers/isdn/hisax/Kconfig                         |   10 +-
  drivers/parport/Kconfig                            |    2 +-
  drivers/usb/musb/musb_io.h                         |    3 +-
  scripts/mod/modpost.c                              |    2 +
  33 files changed, 157 insertions(+), 464 deletions(-)
  delete mode 100644 arch/xtensa/boot/ramdisk/Makefile
  delete mode 100644 arch/xtensa/kernel/io.c
  create mode 100644 arch/xtensa/platforms/iss/include/platform/serial.h
  delete mode 100644 arch/xtensa/platforms/iss/io.c

