Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2AKAbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:31:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42869 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2AKAbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:31:43 -0500
Date: Wed, 11 Jan 2012 04:31:34 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Donggeun Kim <dg77.kim@samsung.com>, pali.rohar@gmail.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        broonie@opensource.wolfsonmicro.com, lars@metafoo.de, pavel@ucw.cz,
        Jiri Kosina <jkosina@suse.cz>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20120111003134.GA24256@oksana.dev.rtsoft.ru>
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

Please pull battery-2.6.git tree to receive changes prepared for 3.3.

Highlights:

- Now we have a full fledged charger manager, implemented by Samsung
  folks. This manager monitors battery charge and health, even when
  machine suspended! RTC wake-up is used to bring kernel [partially]
  back to life periodically.

  This new awesome charger manager, hopefully, will start replacing
  bunch of proprietary charger managers that are used in embedded
  devices today (e.g. BME in Nokia N900).

- New 'scope' property for power supplies. The property is used to
  distinguish between system vs. devices' power supplies (think of
  wireless keyboard/mice/tablet battery monitors); The support is
  already implemented for Wacom and Nintendo Wiimote devices;

- National/TI LP8727 charger driver;

- Work has been started to bring drivers/power/ and ACPI SBS battery
  code closer, and hopefully merge the code bases some day;

- Lots of small fixes here and there.

Note that changes that touch anything outside of driver/power were
acked by appropriate maintainers: MFD changes were acked by Samuel
Ortiz; HID changes were acked by Jiri Kosina and ARM changes were
acked by Tony Lindgren.

Thanks!

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.infradead.org/battery-2.6.git master

Anton Vorontsov (7):
      olpc_battery: Fix section mismatch noise
      olpc_battery: Remove unneeded 'olpc_battery_trigger_uevent'
      Merge tag 'v3.1' from git://git.kernel.org/.../torvalds/linux.git into master
      Merge branch 'power-supply-scope' of git://git.kernel.org/.../jeremy/xen
      power_supply: Drop usage of nowarn variant of sysfs_create_link()
      power_supply: Mark da9052 driver as broken
      Merge git://git.infradead.org/users/cbou/battery-urgent

Ashish Jangam (1):
      power_supply: Add DA9052 battery driver

Axel Lin (10):
      max8997_charger&max8998_charger: Fix unterminated platform_device_id tables
      max8903_charger: Add "platform:" prefix for platform modalias
      ds2780_battery&z2_battery: Add __devexit_p at necessary places
      max8998_charger: Allow full timeout not set, leave it unchanged
      pda_power: Fix build error if !CONFIG_USB_OTG_UTILS
      collie_battery: Convert to gpio_request_array() / gpio_free_array()
      tosa_battery: Convert to gpio_request_array() / gpio_free_array()
      power_supply: Convert drivers/power/* to use module_platform_driver()
      wm97xx_battery: Use DEFINE_MUTEX() for work_lock
      jz4740-battery: Fix signedness bug

Daniel Drake (2):
      olpc_battery: Bind to device tree
      olpc_battery: Add wakeup support

Dima Zavin (1):
      pda_power: Add support for using otg transceiver events

Donggeun Kim (2):
      power_supply: Add initial Charger-Manager driver
      power_supply: Charger-Manager: Add properties for power-supply-class

Felipe Contreras (1):
      isp1704_charger: Fix missing check

Heiko Stübner (1):
      s3c_adc_battery: Average over more than one adc sample

Jean Delvare (1):
      power_supply: Assume mains power by default

Jeremy Fitzhardinge (4):
      power_supply: add SCOPE attribute to power supplies
      power_supply: allow a power supply to explicitly point to powered device
      power_supply: add scope properties to some self-powered HID devices
      power_supply: add "powers" links to self-powered HID devices

Jochen Friedrich (1):
      collie_battery: Get rid of irq_to_gpio usage

Jonghwan Choi (2):
      max8997_charger: Fix unsigned value for less than zero
      max8997_charger: Remove duplicate module.h

Kim, Milo (4):
      lp8727_charger: Add supported i2c functionality check routine
      lp8727_charger: Coding style changes
      power_supply: Add "unknown" in power supply type
      lp8727_charger: Add header file

Major Lee (1):
      intel_mid_battery: Handle Over Current gracefully

Mark Brown (1):
      wm831x_power: Only register WM831x battery charger if enabled

Milo(Woogyom) Kim (1):
      lp8727_charger: Some minor fixes for the header

MyungJoo Ham (1):
      max17042_battery: Bugfix of incorrect voltage register value interpretation

Olof Johansson (1):
      sbs-battery: Fix devicetree match table

Pali Rohár (9):
      bq27x00_battery: Do not cache current_now value for bq27000 batery
      bq27x00_battery: Add support for property POWER_SUPPLY_PROP_CAPACITY_LEVEL
      bq27x00_battery: Report -ENODATA if bq27000 battery was not calibrated
      bq27x00_battery: Cache energy property
      bq27x00_battery: Cache temperature value in converted unit
      bq27x00_battery: Fix reporting status value for bq27500 battery
      bq27x00_battery: Fix reporting error messages
      bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver
      ARM: rx51: Add bq27200 i2c board info

Paul Parsons (1):
      ds2760_battery: Add rated capacity of the hx4700 3600mAh battery

Philip Rakity (9):
      max17042_battery: Divide by 0 crash because r_sns init too late
      max17042_battery: Do not lose accuracy calculating current_now
      max8925_power: Fix incorrect voltage and current calculation
      max8925_power: No temperature interrupts if temperature not connected
      max8925_power: Do not detect ac insert if handled by other code
      max8925_power: Remove support for irq bits that do not exist
      max8925_power: Enable power change notifications
      max8925_power: Do not read random data from chip registers
      max8925_power: Check at probe time if power to set online

Ramakrishna Pallala (1):
      max17042_battery: Fix error handling

Randy Dunlap (1):
      power_supply: Fix sysfs format warning

Rhyland Klein (6):
      bq20z75: Devicetree init support
      bq20z75: Rename to sbs-battery
      sbs-battery: Rename internals to new name
      devicetree-bindings: Add vendor entry for Smart Battery Systems
      devicetree-bindings: Propagate bq20z75->sbs rename to dt bindings
      sbs-battery: Change power supply name

Woogyom Kim (1):
      power_supply: Add LP8727 charger driver

Yong Zhang (1):
      power_supply: Remove IRQF_DISABLED

 .../bindings/power_supply/olpc_battery.txt         |    5 +
 .../bindings/power_supply/sbs_sbs-battery.txt      |   23 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/power/charger-manager.txt            |  163 +++
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    3 +
 drivers/hid/hid-wacom.c                            |   16 +-
 drivers/hid/hid-wiimote.c                          |   10 +-
 drivers/mfd/max8925-core.c                         |   15 -
 drivers/power/Kconfig                              |   32 +-
 drivers/power/Makefile                             |    5 +-
 drivers/power/bq27x00_battery.c                    |  210 +++--
 drivers/power/charger-manager.c                    | 1072 ++++++++++++++++++++
 drivers/power/collie_battery.c                     |   55 +-
 drivers/power/da9030_battery.c                     |   13 +-
 drivers/power/da9052-battery.c                     |  664 ++++++++++++
 drivers/power/ds2760_battery.c                     |   19 +-
 drivers/power/ds2780_battery.c                     |   18 +-
 drivers/power/gpio-charger.c                       |   12 +-
 drivers/power/intel_mid_battery.c                  |   25 +-
 drivers/power/isp1704_charger.c                    |   14 +-
 drivers/power/jz4740-battery.c                     |   14 +-
 drivers/power/lp8727_charger.c                     |  494 +++++++++
 drivers/power/max17042_battery.c                   |   94 ++-
 drivers/power/max8903_charger.c                    |   14 +-
 drivers/power/max8925_power.c                      |   75 +-
 drivers/power/max8997_charger.c                    |    4 +-
 drivers/power/max8998_charger.c                    |   14 +-
 drivers/power/olpc_battery.c                       |   75 +-
 drivers/power/pcf50633-charger.c                   |   12 +-
 drivers/power/pda_power.c                          |   89 ++-
 drivers/power/power_supply_core.c                  |   19 +-
 drivers/power/power_supply_sysfs.c                 |   12 +-
 drivers/power/s3c_adc_battery.c                    |   37 +-
 drivers/power/{bq20z75.c => sbs-battery.c}         |  481 +++++----
 drivers/power/tosa_battery.c                       |   79 +--
 drivers/power/wm831x_backup.c                      |   12 +-
 drivers/power/wm831x_power.c                       |   56 +-
 drivers/power/wm8350_power.c                       |   12 +-
 drivers/power/wm97xx_battery.c                     |   20 +-
 drivers/power/z2_battery.c                         |    4 +-
 include/linux/lp8727.h                             |   51 +
 include/linux/mfd/max8925.h                        |    7 +-
 include/linux/pda_power.h                          |    2 +
 include/linux/power/charger-manager.h              |  147 +++
 include/linux/power/{bq20z75.h => sbs-battery.h}   |   10 +-
 include/linux/power_supply.h                       |   11 +-
 include/linux/s3c_adc_battery.h                    |    4 +
 47 files changed, 3481 insertions(+), 743 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/olpc_battery.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/sbs_sbs-battery.txt
 create mode 100644 Documentation/power/charger-manager.txt
 create mode 100644 drivers/power/charger-manager.c
 create mode 100644 drivers/power/da9052-battery.c
 create mode 100644 drivers/power/lp8727_charger.c
 rename drivers/power/{bq20z75.c => sbs-battery.c} (52%)
 create mode 100755 include/linux/lp8727.h
 create mode 100644 include/linux/power/charger-manager.h
 rename include/linux/power/{bq20z75.h => sbs-battery.h} (85%)
