Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967321Ab2EQQle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:41:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:40046 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab2EQQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:41:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC/PATCH 0/5] Delete microchannel [CONFIG_MCA] support
Date: Thu, 17 May 2012 12:40:36 -0400
Message-Id: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was good that we could support MCA machines back in the day, but
realistically, nobody is using them anymore.  They were limited to
386-sx 16MHz CPU and some 486 class machines and never more than 64MB
of RAM.  Even the enthusiast hobbyist community seems to have dried up
close to ten years ago, based on what you can find searching various
websites dedicated to the relatively short lived hardware.

So lets remove the support relating to CONFIG_MCA.  There is no point
carrying this forward, wasting cycles doing routine maintenance on it;
wasting allyesconfig build time on validating it, wasting I/O on
git grep'ping over it, and so on.

The commits shown here are based off net-next (d584515fb), since net-next
has already removed the Token Ring support that was largely limited to
IBM's MCA equipped machines (and hence depended on CONFIG_MCA).

I've not bothered to list the line-by-line deletions of whole files
that are removed in this RFC, since that conveys no useful information.

Build coverage so far has been x86, x86_64, allyesconfig, allmodconfig.

Thanks,
Paul.
---

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

Paul Gortmaker (5):
  arm: remove ability to select CONFIG_MCA
  drivers/net: delete all code/drivers depending on CONFIG_MCA
  serial: delete the MCA specific 8250 support.
  scsi: delete the MCA specific drivers and driver code
  MCA: delete all remaining traces of microchannel bus support.

 Documentation/00-INDEX                  |    2 -
 Documentation/DocBook/Makefile          |    2 +-
 Documentation/DocBook/kernel-api.tmpl   |   13 -
 Documentation/DocBook/mcabook.tmpl      |  107 --
 Documentation/devices.txt               |    8 +-
 Documentation/eisa.txt                  |    2 +-
 Documentation/kernel-parameters.txt     |    1 -
 Documentation/mca.txt                   |  313 ----
 Documentation/networking/3c509.txt      |    1 -
 Documentation/networking/fore200e.txt   |    6 +-
 Documentation/scsi/00-INDEX             |    2 -
 Documentation/scsi/ibmmca.txt           | 1402 ------------------
 Documentation/scsi/scsi-parameters.txt  |    6 -
 Documentation/scsi/scsi_mid_low_api.txt |    2 +-
 Documentation/serial/stallion.txt       |   22 +-
 MAINTAINERS                             |   13 -
 arch/arm/Kconfig                        |    8 -
 arch/frv/include/asm/processor.h        |    1 -
 arch/x86/Kconfig                        |   10 -
 arch/x86/include/asm/mca.h              |   43 -
 arch/x86/include/asm/mca_dma.h          |  201 ---
 arch/x86/include/asm/mpspec.h           |    2 +-
 arch/x86/include/asm/mpspec_def.h       |    3 +-
 arch/x86/kernel/Makefile                |    1 -
 arch/x86/kernel/acpi/boot.c             |    2 +-
 arch/x86/kernel/apic/io_apic.c          |   17 +-
 arch/x86/kernel/mca_32.c                |  476 ------
 arch/x86/kernel/mpparse.c               |   11 +-
 arch/x86/kernel/nmi.c                   |   12 -
 arch/x86/kernel/setup.c                 |    8 -
 arch/x86/kernel/time.c                  |    6 -
 arch/x86/kernel/traps.c                 |    4 -
 drivers/Makefile                        |    1 -
 drivers/mca/Kconfig                     |   14 -
 drivers/mca/Makefile                    |    7 -
 drivers/mca/mca-bus.c                   |  169 ---
 drivers/mca/mca-device.c                |  218 ---
 drivers/mca/mca-driver.c                |   63 -
 drivers/mca/mca-legacy.c                |  329 -----
 drivers/mca/mca-proc.c                  |  249 ----
 drivers/message/i2o/i2o_proc.c          |   13 -
 drivers/net/Space.c                     |   16 +-
 drivers/net/ethernet/3com/3c509.c       |  123 +--
 drivers/net/ethernet/8390/Kconfig       |   24 -
 drivers/net/ethernet/8390/Makefile      |    1 -
 drivers/net/ethernet/8390/ne2.c         |  798 -----------
 drivers/net/ethernet/8390/smc-mca.c     |  575 --------
 drivers/net/ethernet/amd/depca.c        |  210 +---
 drivers/net/ethernet/fujitsu/at1700.c   |  120 +--
 drivers/net/ethernet/i825xx/3c523.c     | 1312 -----------------
 drivers/net/ethernet/i825xx/3c523.h     |  355 -----
 drivers/net/ethernet/i825xx/3c527.c     | 1660 ---------------------
 drivers/net/ethernet/i825xx/Kconfig     |   22 -
 drivers/net/ethernet/i825xx/Makefile    |    2 -
 drivers/net/ethernet/i825xx/eexpress.c  |   60 +-
 drivers/net/ethernet/natsemi/Kconfig    |   20 +-
 drivers/net/ethernet/natsemi/Makefile   |    1 -
 drivers/scsi/Kconfig                    |   83 --
 drivers/scsi/Makefile                   |    2 -
 drivers/scsi/aha1542.c                  |   66 +-
 drivers/scsi/fd_mcs.c                   | 1354 ------------------
 drivers/scsi/ibmmca.c                   | 2379 -------------------------------
 drivers/scsi/sim710.c                   |  124 +--
 drivers/tty/serial/8250/8250_mca.c      |   61 -
 drivers/tty/serial/8250/Kconfig         |    9 -
 drivers/tty/serial/8250/Makefile        |    1 -
 include/linux/i2o-dev.h                 |    2 +-
 include/linux/mca-legacy.h              |   66 -
 include/linux/mca.h                     |  148 --
 include/linux/serial.h                  |    2 -
 include/linux/serial_8250.h             |    1 -
 scripts/kconfig/mconf.c                 |    2 +-
 scripts/kconfig/nconf.c                 |    2 +-
 73 files changed, 50 insertions(+), 13321 deletions(-)
 delete mode 100644 Documentation/DocBook/mcabook.tmpl
 delete mode 100644 Documentation/mca.txt
 delete mode 100644 Documentation/scsi/ibmmca.txt
 delete mode 100644 arch/x86/include/asm/mca.h
 delete mode 100644 arch/x86/include/asm/mca_dma.h
 delete mode 100644 arch/x86/kernel/mca_32.c
 delete mode 100644 drivers/mca/Kconfig
 delete mode 100644 drivers/mca/Makefile
 delete mode 100644 drivers/mca/mca-bus.c
 delete mode 100644 drivers/mca/mca-device.c
 delete mode 100644 drivers/mca/mca-driver.c
 delete mode 100644 drivers/mca/mca-legacy.c
 delete mode 100644 drivers/mca/mca-proc.c
 delete mode 100644 drivers/net/ethernet/8390/ne2.c
 delete mode 100644 drivers/net/ethernet/8390/smc-mca.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c523.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c523.h
 delete mode 100644 drivers/net/ethernet/i825xx/3c527.c
 delete mode 100644 drivers/scsi/fd_mcs.c
 delete mode 100644 drivers/scsi/ibmmca.c
 delete mode 100644 drivers/tty/serial/8250/8250_mca.c
 delete mode 100644 include/linux/mca-legacy.h
 delete mode 100644 include/linux/mca.h

-- 
1.7.9.1

