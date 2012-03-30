Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab2C3Uvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:51:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43112 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2C3Uvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:51:37 -0400
Date: Sat, 31 Mar 2012 00:50:19 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20120330205018.GA32753@lizard>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Sorry for the delayed pull request, I hope it's too late though.
(And my gpg key is still not signed by anyone; couldn't find anyone
near me, heh.)

Anyway, here is the formal pull request:

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.4-rc1

for you to fetch changes up to 5cdd4d7fa5424f2018193a0c2af3bef9036c973e:

  max17042_battery: Clean up interrupt handling (2012-03-26 20:41:29 +0400)

----------------------------------------------------------------
Various small bugfixes and enhancements, plus two new drivers:

- A quite complex ab8500 charger driver, submitted by
  Arun Murthy @ ST-Ericsson;
- Summit Microelectronics SMB347 Battery Charger, submitted by
  Bruce E. Robertson and Alan Cox @ Intel.

And that's all.

----------------------------------------------------------------
Anton Vorontsov (9):
      ab8500_charger: Convert to the new USB OTG calls
      ab8500_btemp: Get rid of 'enum adc_therm'
      ab8500_fg: Get rid of 'struct v_to_cap'
      ab8500_fg: Get rid of 'struct battery_type'
      ab8500_fg: Fix copy-paste error
      ab8500: Turn unneeded global symbols into local ones
      charger-manager: Simplify charger_get_property(), get rid of a warning
      ab8500_fg: Fix some build warnings on x86_64
      Revert "max8998_charger: Include linux/module.h just once"

Arun Murthy (4):
      abx500-chargalg: Add abx500 charging algorithm
      ab8500-charger: AB8500 charger driver
      ab8500-fg: A8500 fuel gauge driver
      ab8500-btemp: AB8500 battery temperature driver

Axel Lin (6):
      da9052-battery: Add missing platform_set_drvdata
      da9052-battery: Fix a memory leak when unload the module
      da9052-battery: Convert to use module_platform_driver
      charger-manager: Clean up for better readability
      lp8727_charger: Add MODULE_DEVICE_TABLE
      power_supply: Convert i2c drivers to module_i2c_driver

Bruce E. Robertson (1):
      Add I2C driver for Summit Microelectronics SMB347 Battery Charger.

Dirk Brandewie (2):
      max17042: Align register definitions with data sheet and init appnote
      max17042: Change capacity property to use reported SOC register

Felipe Contreras (1):
      isp1704_charger: Fix probe error path

Jesper Juhl (1):
      max8998_charger: Include linux/module.h just once

Karol Lewandowski (2):
      max17042_battery: Use devm_kzalloc() where applicable
      max17042_battery: Make it possible to instantiate driver from DT

Kim, Milo (6):
      lp8727_charger: Add company name and description
      lp8727_charger: Add error check routine on probe()
      lp8727_charger: Change i2c functions
      lp8727_charger: Fix wrong code style
      lp8727_charger: Add description of platform data
      lp8727_charger: Correct typos on the comment

MyungJoo Ham (1):
      max17042_battery: Fix CHARGE_FULL representation.

Ramakrishna Pallala (3):
      max17042: Add POR init procedure from Maxim appnote
      max17042: Add support for signalling change in SOC
      max17042_battery: Clean up interrupt handling

 .../bindings/power_supply/max17042_battery.txt     |   18 +
 drivers/power/Kconfig                              |   21 +-
 drivers/power/Makefile                             |    2 +
 drivers/power/ab8500_btemp.c                       | 1124 ++++++++
 drivers/power/ab8500_charger.c                     | 2789 ++++++++++++++++++++
 drivers/power/ab8500_fg.c                          | 2637 ++++++++++++++++++
 drivers/power/abx500_chargalg.c                    | 1921 ++++++++++++++
 drivers/power/charger-manager.c                    |   67 +-
 drivers/power/da9052-battery.c                     |   15 +-
 drivers/power/ds2782_battery.c                     |   13 +-
 drivers/power/isp1704_charger.c                    |    1 +
 drivers/power/lp8727_charger.c                     |  131 +-
 drivers/power/max17040_battery.c                   |   13 +-
 drivers/power/max17042_battery.c                   |  508 +++-
 drivers/power/sbs-battery.c                        |   13 +-
 drivers/power/smb347-charger.c                     | 1294 +++++++++
 drivers/power/z2_battery.c                         |   14 +-
 include/linux/lp8727.h                             |   18 +-
 include/linux/mfd/abx500.h                         |  273 ++
 include/linux/mfd/abx500/ab8500-bm.h               |  474 ++++
 include/linux/mfd/abx500/ux500_chargalg.h          |   38 +
 include/linux/power/max17042_battery.h             |   93 +-
 include/linux/power/smb347-charger.h               |  117 +
 23 files changed, 11388 insertions(+), 206 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/max17042_battery.txt
 create mode 100644 drivers/power/ab8500_btemp.c
 create mode 100644 drivers/power/ab8500_charger.c
 create mode 100644 drivers/power/ab8500_fg.c
 create mode 100644 drivers/power/abx500_chargalg.c
 create mode 100644 drivers/power/smb347-charger.c
 create mode 100644 include/linux/mfd/abx500/ab8500-bm.h
 create mode 100644 include/linux/mfd/abx500/ux500_chargalg.h
 create mode 100644 include/linux/power/smb347-charger.h
