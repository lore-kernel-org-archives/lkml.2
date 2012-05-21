Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2EUKth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:49:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44004 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757926Ab2EUKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:49:34 -0400
Date: Mon, 21 May 2012 11:49:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for 3.5
Message-ID: <20120521104928.GB4983@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.5

for you to fetch changes up to 84df8c1241beb87fec73415ef4f6e627aca34835:

  regulator: tps65910: use of_node of matched regulator being register (2012-05-20 18:22:41 +0100)

----------------------------------------------------------------
regulator updates for 3.5

The major thing here is the addition of some helpers to factor code out
of drivers, making a fair proportion of regulators much more just data
rather than code which is nice.

- Helpers in the core for regulators using regmap, providing generic
  implementations of the enable and voltage selection operations which
  just need data to describe them in the drivers.
- Split out voltage mapping and voltage setting, allowing many more
  drivers to take advantage of the infrastructure for selectors.
- Loads and loads of cleanups from Axel Lin once again, including many
  changes to take advantage of the above new framework features
- New drivers for Ricoh RC5T583, TI TPS62362, TI TPS62363, TI TPS65913,
  TI TWL6035 and TI TWL6037.

Some of the registration changes to support the core refactoring caused
so many conflicts that eventually topic branches were abandoned for this
release.

----------------------------------------------------------------
Axel Lin (145):
      regulator: pcf50633: Don't write to reserved bits of AUTO output voltage select register
      regulator: Convert pcf50633 to get_voltage_sel
      regulator: Convert ab8500 to set_voltage_sel
      regulator: Convert ab3100 to set_voltage_sel
      regulator: max8952: Simplify the logic to get vid[0|1] status
      regulator: Implement tps65912_list_voltage to be shared by both DCDCs and LDOs
      regulator: Use tps65912_get_voltage for both DCDCs and LDOs
      regulator: gpio-regulator: Set the smallest voltage/current in the specified range
      regulator: Convert lp3971 to set_voltage_sel
      regulator: Convert lp3972 to set_voltage_sel
      regulator: Convert pcap-regulator to set_voltage_sel
      regulator: Convert pcap-regulator to get_voltage_sel
      regulator: wm831x-dcdc: Use devm_kzalloc
      regulator: Convert tps6586x to get_voltage_sel
      regulator: Convert tps6586x to set_voltage_sel
      regulator: Merge tps6586x_regulator_ldo_ops and tps6586x_regulator_dvm_ops
      regulator: tps65090: Use IS_ERR to check return value of regulator_register
      regulator: Remove _en_reg, _en_bit and _ops parameters from tps65090_REG macro
      regulator: Convert max8952 to set_voltage_sel
      regulator: Make max8997_get_voltage_register always return correct register
      regulator: Add MAX8997_VOLTAGE_REGULATOR and MAX8997_CURRENT_REGULATOR macros
      regulator: Convert tps65023 to set_voltage_sel
      regulator: Fix da9052 ldo regulator names
      regulator: Refactor to use one da9052_ldo_ops/da9052_dcdc_ops for all LDOs/DCDCs
      regulator: Remove unused name and client fields from struct tps62360_chip
      regulator: tps65023: Remove unused client field from struct tps_pmic
      regulator: ad5398: show changing current in uA
      regulator: ad5398: Use devm_kzalloc
      regulator: Convert tps6524x to set_voltage_sel
      regulator: Convert tps6524x to get_voltage_sel
      regulator: Trivial comment fix for wm831x-ldo driver
      regulator: Set list_voltage callback for 88pm8607
      regulator: Add missing n_voltages setting for 88pm8607
      regulator: Convert 88pm8607 to set_voltage_sel
      regulator: Convert 88pm8607 to get_voltage_sel
      regulator: Set list_voltage callback for max8925
      regulator: Add missing n_voltages setting for max8925
      regulator: Add support for tps62362 and tps62363 in tps62360-regulator driver
      regulator: Convert mc13xxx regulator drivers to set_voltage_sel
      regulator: Fix rc5t583_regulator_probe error handling
      regulator: ad5398: Constify regulator_desc
      regulator: pcf50633: Constify regulator_desc
      regulator: isl6271a: Constify regulator_desc
      regulator: lp3971: Constify regulator_desc
      regulator: lp3972: Constify regulator_desc
      regulator: pcap: Constify regulator_desc
      regulator: da9052: Remove unneeded devm_kfree calls
      regulator: rc5t583: Fix off-by-one valid range checking for selector
      regulator: rc5t583: Remove nsteps from struct rc5t583_regulator_info
      regulator: Support set_voltage_time_sel for drivers implement set_voltage
      regulator: rc5t583: Simplify RC5T583_REG macro
      regulator: Convert twl4030ldo_set_voltage to set_voltage_sel
      regulator: max8660: Constify regulator_desc
      regulator: max8952: Constify regulator_desc
      regulator: tps6105x: Constify regulator_desc
      regulator: tps65217: Constify regulator_desc
      regulator: max1586: Constify regulator_desc
      regulator: max8649: Constify regulator_desc
      regulator: Convert rc5t583 to set_voltage
      regulator: Fix a typo in da903x.c
      regulator: Fix build error for mc13783 and mc13892
      regulator: Rework s5m8767_set_voltage to support both LDOs and BUCKs
      regulator: Use one s5m8767_ops for both LDOs and BUCKs
      regulator: Replace regulator_desc_[ldo|buck] by s5m8767_regulator_desc macro
      regulator: max8997: Remove n_bits from struct voltage_map_desc
      regulator: max8997: Use simple equation to get selector
      regulator: max8998: Use simple equation to get selector
      regulator: twl-regulator: Simplify the code matching regulator id
      regulator: twl-regulator: Use DIV_ROUND_UP at appropriate places
      regulator: max8649: Use devm_* APIs
      regulator: tps62360: Convert to devm_regmap_init_i2c()
      regulator: tps65023: Use devm_* APIs
      regulator: twl-regulator: Fix off-by-one vsel setting in twl6030smps_set_voltage
      regulator: Convert anatop to use a struct to pass in regulator runtime configuration
      regulator: Convert tps65xxx regulator drivers to use devm_kzalloc
      regulator: Update regulator_register() API signature in Documentation
      regulator: twl-regulator: Implement enable_time callback
      regulator: twl-regulator: Use twlreg_grp helper function
      regulator: Convert max8998 to get_voltage_sel
      regulator: Convert max8998 to set_voltage_time_sel
      regulator: isl6271a-regulator: Use devm_kzalloc()
      regulator: max1586: Use devm_kzalloc()
      regulator: max8660: Use devm_kzalloc()
      regulator: core: Fix getting input_uV when supplied by another regulator
      regulator: core: Support setting suspend_[mode|voltage] if set_suspend_[en|dis]able is NULL
      regulator: tps65023: Use generic regmap enable/disable operations
      regulator: core: Add checking set_mode callback in regulator_set_optimum_mode
      regulator: max8660: Fix a memory leak due to missing devm_kzalloc conversion
      regulator: Convert max8997 to get_voltage_sel
      regulator: Convert max8997 to set_voltage_time_sel
      regulator: userspace-consumer: Convert to use devm_* APIs
      regulator: virtual: Convert to use devm_* APIs
      regulator: tps65090: Use generic regmap enable/disable operations
      regulator: 88pm8607: Fix writting value to vol_reg in pm8607_set_voltage_sel
      regulator: virtual: Replace strict_strtol with kstrtol
      regulator: tps6507x: Convert to get_voltage_sel
      regulator: max8952: Convert to get_voltage_sel
      regulator: s5m8767: Use DIV_ROUND_UP to calculate selector
      regulator: rc5t583: Use generic regmap enable/disable operations
      regulator: tps65910: Use generic regmap enable/disable operations
      regulator: pcf50633: Use generic regmap enable/disable operations
      regulator: 88pm8607: Use generic regmap enable/disable operations
      regulator: da9052: Use generic regmap enable/disable operations
      regulator: pcf50633: Use regulator_get_voltage_sel_regmap()
      regulator: max8997: Remove is_enabled callback implementation for max8997_charger_fixedstate_ops
      regulator: max8997: Remove empty set_suspend_enable callback implementation
      regulator: Remove unneeded include of linux/delay.h from regulator drivers
      regulator: max8997: Convert ot use devm_kzalloc
      regulator: max8998: Convert ot use devm_kzalloc
      regulator: tps65912: Convert to get_voltage_sel
      regulator: da9052: Use regulator_get_voltage_sel_regmap()
      regulator: rc5t583: Use regulator_get_voltage_sel_regmap()
      regulator: 88pm8607: Use regulator_get_voltage_sel_regmap()
      regulator: tps65910: Convert to get_voltage_sel
      regulator: da903x: Fix list voltage for da9030 ldo14
      regulator: da903x: Convert to get_voltage_sel
      regulator: core: Ensure simple linear voltage mappings falls within the specified range
      regulator: tps62360: Convert to regulator_list_voltage_linear()
      regulator: tps62360: Convert to set_voltage_sel and regulator_map_voltage_linear
      regulator: max8925: Convert to get_voltage_sel
      regulator: max8925: Convert to regulator_list_voltage_linear()
      regulator: max8925: Convert to set_voltage_sel() and map_voltage()
      regulator: tps62360: Fix build error due to missing semicolon
      regulator: max8649: Convert to get_voltage_sel
      regulator: max8649: Use regulator_get_voltage_sel_regmap()
      regulator: max8649: Convert to regulator_list_voltage_linear()
      regulator: max8649: Convert to regulator_set_voltage_sel_regmap and regulator_map_voltage_linear
      regulator: rc5t583: Convert to regulator_list_voltage_linear()
      regulator: rc5t583: Convert to regulator_set_voltage_sel_regmap and regulator_map_voltage_linear
      regulator: da903x: Convert to regulator_list_voltage_linear()
      regulator: da903x: Convert to set_voltage_sel and map_voltage
      regulator: da903x: Kill da903x_[get|set]_[ldo12|ldo14]_voltage_sel() functions
      regulator: max8660: Convert to regulator_list_voltage_linear()
      regulator: max8660: Convert to get_voltage_sel
      regulator: max8660: Convert to set_voltage_sel and regulator_map_voltage_linear
      regulator: isl6271a: Use regulator_list_voltage_linear()
      regulator: isl6271a: Convert to get_voltage_sel
      regulator: isl6271a: Convert to set_voltage_sel and regulator_map_voltage_linear
      regulator: max8952: Use devm_kzalloc
      regulator: da9052: Convert to set_voltage_sel and map_voltage
      regulator: rc5t583: Remove max_uV from struct rc5t583_regulator_info
      regulator: max8649: Remove unused check_range() function
      regulator: max8925: Remove check_range function and max_uV from struct rc5t583_regulator_info
      regulator: tps65217: Convert to set_voltage_sel and map_voltage
      regulator: ab3100: Use regulator_map_voltage_iterate()

Graeme Gregory (2):
      regulator: regulator driver for Palmas series chips
      regulator: regulator for Palmas Kconfig

Laxman Dewangan (16):
      regulator: fixed: Support for open drain gpio pin
      regulator: Add support for RICOH PMIC RC5T583 regulator
      regulator: rc5t583: Correct MODULE LICENSE to GPL v2
      regulator: fixed: add property for gpio open drain flag
      regulator: tps62360: enable register cache
      regulator: tps62360: Provide settling time for voltage change
      regulator: tps62360: fix stylistic issue and optimize code
      regulator: tps62360: make init_data of platform data to pointer.
      regulator: tps62360: add dt support
      regulator: tps62360: support force PWM mode via regulator mode
      regulator: tps65910: use small letter for regulator names
      regulator: tps65910: use devm_* for memory allocation
      regulator: tps62360: dt: initialize of_node param for regulator register.
      regulator: tps65910: add error message in case of failure
      regulator: tps65910: dt: support when "regulators" node found
      regulator: tps65910: use of_node of matched regulator being register

Lee Jones (4):
      regulator: ab8500: Split up probe() into manageable pieces
      regulator: Enable the ab8500 for Device Tree
      regulator: db8500-prcmu: Separate regulator registration from probe
      regulator: Enable Device Tree for the db8500-prcmu regulator driver

Mark Brown (53):
      regulator: fixed: Use devm_kzalloc()
      regulator: fixed: Don't supply voltage change ops when no GPIO is given
      regulator: core: Complain if we can't reenable a supply
      regulator: core: Don't defer probe if there's no DT binding for a supply
      regulator: core: Pull non-DT supply mapping into regulator_dev_lookup()
      regulator: gpio-regulator: Sort in Makefile
      regulator: gpio-regulator: Basic devm_kzalloc() conversion
      regulator: isl6271a: Allow missing init_data for diagnostics
      regulator: lp3971: Convert to module_i2c_driver()
      regulator: max8649: Remove contentless announcement log message
      regulator: max8860: Remove announcement on probe
      regulator: tps6524x: Use module_spi_driver()
      regulator: core: Constify the regulator_desc passed in when registering
      regulator: wm8350: Constify regulator_desc
      regulator: wm8994: Constify regulator_desc
      regulator: aat2870: Add MODULE_ALIAS
      Merge branch 'regulator-register' into regulator-drivers
      regulator: core: Use a struct to pass in regulator runtime configuration
      regulator: Fix build of ab8500
      Merge tag 'v3.4-rc2' into regulator-drivers
      regulator: Appease smatch in regulator_register()
      regulator: wm8994: Convert to set_voltage_sel()
      regulator: da9052: Directly include of.h
      regulator: core: Allow drivers to pass in a regmap
      regulator: core: Provide regmap based voltage_sel operations
      regulator: wm831x-dcdc: Use regulator_get_voltage_sel_regmap()
      regulator: wm831x-ldo: Use regulator_get_voltage_sel_regmap()
      regulator: wm8994: Use core voltage selector operations
      regulator: core: Provide standard enable operations for regmap users
      regulator: wm831x-dcdc: Use generic regmap enable/disable operations
      regulator: wm831x-ldo: Use generic regmap enable/disable operations
      mfd: Revert "mfd: add irq domain support for max8997 interrupts"
      regulator: core: Optimise enable/disable path for always on regulators
      regulator: wm831x-ldo: Set up supply names
      regulator: wm831x-dcdc: Specify supply names
      regulator: wm8994: Convert to gpio_request_one()
      regulator: wm831x-dcdc: Convert to gpio_request_one()
      regulator: wm8994: Use main I2C device as struct device
      regulator: wm831x: Register all normal regulators
      regulator: dummy: Specify a struct device
      regulator: core: Warn on missing struct device
      Merge remote-tracking branches 'regulator/topic/core', 'regulator/topic/regmap' and 'regulator/topic/register' into regulator-next
      Merge remote-tracking branch 'regulator/topic/drivers' into regulator-next
      regulator: core: Allow regulators to provide a voltage to selector mapping
      regulator: core: Allow drivers to set simple linear voltage maps as data
      regulator: wm831x: Convert to regulator_list_voltage_linear()
      regulator: wm8400: Modernise driver
      regulator: Staticise non-exported symbol s5m8767_opmode_reg
      regulator: core: Release regulator-regulator supplies on error
      regulator: wm831x-dcdc: Add missing checks for pdata before use
      regulator: core: Don't open code _regulator_is_enabled()
      regulator: wm8994: Allow registration with no platform data
      mfd: tpx6586x:  Depend on regulator

NeilBrown (2):
      mfd: twl: define all feature flags in one place.
      regulator: twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more configurable.

Rhyland Klein (1):
      regulator: tps65910 regulator: add device tree support

Sangbeom Kim (2):
      mfd: Add s5m regulator operation mode
      regulator: Add support s5m8767 opmode operation

Thierry Reding (2):
      regulator: Add generic DT parsing for regulators
      tps6586x: Add device tree support

Thomas Abraham (1):
      mfd: add irq domain support for max8997 interrupts

Venu Byravarasu (1):
      regulator: Add TPS65090 regulator driver

Ying-Chun Liu (PaulLiu) (2):
      regulator: da9052: add device tree support
      regulator: da9052: fix bug in device tree iteration loop

 .../bindings/regulator/fixed-regulator.txt         |    5 +-
 .../bindings/regulator/tps62360-regulator.txt      |   44 ++
 .../devicetree/bindings/regulator/tps6586x.txt     |   97 +++
 Documentation/power/regulator/regulator.txt        |    3 +-
 drivers/mfd/Kconfig                                |    1 +
 drivers/mfd/tps65090.c                             |   11 -
 drivers/mfd/tps6586x.c                             |   86 ++
 drivers/mfd/twl-core.c                             |    7 -
 drivers/regulator/88pm8607.c                       |  179 ++---
 drivers/regulator/Kconfig                          |   33 +-
 drivers/regulator/Makefile                         |    5 +-
 drivers/regulator/aat2870-regulator.c              |   10 +-
 drivers/regulator/ab3100.c                         |   65 +-
 drivers/regulator/ab8500.c                         |  235 +++---
 drivers/regulator/ad5398.c                         |   19 +-
 drivers/regulator/anatop-regulator.c               |    9 +-
 drivers/regulator/core.c                           |  456 ++++++++---
 drivers/regulator/da903x.c                         |  209 ++---
 drivers/regulator/da9052-regulator.c               |  441 ++++-------
 drivers/regulator/db8500-prcmu.c                   |  133 +++-
 drivers/regulator/dummy.c                          |    7 +-
 drivers/regulator/fixed.c                          |   69 +-
 drivers/regulator/gpio-regulator.c                 |   22 +-
 drivers/regulator/isl6271a-regulator.c             |   73 +-
 drivers/regulator/lp3971.c                         |   87 +--
 drivers/regulator/lp3972.c                         |   74 +-
 drivers/regulator/max1586.c                        |   28 +-
 drivers/regulator/max8649.c                        |  110 +--
 drivers/regulator/max8660.c                        |  165 ++--
 drivers/regulator/max8925-regulator.c              |   83 +-
 drivers/regulator/max8952.c                        |   70 +-
 drivers/regulator/max8997.c                        |  342 ++++----
 drivers/regulator/max8998.c                        |  122 +--
 drivers/regulator/mc13783-regulator.c              |   12 +-
 drivers/regulator/mc13892-regulator.c              |   25 +-
 drivers/regulator/mc13xxx-regulator-core.c         |   54 +-
 drivers/regulator/mc13xxx.h                        |    2 -
 drivers/regulator/of_regulator.c                   |   47 ++
 drivers/regulator/palmas-regulator.c               |  822 ++++++++++++++++++++
 drivers/regulator/pcap-regulator.c                 |   54 +-
 drivers/regulator/pcf50633-regulator.c             |  199 ++---
 drivers/regulator/rc5t583-regulator.c              |  255 ++++++
 drivers/regulator/s5m8767.c                        |  327 ++++----
 drivers/regulator/tps6105x-regulator.c             |   11 +-
 drivers/regulator/tps62360-regulator.c             |  380 +++++----
 drivers/regulator/tps65023-regulator.c             |  244 ++----
 drivers/regulator/tps6507x-regulator.c             |   22 +-
 drivers/regulator/tps65090-regulator.c             |  150 ++++
 drivers/regulator/tps65217-regulator.c             |   78 +-
 drivers/regulator/tps6524x-regulator.c             |   47 +-
 drivers/regulator/tps6586x-regulator.c             |  108 +--
 drivers/regulator/tps65910-regulator.c             |  323 ++++----
 drivers/regulator/tps65912-regulator.c             |   60 +-
 drivers/regulator/twl-regulator.c                  |  127 ++-
 drivers/regulator/userspace-consumer.c             |   20 +-
 drivers/regulator/virtual.c                        |   26 +-
 drivers/regulator/wm831x-dcdc.c                    |  174 ++---
 drivers/regulator/wm831x-isink.c                   |    8 +-
 drivers/regulator/wm831x-ldo.c                     |  201 ++---
 drivers/regulator/wm8350-regulator.c               |   11 +-
 drivers/regulator/wm8400-regulator.c               |  176 ++---
 drivers/regulator/wm8994-regulator.c               |  111 +--
 include/linux/i2c/twl.h                            |   13 +-
 include/linux/mfd/rc5t583.h                        |   29 +
 include/linux/mfd/s5m87xx/s5m-core.h               |    1 +
 include/linux/mfd/s5m87xx/s5m-pmic.h               |   29 +
 include/linux/mfd/tps65090.h                       |   13 +
 include/linux/mfd/tps6586x.h                       |    1 +
 include/linux/regulator/driver.h                   |   73 +-
 include/linux/regulator/fixed.h                    |    7 +
 include/linux/regulator/of_regulator.h             |   18 +
 include/linux/regulator/tps62360.h                 |    6 +-
 include/linux/regulator/tps65090-regulator.h       |   50 ++
 sound/soc/codecs/sgtl5000.c                        |    8 +-
 74 files changed, 4348 insertions(+), 3274 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps6586x.txt
 create mode 100644 drivers/regulator/palmas-regulator.c
 create mode 100644 drivers/regulator/rc5t583-regulator.c
 create mode 100644 drivers/regulator/tps65090-regulator.c
 create mode 100644 include/linux/regulator/tps65090-regulator.h

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuh2kAAoJEBus8iNuMP3dy3QP/jB/gWUPXAVUo64acGnCcMOh
AD7zRbOcFT5PGzeA1ynWBWaDN/pR34Fsz+6dB850LNHlUW5jKnv29uIY7ePtWz80
fr0TMGhjiKpuW3GJvZediwT+41c0mVC3nTluSUartW5ZQZc+stDAWh/JIRUjOTpP
tSnVQVGvF6U+9O+/jqJGudbrXpIET4LUwaN2PVWqTFeSe0ROEtpyc4gXuGOm3wTb
fnWijdwQfuLPFWTNgQ1J1tmoKruZriquvU6TwKQORvlk4hvB6gWHXXZ2X5FhXBCu
+oXT2ufZtlpHE5vUwgMcY2nJm7uyucBrC0NRGDbOgwYbf/Xec0PgARrBkhUbQRwC
lDctx33Z5b1E5HKmeoNAxj66RZhSQv3Wt80AFlSGpMHFXQCcbqyekVzB4VubbAA6
qO93kw49y2WEPlc3GDUnr/nbKBFcjol3VwnCs0S/7Flhv3qFWIi9lt55eENHOQxZ
G7mQAnmxw7wWnhOjBu8oxd/sOxsiYM+UufoyMsxE63wh3nVuXLYT17/zQZAmnTsX
x5CU04H2XKG5n7yRehzEbvPKK1KRehvVH1zYo89slmboSD1SVI5B1kJz7U6BkFmc
ippixuHuQtIRJxAKPVBTivsytEgTniSSBBCOMAjHt4/jn7yBRxpwc2+ww8XsiFDt
y069yJKw5hcAq8d+DkxU
=Aoez
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
