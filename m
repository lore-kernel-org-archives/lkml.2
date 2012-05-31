Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2EaBK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:10:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64838 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab2EaBKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:10:25 -0400
Date: Wed, 30 May 2012 18:08:45 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20120531010844.GA23101@lizard>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

I guess my pull requests have a distinct style already: they are somewhat
boring (in sense that it's just a pile of fixes), late, and my gpg key is
not signed by anyone. :-)

So here it is:

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.5

for you to fetch changes up to 96facd23e45e6d5020be135c8ab392ba9e044fa4:

  smb347-charger: Include missing <linux/err.h> (2012-05-18 17:15:48 -0700)

----------------------------------------------------------------
A bunch of fixes for v3.5, nothing extraordinary.

----------------------------------------------------------------
Anton Vorontsov (3):
      max17042_battery: Move dev_pm_ops struct under CONFIG_PM
      power_supply: Make the core a boolean instead of a tristate
      MAINTAINERS: Fix 'F' entry for the power supply class

Axel Lin (2):
      power_supply: Fix a typo in BATTERY_DS2781 Kconfig entry
      ds2781_battery: Use DS2781_PARAM_EEPROM_SIZE and DS2781_USER_EEPROM_SIZE

Chanwoo Choi (2):
      charger-manager: Poll battery health in normal state
      charger-manager: Provide cm_notify_event function for in-kernel use

Dan Carpenter (2):
      max17042_battery: Fix a couple buffer overflows
      isp1704_charger: Use after free on probe error

Lee Jones (1):
      ab8500: Clean up probe routines

Linus Walleij (3):
      ab8500_charger: Harden platform data check
      ab8500_btemp: Harden platform data check
      ab8500_fg: Harden platform data check

Mika Westerberg (5):
      smb347-charger: Convert to use module_i2c_driver()
      smb347-charger: Rename few functions to match better what they are doing
      smb347-charger: Move IRQ enabling to the end of probe
      smb347-charger: Convert to regmap API
      smb347-charger: Include missing <linux/err.h>

Nikolaus Voss (1):
      sbs-battery.c: Capacity attr = remaining relative capacity

Ramakrishna Pallala (8):
      max17042_battery: Fix driver exit function
      max17042_battery: Add suspend/resume hooks
      power_supply: Add voltage_ocv property and use it for max17042 driver
      max17042_battery: Fix power supply and irq registration ordering
      max17042_battery: Handle irq request failure case
      smb347_charger: Cleanup power supply registration code in probe
      max17042_battery: Add support for max17047/50 chip
      smb347-charger: Clean up battery attributes

 Documentation/power/charger-manager.txt    |   41 +-
 Documentation/power/power_supply_class.txt |    2 +
 MAINTAINERS                                |    2 +-
 drivers/power/Kconfig                      |   10 +-
 drivers/power/ab8500_btemp.c               |   12 +-
 drivers/power/ab8500_charger.c             |   13 +-
 drivers/power/ab8500_fg.c                  |   12 +-
 drivers/power/charger-manager.c            |  392 +++++++++++++++
 drivers/power/ds2781_battery.c             |   20 +-
 drivers/power/isp1704_charger.c            |    2 +-
 drivers/power/max17042_battery.c           |  148 +++++-
 drivers/power/power_supply_sysfs.c         |    1 +
 drivers/power/sbs-battery.c                |    2 +-
 drivers/power/smb347-charger.c             |  712 +++++++++++-----------------
 include/linux/power/charger-manager.h      |   50 +-
 include/linux/power/max17042_battery.h     |   17 +
 include/linux/power_supply.h               |    4 +-
 17 files changed, 943 insertions(+), 497 deletions(-)
