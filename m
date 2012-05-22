Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2EVWFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:05:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:37629 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2EVWFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:05:37 -0400
Date: Tue, 22 May 2012 18:05:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Delete MCA support
Message-ID: <20120522220533.GA1781@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Aside from adding some Acked-by lines, these four commits to delete
the MCA support remain unchanged since last week's RFC.

DaveM requested the MCA net driver deletion for net-next independently,
so that net-next commit (which you already have) became the baseline
for my "delete-mca" branch, and remains so for this pull.

A test merge against today's tree was seamless and automatic.

My original text from the 0/5 RFC is below, should you want to use it
as part of a merge commit description:

---------
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
---------

Please pull the below to finalize the MCA removal for v3.5.

Thanks,
Paul
---

The following changes since commit a5e371f61ad33c07b28e7c9b60c78d71fdd34e2a:

  drivers/net: delete all code/drivers depending on CONFIG_MCA (2012-05-17 16:37:41 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git delete-mca

for you to fetch changes up to bb8187d35f820671d6dd76700d77a6b55f95e2c5:

  MCA: delete all remaining traces of microchannel bus support. (2012-05-17 19:06:13 -0400)

----------------------------------------------------------------
Paul Gortmaker (4):
      arm: remove ability to select CONFIG_MCA
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
 55 files changed, 32 insertions(+), 8033 deletions(-)
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
 delete mode 100644 drivers/scsi/fd_mcs.c
 delete mode 100644 drivers/scsi/ibmmca.c
 delete mode 100644 drivers/tty/serial/8250/8250_mca.c
 delete mode 100644 include/linux/mca-legacy.h
 delete mode 100644 include/linux/mca.h
