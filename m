Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab1D0NNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:13:18 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:59360 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759118Ab1D0NNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:13:16 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 00/10] U300 and Ux500 GPIO consolidation patch set
Date: Wed, 27 Apr 2011 15:12:23 +0200
Message-ID: <1303909943-3261-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is the latest incarnation of the GPIO consolidation patch set
which will not be pushed to my -next tree. If maintainer prefer
that I squash patches rather than stack them in logical steps
like this then tell me.

Since it deletes a whopping ~2000 lines from arch/arm/* it looks
like a viable target for the 2.6.40 merge window.

ACKs requested for the drivers/gpio/* stuff primarily.

Fredrik Svensson (1):
  plat-nomadik: remove pull-pinconfig and add SPI2

Linus Walleij (6):
  gpio: add a custom configuration mechanism to gpiolib
  mach-u300: rewrite gpio driver, move to drivers/gpio
  gpio: move the Nomadik GPIO driver to drivers/gpio
  gpio/nomadik-gpio: work with all machines
  gpio/nomadik-gpio: factor out state cast function
  gpio/nomadik-gpio: merge pinconfig API

Rabin Vincent (2):
  plat-nomadik: gpio show all pins in debug
  plat-nomadik: disable clocks when unused

Rickard Andersson (1):
  plat-nomadik: add function to read GPIO pull down status

 arch/arm/Kconfig                                   |    2 +-
 arch/arm/mach-nomadik/Kconfig                      |    2 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    3 +-
 arch/arm/mach-nomadik/cpu-8815.c                   |    1 +
 arch/arm/mach-nomadik/i2c-8815nhk.c                |   14 +-
 arch/arm/mach-nomadik/include/mach/gpio.h          |    8 +-
 arch/arm/mach-u300/Kconfig                         |    1 +
 arch/arm/mach-u300/Makefile                        |    6 +-
 arch/arm/mach-u300/core.c                          |   31 +-
 arch/arm/mach-u300/gpio.c                          |  700 ----------------
 arch/arm/mach-u300/include/mach/gpio.h             |  163 +----
 arch/arm/mach-u300/include/mach/irqs.h             |   25 +-
 arch/arm/mach-ux500/Kconfig                        |    2 +-
 arch/arm/mach-ux500/board-mop500-pins.c            |    3 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |    1 +
 arch/arm/mach-ux500/board-u5500-sdi.c              |    3 +-
 arch/arm/mach-ux500/cpu-db5500.c                   |    3 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |    5 +-
 arch/arm/mach-ux500/devices-common.c               |    3 +-
 arch/arm/mach-ux500/include/mach/gpio.h            |    8 +-
 arch/arm/mach-ux500/pins-db5500.h                  |    2 +
 arch/arm/mach-ux500/pins-db8500.h                  |  144 ++--
 arch/arm/plat-nomadik/Kconfig                      |    5 -
 arch/arm/plat-nomadik/Makefile                     |    1 -
 arch/arm/plat-nomadik/include/plat/gpio.h          |   93 ---
 arch/arm/plat-nomadik/include/plat/pincfg.h        |  144 ----
 drivers/gpio/Kconfig                               |   17 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpiolib.c                             |   28 +
 .../gpio.c => drivers/gpio/nomadik-gpio.c          |  857 +++++++++++---------
 drivers/gpio/u300-gpio.c                           |  836 +++++++++++++++++++
 include/asm-generic/gpio.h                         |    8 +-
 include/linux/gpio.h                               |   61 ++
 include/linux/gpio/nomadik.h                       |  291 +++++++
 include/linux/gpio/u300.h                          |   32 +
 35 files changed, 1922 insertions(+), 1583 deletions(-)
 delete mode 100644 arch/arm/mach-u300/gpio.c
 delete mode 100644 arch/arm/plat-nomadik/include/plat/gpio.h
 delete mode 100644 arch/arm/plat-nomadik/include/plat/pincfg.h
 rename arch/arm/plat-nomadik/gpio.c => drivers/gpio/nomadik-gpio.c (57%)
 create mode 100644 drivers/gpio/u300-gpio.c
 create mode 100644 include/linux/gpio/nomadik.h
 create mode 100644 include/linux/gpio/u300.h

-- 
1.7.3.2

