Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab2CVEIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 00:08:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2CVEIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 00:08:41 -0400
Date: Wed, 21 Mar 2012 21:08:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.4-rc0
Message-ID: <20120322040836.GC20427@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get:

- we finally merged driver for USB version of Synaptics touchpads
  (I guess most commonly found in IBM/Lenovo keyboard/touchpad combo);

- a bunch of new drivers for embedded platforms (Cypress touchscreens,
  DA9052 OnKey, MAX8997-haptic, Ilitek ILI210x touchscreens, TI
  touchscreen);

- input core allows clients to specify desired clock source for
  timestamps on input events (EVIOCSCLOCKID ioctl);

- input core allows querying state of all MT slots for given event
  code via EVIOCGMTSLOTS ioctl;

- various driver fixes and improvements.

Thanks!

Changelog:
---------

Andres Salomon (1):
      Input: psmouse - allow drivers to use psmouse_{de,}activate

Armando Visconti (1):
      Input: usbtouchscreen - add support for Data Modul EasyTouch TP 72037

Ashish Jangam (1):
      Input: add support for OnKey module for DA9052/53 PMIC

Axel Lin (2):
      Input: convert SPI drivers to use module_spi_driver()
      Input: convert I2C drivers to use module_i2c_driver()

Chase Douglas (1):
      bcm5974: Add pointer and buttonpad properties

Christopher Hudson (1):
      Input: kxtj9 - who_am_i check value and initial data rate fixes

Dmitry Torokhov (10):
      Input: nomadik-ske-keypad - do not assign driver's probe() method
      Input: nomadik-ske-keypad - convert to using SIMPLE_DEV_PM_OPS
      Input: at32psif - convert to dev_pm_ops
      Input: q40kbd - convert driver to the split model
      Input: cyttsp - remove useless checks in cyttsp_probe()
      Input: atmel-wm97xx - set driver owner
      Input: atmel-wm97xx - convert to dev_pm_ops
      Input: max8925_onkey - avoid accessing input device too early
      Input: twl4030-vibra - really switch from #if to #ifdef
      Input: synaptics_usb - switch to module_usb_driver()

Donggeun Kim (1):
      Input: add driver support for MAX8997-haptic

Felipe Balbi (1):
      Input: omap4-keypad - move platform_data to <linux/platform_data>

Henrik Rydberg (2):
      Input: Use accessor for MT values
      Input: Add EVIOC mechanism for MT slots

Jan Steinhoff (1):
      Input: add Synaptics USB device driver

Jason Gerecke (1):
      Input: wacom - fix physical size calculation for 3rd-gen Bamboo

Javier Martinez Canillas (2):
      Input: add Cypress TTSP capacitive multi-touch screen support
      Input: add cyttsp touchscreen maintainer entry

John Stultz (1):
      Input: add infrastructure for selecting clockid for event time stamps

Julia Lawall (1):
      Input: hp680_ts_input - ensure arguments to request_irq and free_irq =
are compatible

Kevin Liu (1):
      Input: max8925_onkey - allow to be used as a wakeup source

Mark Brown (1):
      Input: samsung-keypad - don't synchronise with runtime PM put

Masanari Iida (1):
      Input: pcf8574_keypad - fix typo in Kconfig

Olivier Sobrie (1):
      Input: ili210x - add support for Ilitek ILI210x based touchscreens

Olof Johansson (2):
      Input: of_keymap - add device tree bindings for simple key matrices
      Input: tegra-kbc - revise device tree support

Paul Fox (1):
      Input: psmouse - use psmouse_[de]activate() from sentelic and hgpk dr=
ivers

Ping Cheng (2):
      Input: wacom - use BTN_TOOL_FINGER to indicate touch device type
      Input: wacom - use switch statement for wacom_tpc_irq()

Rachna Patil (1):
      Input: add support for TI Touchscreen controller

Rajeev Kumar (3):
      Input: spear-keyboard - delete redundant key definitions from 9x9 key=
board
      Input: spear-keyboard - add 6x6 keypad matrix definitions
      Input: spear-keyboard - configure device according to supplied mode

Rakesh Iyer (2):
      Input: tegra-kbc - remove pre-Tegra20 definitions
      Input: tegra-kbc - enable key interrupt for wakeup

Shridhar Rasal (1):
      Input: tegra-kbc - allow skipping setting up some of GPIO pins

Tobias Klauser (1):
      Input: altera_ps2 - use of_match_ptr()

Viresh Kumar (1):
      Input: spear-keyboard - provide thaw and poweroff routines


Diffstat:
--------

 .../devicetree/bindings/input/matrix-keymap.txt    |   19 +
 .../devicetree/bindings/input/tegra-kbc.txt        |   17 +-
 MAINTAINERS                                        |    7 +
 arch/arm/mach-omap2/board-4430sdp.c                |    1 +
 arch/arm/mach-omap2/devices.c                      |    1 +
 arch/arm/mach-tegra/include/mach/kbc.h             |   13 +-
 arch/arm/plat-omap/include/plat/omap4-keypad.h     |    9 -
 arch/arm/plat-spear/include/plat/keyboard.h        |   66 ++-
 arch/m68k/q40/config.c                             |   13 +
 drivers/hid/hid-core.c                             |   10 +
 drivers/hid/hid-ids.h                              |   11 +
 drivers/input/Kconfig                              |    4 +
 drivers/input/Makefile                             |    1 +
 drivers/input/evdev.c                              |   52 ++-
 drivers/input/input.c                              |    2 +-
 drivers/input/joystick/as5011.c                    |   12 +-
 drivers/input/keyboard/Kconfig                     |    2 +-
 drivers/input/keyboard/adp5588-keys.c              |   12 +-
 drivers/input/keyboard/adp5589-keys.c              |   12 +-
 drivers/input/keyboard/lm8323.c                    |   12 +-
 drivers/input/keyboard/max7359_keypad.c            |   12 +-
 drivers/input/keyboard/mcs_touchkey.c              |   13 +-
 drivers/input/keyboard/mpr121_touchkey.c           |   12 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   17 +-
 drivers/input/keyboard/omap4-keypad.c              |    2 +-
 drivers/input/keyboard/qt1070.c                    |   12 +-
 drivers/input/keyboard/qt2160.c                    |   12 +-
 drivers/input/keyboard/samsung-keypad.c            |    6 +-
 drivers/input/keyboard/spear-keyboard.c            |   16 +-
 drivers/input/keyboard/tegra-kbc.c                 |   72 ++-
 drivers/input/misc/Kconfig                         |   24 +-
 drivers/input/misc/Makefile                        |    2 +
 drivers/input/misc/ad714x-i2c.c                    |   12 +-
 drivers/input/misc/ad714x-spi.c                    |   12 +-
 drivers/input/misc/adxl34x-i2c.c                   |   12 +-
 drivers/input/misc/adxl34x-spi.c                   |   12 +-
 drivers/input/misc/bma150.c                        |   13 +-
 drivers/input/misc/cma3000_d0x_i2c.c               |   13 +-
 drivers/input/misc/da9052_onkey.c                  |  169 ++++++
 drivers/input/misc/gp2ap002a00f.c                  |   13 +-
 drivers/input/misc/kxtj9.c                         |   34 +-
 drivers/input/misc/max8925_onkey.c                 |  115 +++--
 drivers/input/misc/max8997_haptic.c                |  407 +++++++++++++
 drivers/input/misc/mma8450.c                       |   12 +-
 drivers/input/misc/mpu3050.c                       |   12 +-
 drivers/input/misc/pcf8574_keypad.c                |   12 +-
 drivers/input/misc/twl4030-vibra.c                 |    2 +-
 drivers/input/mouse/Kconfig                        |   17 +
 drivers/input/mouse/Makefile                       |    1 +
 drivers/input/mouse/bcm5974.c                      |    1 +
 drivers/input/mouse/hgpk.c                         |    9 +-
 drivers/input/mouse/psmouse-base.c                 |   15 +-
 drivers/input/mouse/psmouse.h                      |    2 +
 drivers/input/mouse/sentelic.c                     |   12 +-
 drivers/input/mouse/synaptics_i2c.c                |   13 +-
 drivers/input/mouse/synaptics_usb.c                |  557 +++++++++++++++++
 drivers/input/of_keymap.c                          |   87 +++
 drivers/input/serio/altera_ps2.c                   |    4 +-
 drivers/input/serio/at32psif.c                     |   22 +-
 drivers/input/serio/q40kbd.c                       |  139 +++--
 drivers/input/tablet/wacom_sys.c                   |   10 +-
 drivers/input/tablet/wacom_wac.c                   |   28 +-
 drivers/input/tablet/wacom_wac.h                   |    2 +
 drivers/input/touchscreen/Kconfig                  |   68 +++-
 drivers/input/touchscreen/Makefile                 |    7 +-
 drivers/input/touchscreen/ad7877.c                 |   12 +-
 drivers/input/touchscreen/ad7879-i2c.c             |   12 +-
 drivers/input/touchscreen/ad7879-spi.c             |   12 +-
 drivers/input/touchscreen/ads7846.c                |   12 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |   20 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |   13 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |   12 +-
 drivers/input/touchscreen/bu21013_ts.c             |   25 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c          |   13 +-
 drivers/input/touchscreen/cyttsp_core.c            |  625 ++++++++++++++++=
++++
 drivers/input/touchscreen/cyttsp_core.h            |  149 +++++
 drivers/input/touchscreen/cyttsp_i2c.c             |  136 +++++
 drivers/input/touchscreen/cyttsp_spi.c             |  200 +++++++
 drivers/input/touchscreen/eeti_ts.c                |   14 +-
 drivers/input/touchscreen/egalax_ts.c              |   13 +-
 drivers/input/touchscreen/hp680_ts_input.c         |    2 +-
 drivers/input/touchscreen/ili210x.c                |  360 +++++++++++
 drivers/input/touchscreen/max11801_ts.c            |   13 +-
 drivers/input/touchscreen/mcs5000_ts.c             |   13 +-
 drivers/input/touchscreen/migor_ts.c               |   13 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          |   12 +-
 drivers/input/touchscreen/st1232.c                 |   12 +-
 drivers/input/touchscreen/ti_tscadc.c              |  486 +++++++++++++++
 drivers/input/touchscreen/tsc2005.c                |   12 +-
 drivers/input/touchscreen/tsc2007.c                |   13 +-
 drivers/input/touchscreen/usbtouchscreen.c         |   63 ++
 include/linux/input.h                              |   27 +
 include/linux/input/cyttsp.h                       |   58 ++
 include/linux/input/ili210x.h                      |   10 +
 include/linux/input/kxtj9.h                        |   11 +-
 include/linux/input/matrix_keypad.h                |   19 +
 include/linux/input/mt.h                           |    8 +-
 include/linux/input/ti_tscadc.h                    |   17 +
 include/linux/mfd/max8997.h                        |   53 ++-
 include/linux/platform_data/omap4-keypad.h         |   13 +
 kernel/time/timekeeping.c                          |    2 +
 101 files changed, 4095 insertions(+), 710 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/matrix-keymap.t=
xt
 create mode 100644 drivers/input/misc/da9052_onkey.c
 create mode 100644 drivers/input/misc/max8997_haptic.c
 create mode 100644 drivers/input/mouse/synaptics_usb.c
 create mode 100644 drivers/input/of_keymap.c
 create mode 100644 drivers/input/touchscreen/cyttsp_core.c
 create mode 100644 drivers/input/touchscreen/cyttsp_core.h
 create mode 100644 drivers/input/touchscreen/cyttsp_i2c.c
 create mode 100644 drivers/input/touchscreen/cyttsp_spi.c
 create mode 100644 drivers/input/touchscreen/ili210x.c
 create mode 100644 drivers/input/touchscreen/ti_tscadc.c
 create mode 100644 include/linux/input/cyttsp.h
 create mode 100644 include/linux/input/ili210x.h
 create mode 100644 include/linux/input/ti_tscadc.h
 create mode 100644 include/linux/platform_data/omap4-keypad.h

--=20
Dmitry


--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPaqXEAAoJEH70+W8r6ZYqxB8QAL8fbclyB4cdTa07t4IU60cp
IIqtJnS35C9Edafg+pHKpbbvxf3Fm2BqaecictNzEb3ZVeJLXKZtJdxOG9NUae1v
y+8YuPMzd8+J6Rn9kw8G1x91biS+EpemdUphT1Y6t2JMmIdB7laQ7Jd7xZrnlrA9
yADUvwb9hj+/oMttdu2D2zr6GR6uiYbvp1CvoxJ9xIGaqFJ0161peSy5SRzEV1/I
D3pL9D2sPPI8VMshBZCht1Jxg2gi1yL4H7bnLrcv0IGoK17JZ3OsK2+N7i5SfsSY
9lXMXJ8FaTtGg1yIB9FdlPOUBCKCU6JzpIcf+HTEdRe1XXjiCEQjTx9srlA/ZKSc
uQqlZG1uOfuH/YWCM3DXDMBsMkjJCLQvL7Uf/drS7uD5oqnbEFJ+udjV49RvIvJv
eklcl2HnJutLlU9xafHxmVGfFmdrL6N2ET6OZcX2u/YSereHGz1IYdPjGNmW3tQ9
l3qnutsqGA7hVGa2MFb7vxIv60NAPz0g+VbTtgtj/ojElwTESqxuIAn7H5+DZ3Qx
5PQZLpakj95bD0ZhsfGS+zUEXTcdDU9ZfPLUd9tjjH+oTX+y7RbILdxNJopQmm9q
2co7VK/9owWppXo9oodxuOi59LBD+nGy6ViNpYqVls4qrqTcXgFtPMNDCxTzrjry
m52CLFr1rummGHliQdGc
=ArS0
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
