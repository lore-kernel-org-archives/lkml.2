Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0JZAkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:40:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0JZAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=VjVfD0/6NLIkE/K0CsNRwLzMx71hEyAhciquEcw1GEl09TkBSXQcgP+f+6cmoAwYrJ
         LkYyp+oo4DSM0DC5Az+w==
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 17:39:57 -0700
X-Google-Sender-Auth: 5LQsvjam_fjZXwoSkM4zoNP2678
Message-ID: <AANLkTimb=xgE0B-N4w45m4iJK61KQ19pD9tXj7dSJ=Mh@mail.gmail.com>
Subject: [GIT PULL] tegra updates for 2.6.37
From: Colin Cross <ccross@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Tegra Mailing List <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull updates for the Tegra machine from:

  git://android.git.kernel.org/kernel/tegra.git for-next

Thanks,
Colin

The following changes since commit b5153163ed580e00c67bdfecb02b2e3843817b3e:

  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
(2010-10-21 16:42:32 -0700)


Colin Cross (9):
      [ARM] tegra: update iomap
      [ARM] tegra: Add legacy irq support
      [ARM] tegra: pinmux: add safe values, move tegra2, add suspend
      [ARM] tegra: gpio: Add suspend and wake support
      [ARM] tegra: Add support for reading fuses
      [ARM] tegra: clock: Add dvfs support, bug fixes, and cleanups
      [ARM] tegra: common: Update common clock init table
      [ARM] tegra: Add cpufreq support
      [ARM] tegra: Add APB DMA support

Erik Gilling (2):
      spi: add spi_tegra driver
      spi: tegra: fix error setting on timeout

Gary King (1):
      [ARM] tegra: add suspend and mirror irqs to legacy controller

Mike Rapoport (3):
      tegra: add PCI Express clocks
      tegra: add PCI Express support
      tegra: harmony: enable PCI Express

 arch/arm/Kconfig                              |    1 +
 arch/arm/mach-tegra/Kconfig                   |   11 +
 arch/arm/mach-tegra/Makefile                  |    9 +-
 arch/arm/mach-tegra/board-harmony-pcie.c      |   57 ++
 arch/arm/mach-tegra/board.h                   |    1 +
 arch/arm/mach-tegra/clock.c                   |  267 +++++++-
 arch/arm/mach-tegra/clock.h                   |   58 ++-
 arch/arm/mach-tegra/common.c                  |   13 +-
 arch/arm/mach-tegra/cpu-tegra.c               |  185 +++++
 arch/arm/mach-tegra/dma.c                     |  752 ++++++++++++++++++++
 arch/arm/mach-tegra/fuse.c                    |   84 +++
 arch/arm/mach-tegra/fuse.h                    |   24 +
 arch/arm/mach-tegra/gpio.c                    |  104 +++-
 arch/arm/mach-tegra/include/mach/clk.h        |    5 +
 arch/arm/mach-tegra/include/mach/dma.h        |  155 +++++
 arch/arm/mach-tegra/include/mach/gpio.h       |    4 +-
 arch/arm/mach-tegra/include/mach/hardware.h   |    4 +
 arch/arm/mach-tegra/include/mach/io.h         |   18 +-
 arch/arm/mach-tegra/include/mach/iomap.h      |   33 +-
 arch/arm/mach-tegra/include/mach/irqs.h       |    2 +
 arch/arm/mach-tegra/include/mach/legacy_irq.h |   31 +
 arch/arm/mach-tegra/include/mach/pinmux-t2.h  |  174 +++++
 arch/arm/mach-tegra/include/mach/pinmux.h     |  210 ++-----
 arch/arm/mach-tegra/io.c                      |    6 +
 arch/arm/mach-tegra/irq.c                     |  137 ++++
 arch/arm/mach-tegra/legacy_irq.c              |  114 +++
 arch/arm/mach-tegra/pcie.c                    |  915 +++++++++++++++++++++++++
 arch/arm/mach-tegra/pinmux-t2-tables.c        |  260 +++++++
 arch/arm/mach-tegra/pinmux.c                  |  354 ++++-------
 arch/arm/mach-tegra/tegra2_clocks.c           |  826 ++++++++++++++++++-----
 arch/arm/mach-tegra/tegra2_dvfs.c             |   86 +++
 arch/arm/mach-tegra/tegra2_dvfs.h             |   20 +
 drivers/spi/Kconfig                           |    7 +
 drivers/spi/Makefile                          |    1 +
 drivers/spi/spi_tegra.c                       |  618 +++++++++++++++++
 35 files changed, 4917 insertions(+), 629 deletions(-)
 create mode 100644 arch/arm/mach-tegra/board-harmony-pcie.c
 create mode 100644 arch/arm/mach-tegra/cpu-tegra.c
 create mode 100644 arch/arm/mach-tegra/dma.c
 create mode 100644 arch/arm/mach-tegra/fuse.c
 create mode 100644 arch/arm/mach-tegra/fuse.h
 create mode 100644 arch/arm/mach-tegra/include/mach/dma.h
 create mode 100644 arch/arm/mach-tegra/include/mach/legacy_irq.h
 create mode 100644 arch/arm/mach-tegra/include/mach/pinmux-t2.h
 create mode 100644 arch/arm/mach-tegra/legacy_irq.c
 create mode 100644 arch/arm/mach-tegra/pcie.c
 create mode 100644 arch/arm/mach-tegra/pinmux-t2-tables.c
 create mode 100644 arch/arm/mach-tegra/tegra2_dvfs.c
 create mode 100644 arch/arm/mach-tegra/tegra2_dvfs.h
 create mode 100644 drivers/spi/spi_tegra.c
