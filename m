Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab2JEDHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 23:07:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57443 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2JEDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 23:07:17 -0400
Date: Thu, 4 Oct 2012 20:04:26 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20121005030425.GA8754@lizard>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here are some battery tree updates for 3.7...

The following changes since commit 0848c94fb4a5cc213a7fb0fb3a5721ad6e16f096:

  mfd: core: Push irqdomain mapping out into devices (2012-09-15 23:22:04 +0200)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.7

for you to fetch changes up to 18766f0936d444fd7ff2e0064bd6e69a89d5c6fc:

  Merge with upstream to accommodate with MFD changes (2012-09-24 19:12:01 -0700)

----------------------------------------------------------------

1. New drivers:
   - Marvell 88pm860x charger and battery drivers;
   - Texas Instruments LP8788 charger driver;
2. Two new power supply properties: whether a battery is authentic, and
   chargers' maximal currents and voltages;
3. A lot of TI LP8727 Charger cleanups;
4. New features for Charger Manager, mainly now we can disable specific
   regulators;
5. Random fixes and cleanups for other drivers.

----------------------------------------------------------------
Anton Vorontsov (5):
      da9052-battery: Fix da9052_determine_vc_tbl_index's return value
      da9030_battery: Don't use 0 as NULL
      charger-manager: Fix struct charger_desc's misleading comment
      88pm860x_battery and charger: Fix a few post-merge issues
      Merge with upstream to accommodate with MFD changes

Axel Lin (1):
      power_supply: Remove broken mark for da9052-battery

Chanwoo Choi (5):
      charger-manager: Disable regulator when charger cable is detached
      charger-manager: Use replacement variable to check state of battery
      charger-manager: Check fully charged state of battery periodically
      charger-manager: Support limit of maximum possible
      charger-manager: Add support sysfs entry for charger

Dan Carpenter (1):
      da9052-battery: Don't free IRQ that wasn't requested

Devendra Naga (3):
      lp8727_charger: Unregister power supply at error path of lp8727_register_psy
      ds2781_battery: Convert to module_platform_driver
      ds2781_battery: Replace call to kzalloc with devm_kzalloc

Fengguang Wu (2):
      lp8727_charger: Use IRQF_ONESHOT
      twl4030_charger: Use IRQF_ONESHOT

Il Han (1):
      twl4030_charger: It would be better not to use the 0b-prefix

Jett.Zhou (1):
      power_supply: Enable battery-charger for 88pm860x

Julia Lawall (5):
      ab8500_charger: Fix error return code
      wm97xx_battery: Fix error return code
      ab8500_btemp: Fix error return code
      ab8500_fg: Fix error return code
      bq27x00_battery: Fix error return code

Kim, Milo (23):
      power_supply: Add new lp8788 charger driver
      lp8727_charger: Use devm_kzalloc()
      lp8727_charger: Cleanup _probe() and _remove()
      lp8727_charger: Fix buggy code of NULL pdata
      lp8727_charger: Add configurable debouce timer
      lp8727_charger: Remove unnecessary workqueue thread
      lp8727_charger: Clean up the interrupt handler
      lp8727_charger: Clear interrrupts at inital time
      lp8727_charger: Fix code for getting battery temp
      lp8727_charger: Use the definition rather than enum
      lp8727_charger: Clean up lp8727 definitions
      lp8727_charger: Use specific definition
      lp8727_charger: Clean up lp8727_is_charger_attached()
      lp8727_charger: Make lp8727_init_device() shorter
      lp8727_charger: Make lp8727_ctrl_switch() inline
      lp8727_charger: Make lp8727_charger_get_propery() simpler
      lp8727_charger: Return if the battery is discharging
      lp8727_charger: Clean up lp8727_charger_changed()
      lp8727_charger: Make some cosmetic changes in lp8727_delayed_func()
      lp8727_charger: Fix a typo - chg_parm to chg_param
      lp8727_charger: Add description in the private data
      lp8727_charger: Fix checkpatch warning
      lp8727_charger: More pure cosmetic improvements

Olof Johansson (1):
      sbs-battery: Probe should try talking to the device

Paul Parsons (2):
      pda_power: Fix ac_draw usage before it being set
      pda_power: Remove ac_draw_failed goto and label

Ramakrishna Pallala (3):
      power_supply: Add new power supply AUTHENTIC property
      power_supply: Add new power supply properties CHARGE_CURRENT/VOLTAGE_MAX
      smb347-charger: Fix battery status reporting logic for charger faults

 Documentation/power/power_supply_class.txt |    7 +
 drivers/mfd/88pm860x-core.c                |   22 +-
 drivers/power/88pm860x_battery.c           | 1041 ++++++++++++++++++++++
 drivers/power/88pm860x_charger.c           |  746 ++++++++++++++++
 drivers/power/Kconfig                      |   20 +-
 drivers/power/Makefile                     |    3 +
 drivers/power/ab8500_btemp.c               |    1 +
 drivers/power/ab8500_charger.c             |    1 +
 drivers/power/ab8500_fg.c                  |    1 +
 drivers/power/bq27x00_battery.c            |    3 +-
 drivers/power/charger-manager.c            |  434 ++++++++-
 drivers/power/da9030_battery.c             |    4 +-
 drivers/power/da9052-battery.c             |   11 +-
 drivers/power/ds2781_battery.c             |   28 +-
 drivers/power/lp8727_charger.c             |  360 ++++----
 drivers/power/lp8788-charger.c             |  795 +++++++++++++++++
 drivers/power/pda_power.c                  |   13 +-
 drivers/power/power_supply_sysfs.c         |    3 +
 drivers/power/sbs-battery.c                |   10 +
 drivers/power/smb347-charger.c             |   97 +-
 drivers/power/twl4030_charger.c            |   25 +-
 drivers/power/wm97xx_battery.c             |    4 +-
 include/linux/mfd/88pm860x.h               |   84 +-
 include/linux/platform_data/lp8727.h       |   51 +-
 include/linux/power/charger-manager.h      |   47 +-
 include/linux/power_supply.h               |    5 +
 26 files changed, 3519 insertions(+), 297 deletions(-)
 create mode 100644 drivers/power/88pm860x_battery.c
 create mode 100644 drivers/power/88pm860x_charger.c
 create mode 100644 drivers/power/lp8788-charger.c
