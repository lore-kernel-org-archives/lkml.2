Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1H2JL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 05:11:26 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:39254 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab1H2JLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 05:11:14 -0400
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
Subject: [PATCH 0/4 v5] pin controller subsystem v5
Date: Mon, 29 Aug 2011 11:09:49 +0200
Message-ID: <1314608989-28015-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is the fifth iteration of the controller subsystem, most
changes are described in the first patch, copied here for reference:

ChangeLog v4->v5:

- Defined a "position" for each function, so the pin controller now
  tracks a function in a certain position, and the pinmux maps define
  what position you want the function in. (Feedback from Stephen
  Warren and Sascha Hauer).

- Since we now need to request a combined function+position from
  the machine mapping table that connect mux settings to drivers,
  it was extended with a position field and a name field. The
  name field is now used if you e.g. need to switch between two
  mux map settings at runtime.

- Switched from a class device to using struct bus_type for this
  subsystem. Verified sysfs functionality: seems to work fine.
  (Feedback from Arnd Bergmann and Greg Kroah-Hartman)

- Define a per pincontroller list of GPIO ranges from the GPIO
  pin space that can be handled by the pin controller. These can
  be added one by one at runtime. (Feedback from Barry Song)

- Expanded documentation of regulator_[get|enable|disable|put]
  semantics.

- Fixed a number of review comments from Barry Song. (Thanks!)

Linus Walleij (4):
  drivers: create a pin control subsystem v5
  pinmux: add a driver for the U300 pinmux
  amba: request muxing for PrimeCell devices
  mach-u300: activate pinmux driver, delete old padmux driver

 Documentation/ABI/testing/sysfs-class-pinmux |   11 +
 Documentation/pinctrl.txt                    |  687 ++++++++++++++++++++
 MAINTAINERS                                  |    5 +
 arch/arm/mach-u300/Kconfig                   |    2 +
 arch/arm/mach-u300/Makefile                  |    2 +-
 arch/arm/mach-u300/core.c                    |   38 +-
 arch/arm/mach-u300/include/mach/syscon.h     |  136 ----
 arch/arm/mach-u300/mmc.c                     |   16 -
 arch/arm/mach-u300/padmux.c                  |  367 -----------
 arch/arm/mach-u300/padmux.h                  |   39 --
 arch/arm/mach-u300/regulator.c               |   16 +
 arch/arm/mach-u300/spi.c                     |   20 -
 drivers/Kconfig                              |    4 +
 drivers/Makefile                             |    2 +
 drivers/amba/bus.c                           |   49 ++-
 drivers/pinctrl/Kconfig                      |   36 +
 drivers/pinctrl/Makefile                     |    7 +
 drivers/pinctrl/core.c                       |  539 ++++++++++++++++
 drivers/pinctrl/core.h                       |   24 +
 drivers/pinctrl/pinmux-u300.c                |  883 ++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-u300.h                |  141 ++++
 drivers/pinctrl/pinmux.c                     |  811 +++++++++++++++++++++++
 drivers/pinctrl/pinmux.h                     |    4 +
 include/linux/amba/bus.h                     |    2 +
 include/linux/pinctrl/machine.h              |   74 +++
 include/linux/pinctrl/pinctrl.h              |  143 +++++
 include/linux/pinctrl/pinmux.h               |  135 ++++
 27 files changed, 3610 insertions(+), 583 deletions(-)
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

