Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1E0N2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:28:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47218 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1E0N2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:28:10 -0400
Subject: [GIT PULL] Regulator updates for 2.6.41
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 14:28:05 +0100
Message-ID: <1306502885.3366.22.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator updates for 2.6.41. Notable
features this time are new PMIC drivers for the Texas Instruments
TPS65910, TPS65911 and TWL6025. Other updates include new features and
fixes for the TWL6030 and MC13xxx drivers.

Thanks

Liam

---

The following changes since commit dc7acbb2518f250050179c8581a972df3b6a24f1:

  Merge branch 'upstream/tidy-xen-mmu-2.6.39' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen (2011-05-26 19:01:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (11):
      regulator: Add missing platform_set_drvdata in tps6105x_regulator_probe
      regulator: Fix the argument of calling regulator_mode_constrain
      regulator: Move VCOINCELL to be the last element of mc13892_regulators array
      regulator: Use mc13xxx_reg_write instead of mc13xxx_reg_rmw in mc13892_sw_regulator_set_voltage
      Revert "regulator: Move VCOINCELL to be the last element of mc13892_regulators array"
      regulator: Fix desc_id for tps65023/6507x/65910
      regulator: Fix memory leak in max8998_pmic_probe failure path
      mfd: Fix off-by-one value range checking for tps65910_i2c_write
      regulator: Remove MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
      regulator: Fix off-by-one value range checking for mc13xxx_regulator_get_voltage
      regulator: Fix _regulator_get_voltage if get_voltage callback is NULL

Balaji T K (2):
      regulator: twl6030: do not write to _GRP for regulator enable
      regulator: twl6030: do not write to _GRP for regulator disable

Fabio Estevam (1):
      regulator: mc13892: Fix voltage unit in test case.

Graeme Gregory (6):
      MFD: TPS65910: Add new mfd device for TPS65910
      TPS65910: GPIO: Add GPIO driver
      TPS65910: IRQ: Add interrupt controller
      TPS65910: Add tps65910 regulator driver
      REGULATOR: TWL6025: add support to twl-regulator
      USB: TWL6025 allow different regulator name

Jonghwan Choi (1):
      regulator: max8997: remove useless code

Jorge Eduardo Candelaria (8):
      linux-next: build failure after merge of the voltage tree
      linux-next: build failure after merge of the voltage tree
      MFD: TPS65910: Add support for TPS65911 device
      regulator: tps65911: Add new chip version
      TPS65911: Add new irq definitions
      GPIO: TPS65910: Move driver to drivers/gpio/
      TPS65911: Add support for added GPIO lines
      TPS65911: Comparator: Add comparator driver

Mark Brown (8):
      regulator: When constraining modes fall back to higher power modes
      regulator: Convert WM8400 to get_voltage_sel()
      regulator: Factor out references to rdev in regulator_force_disable()
      regulator: Remove supply_regulator_dev from machine configuration
      regulator: Support voltage offsets to compensate for drops in system
      regulator: Remove some unused variables from wm831x DCDCs
      regulator: If we can't configure optimum mode we're always in the best one
      regulator: Only apply voltage constraints from consumers that set them

Saquib Herman (5):
      regulator: twl: fix twl6030 enable/disable
      regulator: twl: remap has no meaning for 6030
      regulator: twl: fix twl6030 regulator is_enabled
      regulator: twl: add twl6030 get_status
      regulator: twl: add twl6030 set_mode

 Documentation/power/regulator/machine.txt  |    4 +-
 drivers/gpio/Kconfig                       |    7 +
 drivers/gpio/Makefile                      |    1 +
 drivers/gpio/tps65910-gpio.c               |  100 +++
 drivers/mfd/Kconfig                        |    9 +
 drivers/mfd/Makefile                       |    1 +
 drivers/mfd/tps65910-irq.c                 |  218 ++++++
 drivers/mfd/tps65910.c                     |  229 +++++++
 drivers/mfd/tps65911-comparator.c          |  188 ++++++
 drivers/regulator/Kconfig                  |    6 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/core.c                   |   93 ++-
 drivers/regulator/max8997.c                |   13 +-
 drivers/regulator/max8998.c                |   22 +-
 drivers/regulator/mc13892-regulator.c      |   18 +-
 drivers/regulator/mc13xxx-regulator-core.c |    2 +-
 drivers/regulator/tps6105x-regulator.c     |    1 +
 drivers/regulator/tps65023-regulator.c     |    3 +-
 drivers/regulator/tps6507x-regulator.c     |    3 +-
 drivers/regulator/tps65910-regulator.c     |  993 ++++++++++++++++++++++++++++
 drivers/regulator/twl-regulator.c          |  564 ++++++++++++++--
 drivers/regulator/wm831x-dcdc.c            |    2 -
 drivers/regulator/wm8400-regulator.c       |   12 +-
 drivers/usb/otg/twl6030-usb.c              |   10 +-
 include/linux/mfd/max8997-private.h        |    4 -
 include/linux/mfd/tps65910.h               |  800 ++++++++++++++++++++++
 include/linux/regulator/machine.h          |    7 +-
 27 files changed, 3161 insertions(+), 150 deletions(-)
 create mode 100644 drivers/gpio/tps65910-gpio.c
 create mode 100644 drivers/mfd/tps65910-irq.c
 create mode 100644 drivers/mfd/tps65910.c
 create mode 100644 drivers/mfd/tps65911-comparator.c
 create mode 100644 drivers/regulator/tps65910-regulator.c
 create mode 100644 include/linux/mfd/tps65910.h


