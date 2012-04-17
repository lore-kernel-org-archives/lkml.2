Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2DQPqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:46:30 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:48313 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab2DQPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:46:28 -0400
Message-ID: <4F8D9037.9010401@atmel.com>
Date: Tue, 17 Apr 2012 17:45:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] at91: fist cleanup branch for 3.5
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)   

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-3.5-cleanup

for you to fetch changes up to 39ecc143b4c1f3d42e8300e7f5274681b99f95c2:

  ARM: at91: add defconfig for device tree (2012-04-17 14:47:22 +0200)

----------------------------------------------------------------
First batch of AT91 cleanup for 3.5 kernel.
- The biggest improvement of this series is the ability to compile several
  AT91 SoCs in one kernel image.
  For now on it's limited to the DT-enabled boards but we can compile all
  the core together.
- The Kconfig series is stacked before other patches as it is simple and
  non-intrusive. Its goal is to remove too restrictive dependencies on
  SoC names. This will allow to add support for newer SoC seamlessly.
- Some very "cosmetic" Kconfig changes are also added (entry names,
  comments, etc.).

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (10):
      ARM: at91: uncompress Store UART address in a variable
      ARM: at91: uncompress: autodetect the uart to use
      ARM: at91: drop at91_set_serial_console
      ARM: at91: do not pin mux the UARTs in init_early
      ARM: at91: move at91_init_leds to board init
      ARM: at91: pm select memory controler at runtime
      ARM: at91: add SOC_AT91SAM9 kconfig option to factorise select
      ARN: at91: introduce SOC_AT91xxx define to allow to compile SoC core support
      ARM: at91/dt: do not specify the board any more
      ARM: at91: add defconfig for device tree

Nicolas Ferre (9):
      ARM: at91: change AT91 Kconfig entry comment
      ARM: at91/Kconfig: change at91sam9g45 entry
      ARM: at91/Kconfig: add comment to at91sam9x5 family entry
      ARM: at91/Kconfig: add clarifications to AT91SAM9M10G45-EK entry
      ARM: at91/Kconfig: add AT91SAM9x5 family to AT91_EARLY_DBGU0 entry
      ARM: at91/Kconfig: website link for AT91SAM9G20-EK
      rtc: Kconfig: remove dependency for AT91 rtc driver
      Input: Kconfig: remove dependency for atmel_tsadcc driver
      hwrng: Kconfig: remove dependency for atmel-rng driver

 arch/arm/Kconfig                              |    4 +--
 arch/arm/configs/at91_dt_defconfig            |  196 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/configs/at91rm9200_defconfig         |    1 +
 arch/arm/mach-at91/Kconfig                    |  186 +++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------
 arch/arm/mach-at91/Makefile                   |   26 +++++++++-----
 arch/arm/mach-at91/at91rm9200.c               |   12 -------
 arch/arm/mach-at91/at91rm9200_devices.c       |   12 -------
 arch/arm/mach-at91/at91sam9260.c              |   12 -------
 arch/arm/mach-at91/at91sam9260_devices.c      |   12 -------
 arch/arm/mach-at91/at91sam9261.c              |   12 -------
 arch/arm/mach-at91/at91sam9261_devices.c      |   12 -------
 arch/arm/mach-at91/at91sam9263.c              |   12 -------
 arch/arm/mach-at91/at91sam9263_devices.c      |   12 -------
 arch/arm/mach-at91/at91sam9g45.c              |   12 -------
 arch/arm/mach-at91/at91sam9g45_devices.c      |   12 -------
 arch/arm/mach-at91/at91sam9rl.c               |   12 -------
 arch/arm/mach-at91/at91sam9rl_devices.c       |   12 -------
 arch/arm/mach-at91/board-1arm.c               |   24 ++++++-------
 arch/arm/mach-at91/board-afeb-9260v1.c        |   28 +++++++--------
 arch/arm/mach-at91/board-cam60.c              |    8 ++---
 arch/arm/mach-at91/board-carmeva.c            |   18 ++++------
 arch/arm/mach-at91/board-cpu9krea.c           |   52 +++++++++++++--------------
 arch/arm/mach-at91/board-cpuat91.c            |   40 ++++++++++-----------
 arch/arm/mach-at91/board-csb337.c             |   13 +++----
 arch/arm/mach-at91/board-csb637.c             |    8 ++---
 arch/arm/mach-at91/board-dt.c                 |    8 +----
 arch/arm/mach-at91/board-eb9200.c             |   24 ++++++-------
 arch/arm/mach-at91/board-ecbat91.c            |   20 +++++------
 arch/arm/mach-at91/board-eco920.c             |   13 +++----
 arch/arm/mach-at91/board-flexibity.c          |    8 ++---
 arch/arm/mach-at91/board-foxg20.c             |   71 +++++++++++++++++-------------------
 arch/arm/mach-at91/board-gsia18s.c            |   63 ++++++++++++++++----------------
 arch/arm/mach-at91/board-kafa.c               |   20 +++++------
 arch/arm/mach-at91/board-kb9202.c             |   32 ++++++++---------
 arch/arm/mach-at91/board-neocore926.c         |   14 +++-----
 arch/arm/mach-at91/board-pcontrol-g20.c       |   21 ++++++-----
 arch/arm/mach-at91/board-picotux200.c         |   18 ++++------
 arch/arm/mach-at91/board-qil-a9260.c          |   31 +++++++---------
 arch/arm/mach-at91/board-rm9200dk.c           |   24 ++++++-------
 arch/arm/mach-at91/board-rm9200ek.c           |   24 ++++++-------
 arch/arm/mach-at91/board-rsi-ews.c            |   36 +++++++++----------
 arch/arm/mach-at91/board-sam9-l9260.c         |   30 +++++++---------
 arch/arm/mach-at91/board-sam9260ek.c          |   24 ++++++-------
 arch/arm/mach-at91/board-sam9261ek.c          |   14 +++-----
 arch/arm/mach-at91/board-sam9263ek.c          |   14 +++-----
 arch/arm/mach-at91/board-sam9g20ek.c          |   24 ++++++-------
 arch/arm/mach-at91/board-sam9m10g45ek.c       |   16 ++++-----
 arch/arm/mach-at91/board-sam9rlek.c           |   14 +++-----
 arch/arm/mach-at91/board-snapper9260.c        |   18 +++++-----
 arch/arm/mach-at91/board-stamp9g20.c          |   64 +++++++++++++--------------------
 arch/arm/mach-at91/board-usb-a926x.c          |    8 ++---
 arch/arm/mach-at91/board-yl-9200.c            |   36 +++++++++----------
 arch/arm/mach-at91/cpuidle.c                  |    8 ++++-
 arch/arm/mach-at91/generic.h                  |   11 ------
 arch/arm/mach-at91/include/mach/at91rm9200.h  |    5 ---
 arch/arm/mach-at91/include/mach/at91sam9260.h |    7 ----
 arch/arm/mach-at91/include/mach/at91sam9261.h |    4 ---
 arch/arm/mach-at91/include/mach/at91sam9263.h |    4 ---
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    5 ---
 arch/arm/mach-at91/include/mach/at91sam9rl.h  |    5 ---
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |    8 -----
 arch/arm/mach-at91/include/mach/board.h       |    1 -
 arch/arm/mach-at91/include/mach/cpu.h         |   28 ++++++---------
 arch/arm/mach-at91/include/mach/hardware.h    |   16 ++-------
 arch/arm/mach-at91/include/mach/uncompress.h  |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 arch/arm/mach-at91/pm.c                       |   12 ++++---
 arch/arm/mach-at91/pm.h                       |   15 +-------
 arch/arm/mach-at91/pm_slowclock.S             |    2 +-
 arch/arm/mach-at91/soc.h                      |   14 ++++----
 drivers/char/hw_random/Kconfig                |    2 +-
 drivers/input/touchscreen/Kconfig             |    4 +--
 drivers/rtc/Kconfig                           |    2 +-
 72 files changed, 862 insertions(+), 906 deletions(-)
 create mode 100644 arch/arm/configs/at91_dt_defconfig

Thanks, best regards,
-- 
Nicolas Ferre
