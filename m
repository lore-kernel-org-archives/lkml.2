Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab2ANFqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:46:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51383 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2ANFqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:46:10 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 13 Jan 2012 22:45:48 -0700
X-Google-Sender-Auth: cTpanIIg4y6lQ9FIu9wQX7TLzVw
Message-ID: <CACxGe6sKfkaaFrcnjo3futEW1Os7LxR1PEehFr5vA3kAgOOa6g@mail.gmail.com>
Subject: [git pull] 2nd round of GPIO fixes for v3.3
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a second batch of gpio changes for 3.3.  The majority of these
weren't in the first gpio pull request because I pushed them out for
linux-next on the same day that you announced 3.2, but they're pretty
low risk and have spent the last week and a half in linux-next.  The
last one is a bug fix.  I hope you'll be okay with them for merging.

g.

The following changes since commit 5f0a6e2d503896062f641639dacfe5055c2f593b:

  Linux 3.2-rc7 (2011-12-23 21:51:06 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio-for-linus

Chris Blair (3):
      spi/pl022: only enable RX interrupts when TX is complete
      spi/pl022: move device disable to workqueue thread
      spi/pl022: add support for pm_runtime autosuspend

Deepak Sikri (1):
      GPIO/pl061: Add suspend resume capability

Grant Likely (8):
      gpiolib: output basic details and consolidate gpio device drivers
      gpio/microblaze: Eliminate duplication of of_get_named_gpio_flags()
      gpio/powerpc: Eliminate duplication of of_get_named_gpio_flags()
      of: create of_phandle_args to simplify return of phandle parsing data
      of: Add device tree selftests
      gpio: Add Linus Walleij as gpio co-maintainer
      Merge branch 'pl022' of
git://git.kernel.org/.../linusw/linux-stericsson into gpio/next
      Merge branch 'gpio-for-grant' of
git://sources.calxeda.com/kernel/linux into gpio/next

John Crispin (1):
      GPIO: add bindings for managed devices

Jonas Aaberg (1):
      spi/pl022: fix build warnings

Julia Lawall (1):
      drivers/gpio/gpio-tegra.c: use devm_request_and_ioremap

Mark Brown (4):
      gpio: Explicitly index samsung_gpio_cfgs
      gpio: Fix typo in comment in Samsung driver
      gpio: Convert GPIO drivers to module_platform_driver
      gpio: Add decode of WM8994 GPIO configuration

Rob Herring (5):
      gpio: pl061: use chained_irq_* functions in irq handler
      gpio: pl061: convert to use 0 for no irq
      ARM: realview: convert pl061 no irq to 0 instead of -1
      gpio: pl061: convert to use generic irq chip
      gpio: pl061: remove combined interrupt

Russell King (1):
      GPIO: sa1100: implement proper gpiolib gpio_to_irq conversion

Tomoya MORINAGA (2):
      pch_gpio: Support new device LAPIS Semiconductor ML7831 IOH
      pch_gpio: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor

Virupax Sadashivpetimath (3):
      spi/pl022: skip default configuration before suspending
      spi/pl022: disable the PL022 block when unused
      spi/pl022: make the chip deselect handling thread safe

 MAINTAINERS                                    |    1 +
 arch/arm/boot/dts/testcases/tests-phandle.dtsi |   37 +++++
 arch/arm/boot/dts/testcases/tests.dtsi         |    1 +
 arch/arm/boot/dts/versatile-pb.dts             |    2 +
 arch/arm/mach-realview/realview_eb.c           |    3 -
 arch/arm/mach-realview/realview_pb1176.c       |    3 -
 arch/arm/mach-realview/realview_pb11mp.c       |    3 -
 arch/arm/mach-realview/realview_pba8.c         |    3 -
 arch/arm/mach-realview/realview_pbx.c          |    3 -
 arch/arm/mach-sa1100/include/mach/gpio.h       |    3 -
 arch/microblaze/kernel/reset.c                 |   43 +-----
 arch/powerpc/sysdev/qe_lib/gpio.c              |   42 +----
 drivers/gpio/Kconfig                           |   12 +-
 drivers/gpio/Makefile                          |    2 +-
 drivers/gpio/devres.c                          |   90 +++++++++++
 drivers/gpio/gpio-adp5520.c                    |   12 +--
 drivers/gpio/gpio-adp5588.c                    |    5 +-
 drivers/gpio/gpio-bt8xx.c                      |    3 -
 drivers/gpio/gpio-cs5535.c                     |   14 +--
 drivers/gpio/gpio-da9052.c                     |   12 +--
 drivers/gpio/gpio-generic.c                    |   12 +--
 drivers/gpio/gpio-janz-ttl.c                   |   15 +--
 drivers/gpio/gpio-nomadik.c                    |    4 +-
 drivers/gpio/gpio-pcf857x.c                    |    5 +-
 drivers/gpio/gpio-pch.c                        |    7 +-
 drivers/gpio/gpio-pl061.c                      |  200 +++++++++++++-----------
 drivers/gpio/gpio-rdc321x.c                    |   13 +--
 drivers/gpio/gpio-sa1100.c                     |    6 +
 drivers/gpio/gpio-samsung.c                    |   31 +++--
 drivers/gpio/gpio-sch.c                        |   13 +--
 drivers/gpio/gpio-tegra.c                      |    9 +-
 drivers/gpio/gpio-timberdale.c                 |   13 +--
 drivers/gpio/gpio-ucb1400.c                    |   13 +--
 drivers/gpio/gpio-vr41xx.c                     |   13 +--
 drivers/gpio/gpio-vx855.c                      |   12 +--
 drivers/gpio/gpio-wm8994.c                     |   79 +++++++++-
 drivers/gpio/gpio-xilinx.c                     |    1 -
 drivers/gpio/gpiolib.c                         |    6 +-
 drivers/of/Kconfig                             |    9 +
 drivers/of/Makefile                            |    1 +
 drivers/of/base.c                              |  146 +++++++++---------
 drivers/of/gpio.c                              |   45 +++---
 drivers/of/selftest.c                          |  139 ++++++++++++++++
 drivers/spi/spi-pl022.c                        |  141 ++++++++++-------
 include/asm-generic/gpio.h                     |   10 +-
 include/linux/amba/pl022.h                     |    4 +
 include/linux/amba/pl061.h                     |    2 +-
 include/linux/of.h                             |   11 +-
 include/linux/of_gpio.h                        |   10 +-
 49 files changed, 744 insertions(+), 520 deletions(-)
 create mode 100644 arch/arm/boot/dts/testcases/tests-phandle.dtsi
 create mode 100644 arch/arm/boot/dts/testcases/tests.dtsi
 create mode 100644 drivers/gpio/devres.c
 create mode 100644 drivers/of/selftest.c


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
