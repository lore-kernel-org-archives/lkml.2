Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1IAJc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:32:57 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:60079 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783Ab1IAJcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:32:55 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Cc: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] pin controller subsystem v6
Date: Thu, 1 Sep 2011 11:31:22 +0200
Message-ID: <1314869482-5445-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is the sixth iteration of the controller subsystem, most
changes are described in the first patch, copied here for reference:

ChangeLog v5->v6:

- Create an abstract pin group concept that can sort pins into
  named and enumerated groups no matter what the use of these
  groups may be, one possible usecase is a group of pins being
  muxed in or so. The intention is however to also use these
  groups for other pin control activities.

- Make it compulsory for pinmux functions to associate with
  at least one group, so the abstract pin group concept is used
  to define the groups of pins affected by a pinmux function.
  The pinmux driver interface has been altered so as to enforce
  a function to list applicable groups per function.

- Provide an optional .group entry in the pinmux machine map
  so the map can select beteween different available groups
  to be used with a certain function.

- Consequent changes all over the place so that e.g. debugfs
  present reasonable information about the world.

- Drop the per-pin mux (*config) function in the pinmux_ops
  struct - I was afraid that this would start to be used for
  things totally unrelated to muxing, we can introduce that to
  the generic struct pinctrl_ops if needed. I want to keep
  muxing orthogonal to other pin control subjects and not mix
  these things up.

Linus Walleij (4):
  drivers: create a pin control subsystem v6
  pinmux: add a driver for the U300 pinmux
  amba: request muxing for PrimeCell devices
  mach-u300: activate pinmux driver, delete old padmux driver

 Documentation/ABI/testing/sysfs-class-pinmux |   11 +
 Documentation/pinctrl.txt                    |  876 ++++++++++++++++++++++++
 MAINTAINERS                                  |    5 +
 arch/arm/mach-u300/Kconfig                   |    2 +
 arch/arm/mach-u300/Makefile                  |    2 +-
 arch/arm/mach-u300/core.c                    |   38 +-
 arch/arm/mach-u300/include/mach/syscon.h     |  136 ----
 arch/arm/mach-u300/mmc.c                     |   16 -
 arch/arm/mach-u300/padmux.c                  |  367 ----------
 arch/arm/mach-u300/padmux.h                  |   39 --
 arch/arm/mach-u300/regulator.c               |   16 +
 arch/arm/mach-u300/spi.c                     |   20 -
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/amba/bus.c                           |   49 ++-
 drivers/pinctrl/Kconfig                      |   36 +
 drivers/pinctrl/Makefile                     |    7 +
 drivers/pinctrl/core.c                       |  599 +++++++++++++++++
 drivers/pinctrl/core.h                       |   24 +
 drivers/pinctrl/pinmux-u300.c                |  931 ++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-u300.h                |  141 ++++
 drivers/pinctrl/pinmux.c                     |  822 +++++++++++++++++++++++
 drivers/pinctrl/pinmux.h                     |    4 +
 include/linux/amba/bus.h                     |    2 +
 include/linux/pinctrl/machine.h              |   73 ++
 include/linux/pinctrl/pinctrl.h              |  172 +++++
 include/linux/pinctrl/pinmux.h               |  124 ++++
 27 files changed, 3935 insertions(+), 583 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-pinmux
 create mode 100644 Documentation/pinctrl.txt
 delete mode 100644 arch/arm/mach-u300/padmux.c
 delete mode 100644 arch/arm/mach-u300/padmux.h
 create mode 100644 drivers/pinctrl/Kconfig
 create mode 100644 drivers/pinctrl/Makefile
 create mode 100644 drivers/pinctrl/core.c
 create mode 100644 drivers/pinctrl/core.h
 create mode 100644 drivers/pinctrl/pinmux-u300.c
 create mode 100644 drivers/pinctrl/pinmux-u300.h
 create mode 100644 drivers/pinctrl/pinmux.c
 create mode 100644 drivers/pinctrl/pinmux.h
 create mode 100644 include/linux/pinctrl/machine.h
 create mode 100644 include/linux/pinctrl/pinctrl.h
 create mode 100644 include/linux/pinctrl/pinmux.h

-- 
1.7.3.2

