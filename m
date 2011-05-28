Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab1E1GEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 02:04:40 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:45592 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1E1GEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 02:04:39 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 28 May 2011 00:04:18 -0600
X-Google-Sender-Auth: GviCFnJkSqqkQm2jvT77SMJi-oc
Message-ID: <BANLkTikC2d+r+0CCh61UJx+qsSO3yHe+JQ@mail.gmail.com>
Subject: [GIT PULL] Move gpio drivers from arch/arm into drivers/gpio
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Joe Perches <joe@perches.com>,
        Kevin Hilman <khilman@ti.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As part of the big cleanup of arch/arm, all of the gpio drivers are
being moved out of arch/arm and into drivers/gpio where they will be
cleaned up and consolidated.  This pull request include a handful of
moves, plus a few other miscellaneous gpio changes that I missed in
the first pull.

g.

The following changes since commit 29a6ccca3869bbe33879dae0cd7df2a1559eff54:

  Merge git://git.infradead.org/mtd-2.6 (2011-05-27 20:06:53 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/next

Ed Wildgoose (1):
      gpio/cs5535: Show explicit dependency between gpio_cs5535 and mfd_cs5535

Grant Likely (2):
      gpio: move Nomadik GPIO driver to drivers/gpio
      Merge branch 'for_2.6.40/gpio-move' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/next

Haojian Zhuang (1):
      gpio/pca953x: Add support for pca9574 and pca9575 devices

Joe Perches (1):
      gpio: Convert gpio_is_valid to return bool

Kevin Hilman (2):
      GPIO: OMAP: move register offset defines into <plat/gpio.h>
      GPIO: OMAP: move to drivers/gpio

Kristen Carlson Accardi (1):
      langwell_gpio: add runtime pm support

Kyungmin Park (4):
      gpio: Move to Samsung common GPIO library to drivers/gpio
      gpio: Move the exynos4 GPIO to drivers/gpio
      gpio: Move the s5pv210 GPIO to drivers/gpio
      gpio: Move the s5pc100 GPIO to drivers/gpio

Lars-Peter Clausen (1):
      gpio: make gpio_{request,free}_array gpio array parameter const

Linus Walleij (1):
      gpio: move U300 GPIO driver to drivers/gpio

Rabin Vincent (1):
      gpio/nomadik: show all pins in debug

Rickard Andersson (1):
      gpio/nomadik: add function to read GPIO pull down status

Tomoya MORINAGA (1):
      gpio/pch_gpio: Support new device ML7223

 arch/arm/mach-exynos4/Makefile                     |    2 +-
 arch/arm/mach-nomadik/Kconfig                      |    1 -
 arch/arm/mach-s5pc100/Makefile                     |    2 +-
 arch/arm/mach-s5pv210/Makefile                     |    2 +-
 arch/arm/mach-u300/Makefile                        |    2 +-
 arch/arm/mach-ux500/Kconfig                        |    1 -
 arch/arm/plat-nomadik/Kconfig                      |    5 -
 arch/arm/plat-nomadik/Makefile                     |    1 -
 arch/arm/plat-nomadik/include/plat/gpio.h          |    2 +
 arch/arm/plat-omap/Makefile                        |    2 +-
 arch/arm/plat-omap/include/plat/gpio.h             |  103 ++++++++
 arch/arm/plat-samsung/Makefile                     |    1 -
 drivers/gpio/Kconfig                               |   34 +++-
 drivers/gpio/Makefile                              |    7 +
 .../gpiolib.c => drivers/gpio/gpio-exynos4.c       |    0
 .../gpio.c => drivers/gpio/gpio-nomadik.c          |   65 +++++-
 .../plat-omap/gpio.c => drivers/gpio/gpio-omap.c   |  105 --------
 .../gpiolib.c => drivers/gpio/gpio-plat-samsung.c  |    0
 .../gpiolib.c => drivers/gpio/gpio-s5pc100.c       |    0
 .../gpiolib.c => drivers/gpio/gpio-s5pv210.c       |    0
 .../mach-u300/gpio.c => drivers/gpio/gpio-u300.c   |    0
 drivers/gpio/gpiolib.c                             |    4 +-
 drivers/gpio/langwell_gpio.c                       |   65 +++++
 drivers/gpio/pca953x.c                             |  249 +++++++++++++++-----
 drivers/gpio/pch_gpio.c                            |    2 +
 include/asm-generic/gpio.h                         |   10 +-
 include/linux/gpio.h                               |    8 +-
 27 files changed, 475 insertions(+), 198 deletions(-)
 rename arch/arm/mach-exynos4/gpiolib.c => drivers/gpio/gpio-exynos4.c (100%)
 rename arch/arm/plat-nomadik/gpio.c => drivers/gpio/gpio-nomadik.c (95%)
 rename arch/arm/plat-omap/gpio.c => drivers/gpio/gpio-omap.c (93%)
 rename arch/arm/plat-samsung/gpiolib.c =>
drivers/gpio/gpio-plat-samsung.c (100%)
 rename arch/arm/mach-s5pc100/gpiolib.c => drivers/gpio/gpio-s5pc100.c (100%)
 rename arch/arm/mach-s5pv210/gpiolib.c => drivers/gpio/gpio-s5pv210.c (100%)
 rename arch/arm/mach-u300/gpio.c => drivers/gpio/gpio-u300.c (100%)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
