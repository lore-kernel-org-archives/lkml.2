Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2LLKZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:25:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50685 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2LLKZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:25:36 -0500
Date: Wed, 12 Dec 2012 02:22:07 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20121212102206.GA13858@lizard>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here are a few updates and new drivers queued for v3.8. All the patches
were sitting in the -next tree for awhile, except for the last merge
commit -- I made it a few hours ago just to fix some conflicts, so that
you won't have to bother.

Highlights for this pull:

- Two new drivers from Pali Rohár and N900 hackers: rx51_battery and
  bq2415x_charger. The drivers are a part of a solution to replace the
  proprietary Nokia BME stack;

- Power supply core now registers devices with a thermal cooling
  subsystem, so we can now automatically throttle charging. Thanks to
  Ramakrishna Pallala!

- Device tree support for ab8500 and max8925_power drivers;

- Random fixups and enhancements for a bunch of drivers.

Thanks!


The following changes since commit 1ebaf4f4e6912199f8a4e30ba3ab55da2b71bcdf:

  Merge branch 'x86-timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-12-11 20:01:33 -0800)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.8-merged

for you to fetch changes up to 76d8a23b127020472207b281427d3e9f4f1227e4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux (2012-12-11 22:15:57 -0800)

----------------------------------------------------------------
Alan Cox (1):
      max17042_battery: Fix missing verify_model_lock() return value check

Anton Vorontsov (3):
      bq2415x_charger: Add Kconfig/Makefile entries
      bq2415x_charger: Fix style issues
      Merge git://git.kernel.org/.../torvalds/linux

Axel Lin (1):
      generic-adc-battery: Fix checking return value of request_any_context_irq

Dan Carpenter (2):
      generic-adc-battery: Pointer math issue in gab_probe()
      ds2782_battery: Fix signedness bug in ds278x_read_reg16()

Kim, Milo (3):
      lp8788-charger: Use consumer device name on setting IIO channels
      lp8788-charger: Fix wrong ADC conversion
      lp8788-charger: Fix ADC channel names

Marcos Paulo de Souza (2):
      jz4740-battery: Use devm_kzalloc
      jz4740-battery: Use devm_request_and_ioremap

Pali Rohár (3):
      power_supply: Add new Nokia RX-51 (N900) power supply battery driver
      power_supply: Add bq2415x charger driver
      bq27x00_battery: Fixup nominal available capacity reporting

Peter Ujfalusi (1):
      twl4030_charger: Change TWL4030_MODULE_* ids to TWL_MODULE_*

Qing Xu (1):
      max8925_power: Add support for device-tree initialization

Rajanikanth H.V (4):
      ab8500: Add devicetree support for fuelgauge
      ab8500: Add devicetree support for btemp
      ab8500: Add devicetree support for charger
      ab8500: Add devicetree support for chargalg

Ramakrishna Pallala (2):
      power_supply: Add support for CHARGE_CONTROL_* attributes
      power_supply: Register power supply for thermal cooling device

 Documentation/devicetree/bindings/mfd/ab8500.txt                 |   27 +-
 Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt  |   16 +
 .../devicetree/bindings/power_supply/ab8500/chargalg.txt         |   16 +
 .../devicetree/bindings/power_supply/ab8500/charger.txt          |   25 +
 Documentation/devicetree/bindings/power_supply/ab8500/fg.txt     |   58 +
 Documentation/power/power_supply_class.txt                       |    3 +
 arch/arm/boot/dts/dbx5x0.dtsi                                    |   28 +-
 drivers/mfd/ab8500-core.c                                        |   20 +
 drivers/power/Kconfig                                            |   23 +-
 drivers/power/Makefile                                           |    4 +-
 drivers/power/ab8500_bmdata.c                                    |  521 +++++++++
 drivers/power/ab8500_btemp.c                                     |   77 +-
 drivers/power/ab8500_charger.c                                   |   84 +-
 drivers/power/ab8500_fg.c                                        |   82 +-
 drivers/power/abx500_chargalg.c                                  |   56 +-
 drivers/power/bq2415x_charger.c                                  | 1670 ++++++++++++++++++++++++++++
 drivers/power/bq27x00_battery.c                                  |    8 +
 drivers/power/ds2782_battery.c                                   |    4 +-
 drivers/power/generic-adc-battery.c                              |    5 +-
 drivers/power/jz4740-battery.c                                   |   45 +-
 drivers/power/lp8788-charger.c                                   |   75 +-
 drivers/power/max17042_battery.c                                 |    3 +-
 drivers/power/max8925_power.c                                    |   51 +-
 drivers/power/power_supply_core.c                                |   96 ++
 drivers/power/power_supply_sysfs.c                               |    2 +
 drivers/power/rx51_battery.c                                     |  251 +++++
 drivers/power/twl4030_charger.c                                  |   12 +-
 include/linux/mfd/abx500.h                                       |   34 +-
 include/linux/mfd/lp8788.h                                       |    8 +-
 include/linux/power/bq2415x_charger.h                            |   95 ++
 include/linux/power_supply.h                                     |    3 +
 31 files changed, 3123 insertions(+), 279 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/chargalg.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/charger.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
 create mode 100644 drivers/power/ab8500_bmdata.c
 create mode 100644 drivers/power/bq2415x_charger.c
 create mode 100644 drivers/power/rx51_battery.c
 create mode 100644 include/linux/power/bq2415x_charger.h
