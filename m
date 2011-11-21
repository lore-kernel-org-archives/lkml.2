Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1KUTsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:48:05 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:48720 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab1KUTsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:48:03 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/8] Third pinconfig patches, with example
Date: Mon, 21 Nov 2011 20:47:37 +0100
Message-ID: <1321904857-32245-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is a third iteration of the pinconfig patchset, including a
practical example of how I convert the U300 COH 901XXX GPIO driver
to use it alongside the existing pinmux-u300 driver. In this case
the pinmux driver can move things around but only the GPIO driver
can alter bias and drive mode, so they are working closely on the
same hardware and are thusly set to live in the same subsystem.

Linus Walleij (8):
  pinctrl: add a generic pin config interface
  ARM: u300: localize GPIO assignments
  pinctrl: move the U300 GPIO driver to pinctrl
  pinctrl: u300-pinmux: register proper GPIO ranges
  pinctrl: COH901XXX: driver to request its pins
  pinctrl: COH901XXX: probe the driver from pinmux
  pinctrl: COH901XXX: use pinconf enums and parameters
  pinctrl: support pinconfig on the U300

 Documentation/pinctrl.txt                          |  105 ++++++-
 arch/arm/mach-u300/Kconfig                         |    2 +-
 arch/arm/mach-u300/core.c                          |    8 +
 arch/arm/mach-u300/include/mach/gpio-u300.h        |  115 ------
 arch/arm/mach-u300/include/mach/irqs.h             |    2 +-
 arch/arm/mach-u300/mmc.c                           |    2 +-
 arch/arm/mach-u300/u300-gpio.h                     |  114 ++++++
 drivers/gpio/Kconfig                               |    9 -
 drivers/gpio/Makefile                              |    1 -
 drivers/pinctrl/Kconfig                            |   15 +-
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/core.c                             |   19 +
 drivers/pinctrl/core.h                             |   10 +
 drivers/pinctrl/pinconf.c                          |  366 ++++++++++++++++++++
 drivers/pinctrl/pinconf.h                          |   41 +++
 .../gpio-u300.c => pinctrl/pinctrl-coh901xxx.c}    |  136 ++++----
 drivers/pinctrl/pinctrl-coh901xxx.h                |    8 +
 drivers/pinctrl/pinmux-u300.c                      |  123 ++++++-
 include/linux/pinctrl/pinconf.h                    |  209 +++++++++++
 include/linux/pinctrl/pinctrl.h                    |   10 +-
 20 files changed, 1080 insertions(+), 217 deletions(-)
 create mode 100644 arch/arm/mach-u300/u300-gpio.h
 create mode 100644 drivers/pinctrl/pinconf.c
 create mode 100644 drivers/pinctrl/pinconf.h
 rename drivers/{gpio/gpio-u300.c => pinctrl/pinctrl-coh901xxx.c} (90%)
 create mode 100644 drivers/pinctrl/pinctrl-coh901xxx.h
 create mode 100644 include/linux/pinctrl/pinconf.h

-- 
1.7.3.2

