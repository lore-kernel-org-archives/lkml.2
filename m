Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1ALSY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:24:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65085 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1ALSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:24:53 -0500
Subject: [GIT PULL] Regulator updates for 2.6.38
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 18:24:48 +0000
Message-ID: <1294856688.3303.345.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator updates for 2.6.38. Notable updates
include new mc13892 and tps6524x PMIC drivers and significant updates
for the MC13xxx and AB8500 PMIC families. Also included is a cleanup of
the regulator notification messages, basic trace functionality and
numerous bug fixes.

Thanks

Liam

--- 

The following changes since commit 4162cf64973df51fc885825bc9ca4d055891c49f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-01-11 16:32:41 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (1):
      regulator: Assign return value of mc13xxx_reg_rmw to ret

Bengt Jonsson (10):
      regulator: enable supply regulator only when use count is zero
      regulators: Moved define for number of regulators in ab8500
      regulators: Fixed errors in ab8500 register mapping
      regulators: Clean out unused code in ab8500 regulators
      regulators: Added ab8500 v2 support
      regulators: Updated ab8500 variable names, macro names and comments
      regulators: Modified ab8500 error handling
      regulators: Added verbose debug messages to ab8500 regulators
      regulators: Removed macros for initialization of ab8500 regulators
      mach-ux500: Updated and connected ab8500 regulator board configuration

Cyril Chemparathy (1):
      regulator: add driver for tps6524x regulator

Daniel Walker (2):
      drivers: regulator: core: use pr_fmt
      drivers: regulator: core: convert to using pr_ macros

Joe Perches (2):
      regulator: Add and use rdev_<level> macros
      drivers/regulator: Update WARN uses

Mark Brown (23):
      regulator: Report actual configured voltage to set_voltage()
      regulator: Add basic trace facilities
      regulator: Fix typo in PCAP regulator_set_voltage()
      regulator: Fix obfuscated log messages
      regulator: Remove regulator core version announcement
      regulator: Fix prototype for MAX8998 buck set_voltage()
      regulator: Copy constraints from regulators when initialising them
      regulator: Remove duplicate consts from mc13873 driver voltage tables
      regulator: Use _regulator_get_voltage() consistently
      regulator: Allow drivers to report voltages as selectors
      regulator: Convert WM831x drivers to use get_voltage_sel()
      regulator: Allow modular build of mc13xxx-core
      regulator: Convert WM835x to use get_voltage_sel()
      regulator: Convert WM8994 to use get_voltage_sel()
      regulator: Factor out voltage set operation into a separate function
      regulator: Provide a selector based set_voltage_sel() operation
      regulator: Only notify voltage changes when they succeed
      regulator: Staticise non-exported functions in mc13892
      regulator: Add API to re-apply voltage to hardware
      regulator: Optimise out noop voltage changes
      regulator: Clean up logging a bit
      regulator: Make regulator_has_full_constraints a bool
      regulator: Add initial per-regulator debugfs support

Mattias Wallin (1):
      regulator: lock supply in regulator enable

Thomas Petazzoni (1):
      regulator: Take into account the requirements of all consumers

Yong Shen (3):
      Change the register name definitions for mc13783
      make mc13783 regulator code generic
      regulator: support PMIC mc13892

roel kluin (1):
      regulator: missing index in PTR_ERR() in isl6271a_probe()

 arch/arm/mach-imx/mach-pcm038.c               |    4 +-
 arch/arm/mach-mx3/mach-mx31_3ds.c             |    4 +-
 arch/arm/mach-mx3/mach-mx31moboard.c          |    4 +-
 arch/arm/mach-ux500/board-mop500-regulators.c |  153 +++---
 arch/arm/mach-ux500/board-mop500-regulators.h |   19 +
 arch/arm/mach-ux500/board-mop500.c            |    3 +
 drivers/regulator/88pm8607.c                  |    3 +-
 drivers/regulator/Kconfig                     |   22 +
 drivers/regulator/Makefile                    |    3 +
 drivers/regulator/ab3100.c                    |    5 +-
 drivers/regulator/ab8500.c                    |  453 ++++++++++++-----
 drivers/regulator/core.c                      |  462 +++++++++++-----
 drivers/regulator/da903x.c                    |   17 +-
 drivers/regulator/isl6271a-regulator.c        |    8 +-
 drivers/regulator/lp3971.c                    |   10 +-
 drivers/regulator/lp3972.c                    |   10 +-
 drivers/regulator/max1586.c                   |   30 +-
 drivers/regulator/max8649.c                   |    3 +-
 drivers/regulator/max8660.c                   |   14 +-
 drivers/regulator/max8925-regulator.c         |    3 +-
 drivers/regulator/max8952.c                   |    3 +-
 drivers/regulator/max8998.c                   |    8 +-
 drivers/regulator/mc13783-regulator.c         |  385 +++-----------
 drivers/regulator/mc13892-regulator.c         |  635 ++++++++++++++++++++++
 drivers/regulator/mc13xxx-regulator-core.c    |  241 +++++++++
 drivers/regulator/mc13xxx.h                   |  101 ++++
 drivers/regulator/pcap-regulator.c            |    7 +-
 drivers/regulator/pcf50633-regulator.c        |    5 +-
 drivers/regulator/tps65023-regulator.c        |    9 +-
 drivers/regulator/tps6507x-regulator.c        |   10 +-
 drivers/regulator/tps6524x-regulator.c        |  693 +++++++++++++++++++++++++
 drivers/regulator/tps6586x-regulator.c        |   15 +-
 drivers/regulator/twl-regulator.c             |   11 +-
 drivers/regulator/wm831x-dcdc.c               |   31 +-
 drivers/regulator/wm831x-ldo.c                |   59 ++-
 drivers/regulator/wm8350-regulator.c          |   24 +-
 drivers/regulator/wm8400-regulator.c          |    8 +-
 drivers/regulator/wm8994-regulator.c          |   22 +-
 include/linux/mfd/ab8500.h                    |    5 +-
 include/linux/mfd/mc13783.h                   |   67 ++--
 include/linux/mfd/mc13892.h                   |   39 ++
 include/linux/regulator/ab8500.h              |   24 +-
 include/linux/regulator/consumer.h            |    1 +
 include/linux/regulator/driver.h              |   19 +-
 include/trace/events/regulator.h              |  141 +++++
 45 files changed, 2960 insertions(+), 833 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-regulators.h
 create mode 100644 drivers/regulator/mc13892-regulator.c
 create mode 100644 drivers/regulator/mc13xxx-regulator-core.c
 create mode 100644 drivers/regulator/mc13xxx.h
 create mode 100644 drivers/regulator/tps6524x-regulator.c
 create mode 100644 include/linux/mfd/mc13892.h
 create mode 100644 include/trace/events/regulator.h


