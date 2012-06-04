Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2FDHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:25:56 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53575 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2FDHZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:25:54 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 4 Jun 2012 15:25:33 +0800
X-Google-Sender-Auth: D2XuGVk6AMqDVzfB0rxwmlrdURA
Message-ID: <CAK5ve-JuZcjdbw_tV8vcriHWxOq1KFHm2mZBm6z3_j7hpPw-eA@mail.gmail.com>
Subject: [GIT PULL] LED CPU trigger driver and ARM LED code consolidation
To: Arnd Bergmann <arnd.bergmann@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

Please consider to pull my branch for LED CPU trigger driver and ARM
LED code consolidation, which is based on 3.5-rc1:

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
for-arm-soc

for you to fetch changes up to ea19d193ef750c09cd789cc3b00196f07ce2209f:

  ARM: use new LEDS CPU trigger stub to replace old one (2012-06-04
08:50:01 +0800)

----------------------------------------------------------------
Bryan Wu (18):
      led-triggers: create a trigger for CPU activity
      ARM: at91: convert old leds drivers to gpio_led and led_trigger drivers
      ARM: mach-realview and mach-versatile: retire custom LED code
      ARM: mach-ks8695: remove leds driver, since nobody use it
      ARM: mach-shark: retire custom LED code
      ARM: mach-orion5x: convert custom LED code to gpio_led and LED CPU trigger
      ARM: mach-integrator: move CM_CTRL to header file for accessing
by other functions
      ARM: mach-integrator: retire custom LED code
      ARM: mach-clps711x: retire custom LED code of P720T machine
      ARM: mach-ebsa110: retire custom LED code
      ARM: mach-footbridge: retire custom LED code
      char: nwflash: remove old led event code
      ARM: mach-pxa: retire custom LED code
      ARM: plat-samsung: remove including old leds event API header file
      ARM: mach-pnx4008: remove including old leds event API header file
      ARM: mach-omap1: retire custom LED code
      ARM: mach-sa1100: retire custom LED code
      ARM: use new LEDS CPU trigger stub to replace old one

 arch/arm/Kconfig                             |   53 -----
 arch/arm/include/asm/leds.h                  |   50 -----
 arch/arm/kernel/Makefile                     |    1 -
 arch/arm/kernel/leds.c                       |  121 -----------
 arch/arm/kernel/process.c                    |    6 +-
 arch/arm/kernel/time.c                       |   17 --
 arch/arm/mach-at91/board-csb337.c            |    2 -
 arch/arm/mach-at91/board-ecbat91.c           |   18 +-
 arch/arm/mach-at91/board-eco920.c            |   22 +-
 arch/arm/mach-at91/board-kafa.c              |   17 +-
 arch/arm/mach-at91/board-kb9202.c            |   23 +-
 arch/arm/mach-at91/board-rm9200dk.c          |    3 -
 arch/arm/mach-at91/board-rm9200ek.c          |    3 -
 arch/arm/mach-at91/board-rsi-ews.c           |    3 -
 arch/arm/mach-at91/board-sam9-l9260.c        |   23 +-
 arch/arm/mach-at91/board-sam9261ek.c         |    3 -
 arch/arm/mach-at91/board-yl-9200.c           |    3 -
 arch/arm/mach-at91/include/mach/board.h      |    1 -
 arch/arm/mach-at91/leds.c                    |  105 ---------
 arch/arm/mach-clps711x/Makefile              |    2 -
 arch/arm/mach-clps711x/common.c              |    1 -
 arch/arm/mach-clps711x/p720t-leds.c          |   63 ------
 arch/arm/mach-clps711x/p720t.c               |   61 ++++++
 arch/arm/mach-ebsa110/Makefile               |    4 +-
 arch/arm/mach-ebsa110/leds.c                 |   81 ++++---
 arch/arm/mach-footbridge/Makefile            |    4 -
 arch/arm/mach-footbridge/ebsa285-leds.c      |  138 ------------
 arch/arm/mach-footbridge/ebsa285.c           |   81 +++++++
 arch/arm/mach-footbridge/netwinder-hw.c      |  112 ++++++++--
 arch/arm/mach-footbridge/netwinder-leds.c    |  138 ------------
 arch/arm/mach-integrator/Makefile            |    3 +-
 arch/arm/mach-integrator/core.c              |    3 -
 arch/arm/mach-integrator/include/mach/cm.h   |    2 +
 arch/arm/mach-integrator/leds.c              |  161 ++++++++------
 arch/arm/mach-ks8695/Makefile                |    3 -
 arch/arm/mach-ks8695/devices.c               |   21 --
 arch/arm/mach-ks8695/include/mach/devices.h  |    5 -
 arch/arm/mach-ks8695/leds.c                  |   92 --------
 arch/arm/mach-omap1/Makefile                 |    8 -
 arch/arm/mach-omap1/board-h2.c               |   32 +++
 arch/arm/mach-omap1/board-h3.c               |   32 +++
 arch/arm/mach-omap1/board-osk.c              |   33 +++
 arch/arm/mach-omap1/leds-h2p2-debug.c        |  166 ---------------
 arch/arm/mach-omap1/leds-innovator.c         |   98 ---------
 arch/arm/mach-omap1/leds-osk.c               |  113 ----------
 arch/arm/mach-omap1/leds.c                   |   69 ------
 arch/arm/mach-omap1/leds.h                   |    3 -
 arch/arm/mach-omap1/time.c                   |    1 -
 arch/arm/mach-omap1/timer32k.c               |    1 -
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c |    1 -
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c  |    1 -
 arch/arm/mach-orion5x/rd88f5182-setup.c      |   72 ++-----
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c |    1 -
 arch/arm/mach-pnx4008/time.c                 |    1 -
 arch/arm/mach-pxa/Makefile                   |    8 -
 arch/arm/mach-pxa/idp.c                      |   81 +++++++
 arch/arm/mach-pxa/leds-idp.c                 |  115 ----------
 arch/arm/mach-pxa/leds-lubbock.c             |  124 -----------
 arch/arm/mach-pxa/leds-mainstone.c           |  119 -----------
 arch/arm/mach-pxa/leds.c                     |   32 ---
 arch/arm/mach-pxa/leds.h                     |   13 --
 arch/arm/mach-pxa/lubbock.c                  |   95 +++++++++
 arch/arm/mach-pxa/mainstone.c                |   94 +++++++++
 arch/arm/mach-realview/core.c                |   39 ----
 arch/arm/mach-realview/core.h                |    2 -
 arch/arm/mach-realview/realview_eb.c         |    5 -
 arch/arm/mach-realview/realview_pb1176.c     |    5 -
 arch/arm/mach-realview/realview_pb11mp.c     |    5 -
 arch/arm/mach-realview/realview_pba8.c       |    5 -
 arch/arm/mach-realview/realview_pbx.c        |    5 -
 arch/arm/mach-sa1100/Makefile                |    9 -
 arch/arm/mach-sa1100/assabet.c               |   85 ++++++++
 arch/arm/mach-sa1100/badge4.c                |   30 +++
 arch/arm/mach-sa1100/cerf.c                  |   42 ++++
 arch/arm/mach-sa1100/hackkit.c               |   32 +++
 arch/arm/mach-sa1100/lart.c                  |   26 +++
 arch/arm/mach-sa1100/leds-assabet.c          |  113 ----------
 arch/arm/mach-sa1100/leds-badge4.c           |  110 ----------
 arch/arm/mach-sa1100/leds-cerf.c             |  109 ----------
 arch/arm/mach-sa1100/leds-hackkit.c          |  111 ----------
 arch/arm/mach-sa1100/leds-lart.c             |  100 ---------
 arch/arm/mach-sa1100/leds.c                  |   50 -----
 arch/arm/mach-sa1100/leds.h                  |   13 --
 arch/arm/mach-shark/Makefile                 |    4 +-
 arch/arm/mach-shark/core.c                   |    1 -
 arch/arm/mach-shark/leds.c                   |  220 ++++++++-----------
 arch/arm/mach-versatile/core.c               |    5 -
 arch/arm/plat-omap/Kconfig                   |    3 +-
 arch/arm/plat-omap/debug-leds.c              |  293 ++++++--------------------
 arch/arm/plat-samsung/time.c                 |    1 -
 arch/arm/plat-versatile/Kconfig              |    4 +-
 arch/arm/plat-versatile/leds.c               |   13 +-
 drivers/char/nwflash.c                       |   34 ---
 drivers/leds/Kconfig                         |   10 +
 drivers/leds/Makefile                        |    1 +
 drivers/leds/ledtrig-cpu.c                   |  163 ++++++++++++++
 include/linux/leds.h                         |   16 ++
 97 files changed, 1445 insertions(+), 2981 deletions(-)
 delete mode 100644 arch/arm/include/asm/leds.h
 delete mode 100644 arch/arm/kernel/leds.c
 delete mode 100644 arch/arm/mach-clps711x/p720t-leds.c
 delete mode 100644 arch/arm/mach-footbridge/ebsa285-leds.c
 delete mode 100644 arch/arm/mach-footbridge/netwinder-leds.c
 delete mode 100644 arch/arm/mach-ks8695/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds-h2p2-debug.c
 delete mode 100644 arch/arm/mach-omap1/leds-innovator.c
 delete mode 100644 arch/arm/mach-omap1/leds-osk.c
 delete mode 100644 arch/arm/mach-omap1/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds.h
 delete mode 100644 arch/arm/mach-pxa/leds-idp.c
 delete mode 100644 arch/arm/mach-pxa/leds-lubbock.c
 delete mode 100644 arch/arm/mach-pxa/leds-mainstone.c
 delete mode 100644 arch/arm/mach-pxa/leds.c
 delete mode 100644 arch/arm/mach-pxa/leds.h
 delete mode 100644 arch/arm/mach-sa1100/leds-assabet.c
 delete mode 100644 arch/arm/mach-sa1100/leds-badge4.c
 delete mode 100644 arch/arm/mach-sa1100/leds-cerf.c
 delete mode 100644 arch/arm/mach-sa1100/leds-hackkit.c
 delete mode 100644 arch/arm/mach-sa1100/leds-lart.c
 delete mode 100644 arch/arm/mach-sa1100/leds.c
 delete mode 100644 arch/arm/mach-sa1100/leds.h
 create mode 100644 drivers/leds/ledtrig-cpu.c

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
