Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab0JZUTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:19:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33825 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab0JZUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:19:14 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 00/12] tnetv107x ssp driver stack
Date: Tue, 26 Oct 2010 16:18:16 -0400
Message-Id: <1288124308-14999-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
device.  It has a built-in programmable execution engine that can be programmed
to operate as almost any serial bus (I2C, SPI, EasyScale, and others).

This patch series implements a driver stack that looks like the following:

                             +--------+
                             | eeprom | . . .
                             +--------+
   +-----------+             +--------------+ +---------+
   | regulator | . . .       |   i2c-gpio   | | 1-wire  | . . .
   +-----------+             +--------------+ +---------+
   +----------------------+  +--------------------------------+
   |       ssp-spi        |  |           ssp-gpio             |
   +----------------------+  +--------------------------------+
   +----------------------------------------------------------+
   |                            ssp                           |
   +----------------------------------------------------------+

Changes between v3 and v4 of this series:
  - Replaced polled wait for sequence termination with interrupt
  - Improved locking within SSP driver
  - Other minor cleanups

Changes between v2 and v3 of this series:
  - Minor cleanups in Kconfig and Makefile ordering

Changes between v1 and v2 of this series:
  - Replaced open()/close() semantics with dynamic platform_device
    registration on SSP probe.
  - Removed user-land interface to regulator registers
  - More sensible regulator constraints
  - Other minor cleanups

Cyril Chemparathy (12):
  misc: add driver for sequencer serial port
  davinci: add tnetv107x ssp platform device
  davinci: add ssp config for tnetv107x evm board
  spi: add ti-ssp spi master driver
  davinci: add spi devices on tnetv107x evm
  regulator: add driver for tps6524x regulator
  davinci: add tnetv107x evm regulators
  gpio: add ti-ssp gpio driver
  davinci: add tnetv107x evm ti-ssp gpio device
  backlight: add support for tps6116x controller
  davinci: add tnetv107x evm backlight device
  davinci: add tnetv107x evm i2c eeprom device

 arch/arm/mach-davinci/board-tnetv107x-evm.c    |  199 +++++++
 arch/arm/mach-davinci/devices-tnetv107x.c      |   25 +
 arch/arm/mach-davinci/include/mach/ti_ssp.h    |   98 ++++
 arch/arm/mach-davinci/include/mach/tnetv107x.h |    2 +
 arch/arm/mach-davinci/tnetv107x.c              |    2 +-
 drivers/gpio/Kconfig                           |   10 +
 drivers/gpio/Makefile                          |    1 +
 drivers/gpio/ti-ssp-gpio.c                     |  200 +++++++
 drivers/misc/Kconfig                           |   10 +
 drivers/misc/Makefile                          |    1 +
 drivers/misc/ti_ssp.c                          |  492 +++++++++++++++++
 drivers/regulator/Kconfig                      |   10 +
 drivers/regulator/Makefile                     |    1 +
 drivers/regulator/tps6524x-regulator.c         |  692 ++++++++++++++++++++++++
 drivers/spi/Kconfig                            |    7 +
 drivers/spi/Makefile                           |    1 +
 drivers/spi/spi_ti_ssp.c                       |  396 ++++++++++++++
 drivers/video/backlight/Kconfig                |    7 +
 drivers/video/backlight/Makefile               |    2 +-
 drivers/video/backlight/tps6116x.c             |  340 ++++++++++++
 20 files changed, 2494 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/ti_ssp.h
 create mode 100644 drivers/gpio/ti-ssp-gpio.c
 create mode 100644 drivers/misc/ti_ssp.c
 create mode 100644 drivers/regulator/tps6524x-regulator.c
 create mode 100644 drivers/spi/spi_ti_ssp.c
 create mode 100644 drivers/video/backlight/tps6116x.c

