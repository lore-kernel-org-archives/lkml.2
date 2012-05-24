Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2EXIc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:32:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45957 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2EXIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:32:21 -0400
Date: Thu, 24 May 2012 01:32:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524083216.GD10562@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get:

- a bunch of new drivers (DA9052/53 touchscreenn controller, Synaptics
  Navpoint, LM8333 keypads, Wacom I2C touhscreen);
- updates to existing touchpad drivers (ALPS, Sntelic);
- Wacom driver now supports Intuos5;
- device-tree bindings in numerous drivers;
- other cleanups and fixes.

You will get a conflict in wacom_wac.c; please resolve taking "my"
chunks or let me know and I'll merge on my side.

Thanks!


Changelog:
---------

Ashish Jangam (1):
      Input: add support for DA9052/53 touch screen controller

Axel Lin (5):
      Input: serio - add helper macro for serio_driver boilerplate
      Input: serio - use module_serio_driver
      Input: gameport - add helper macro for gameport_driver boilerplate
      Input: gameport - use module_gameport_driver
      Input: use module_pci_driver

Daniel Kurtz (5):
      Input: atmel_mxt_ts - use CONFIG_PM_SLEEP
      Input: atmel_mxt_ts - only allow root to update firmware
      Input: atmel_mxt_ts - verify object size in mxt_write_object
      Input: atmel_mxt_ts - do not read extra (checksum) byte
      Input: atmel_mxt_ts - dump each message on just 1 line

Dmitry Torokhov (21):
      Input: xilinx_ps2 - allocate serio port separately
      Input: st1232 - switch to using SIMPLE_DEV_PM_OPS
      Input: wacom_i2c - do not use irq_to_gpio
      Input: ep93xx_keypad - switch to using dev_pm_ops
      Input: matrix-keypad - fix 'duplicate const' sparse warning
      Input: matrix-keypad - allocate keycodes with keypad structure
      Input: matrix-keypad - undo GPIO setup if input_register_device fails
      Input: cma3000-d0x - remove unneeded checks
      Input: tc3589x-keypad - remove unnecessary checks
      Input: serio_raw - ensure we don't block in non-blocking read
      Input: wacom - fix sparse warning
      Input: wacom - return proper error if usb_get_extra_descriptor() fails
      Input: wacom - use dev_xxx() instead of naked printk()s and dbg()s
      Input: serio_raw - signal EFAULT even if read/write partially succeeds
      Input: evdev - properly access RCU-protected 'grab' data
      Input: evdev - properly handle read/write with count 0
      Input: ALPS - switch to using input_mt_report_finger_count
      MAINTAINERS: adjust input-related patterns
      Input: matrix-keymap - uninline and prepare for device tree support
      Input: matrix-keymap - wire up device tree support
      Input: matrix-keymap - fix building keymaps

George Pantalos (1):
      Input: ALPS - add semi-MT support for v4 protocol

JJ Ding (1):
      Input: synaptics - fix compile warning

Jason Gerecke (4):
      Input: wacom - add basic Intuos5 support
      Input: wacom - add Intuos5 Touch Ring/ExpressKey support
      Input: wacom - add Intuos5 Touch Ring LED support
      Input: wacom - add Intuos5 multitouch sensor support

Jean-Fran=E7ois Dagenais (1):
      Input: adp5588 - add support for gpio names

Jesper Juhl (1):
      Input: atkbd - fix language in a printed message

Julia Lawall (1):
      Input: aiptek - adjust error-handling code label

Magnus Damm (1):
      Input: st1232 - add device tree support

Paul Parsons (1):
      Input: Add Synaptics NavPoint (PXA27x SSP/SPI) driver

Peter Ujfalusi (1):
      Input: tl6040-vibra - Device Tree support

Ping Cheng (2):
      Input: wacom - retrieve maximum number of touch points
      Input: wacom - add 0xE5 (MT device) support

Poddar, Sourav (1):
      Input: omap-keypad - dynamically handle register offsets

Roland Stigge (2):
      Input: lpc32xx_ts - add device tree support
      Input: lpc32xx_ts - fix device tree compatible string

Shawn Landden (2):
      Input: usbtouchscreen - fix typo
      Input: usbtouchscreen - only expose e2i configure option in expert mo=
de

Stephen Warren (1):
      Input: mpu3050 - set IRQF_ONESHOT when requesting the interrupt

Tai-hwa Liang (1):
      Input: sentelic - report device's production serial number

Tatsunosuke Tobita (1):
      Input: add support for Wacom Stylus device with I2C interface

Viresh Kumar (2):
      Input: spear-keyboard - add device tree bindings
      Input: spear-keyboard - document DT bindings

Wolfram Sang (1):
      Input: add support for LM8333 keypads


Diffstat:
--------

 Documentation/ABI/testing/sysfs-driver-wacom       |   15 +-
 .../devicetree/bindings/input/spear-keyboard.txt   |   20 +
 .../bindings/input/touchscreen/lpc32xx-tsc.txt     |   16 +
 .../devicetree/bindings/input/twl6040-vibra.txt    |   37 ++
 MAINTAINERS                                        |    2 +
 drivers/input/Kconfig                              |   17 +-
 drivers/input/Makefile                             |    2 +-
 drivers/input/evdev.c                              |   69 +++--
 drivers/input/gameport/emu10k1-gp.c                |   13 +-
 drivers/input/gameport/fm801-gp.c                  |   16 +-
 drivers/input/joystick/a3d.c                       |   13 +-
 drivers/input/joystick/adi.c                       |   17 +-
 drivers/input/joystick/cobra.c                     |   13 +-
 drivers/input/joystick/gf2k.c                      |   13 +-
 drivers/input/joystick/grip.c                      |   13 +-
 drivers/input/joystick/grip_mp.c                   |   13 +-
 drivers/input/joystick/guillemot.c                 |   13 +-
 drivers/input/joystick/interact.c                  |   13 +-
 drivers/input/joystick/joydump.c                   |   13 +-
 drivers/input/joystick/magellan.c                  |   17 +-
 drivers/input/joystick/sidewinder.c                |   13 +-
 drivers/input/joystick/spaceball.c                 |   17 +-
 drivers/input/joystick/spaceorb.c                  |   17 +-
 drivers/input/joystick/stinger.c                   |   17 +-
 drivers/input/joystick/tmdc.c                      |   13 +-
 drivers/input/joystick/twidjoy.c                   |   17 +-
 drivers/input/joystick/warrior.c                   |   17 +-
 drivers/input/joystick/zhenhua.c                   |   17 +-
 drivers/input/keyboard/Kconfig                     |   32 ++-
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/adp5588-keys.c              |    1 +
 drivers/input/keyboard/atkbd.c                     |    2 +-
 drivers/input/keyboard/ep93xx_keypad.c             |   44 +--
 drivers/input/keyboard/hil_kbd.c                   |   13 +-
 drivers/input/keyboard/imx_keypad.c                |   17 +-
 drivers/input/keyboard/lkkbd.c                     |   17 +-
 drivers/input/keyboard/lm8333.c                    |  235 +++++++++++++
 drivers/input/keyboard/matrix_keypad.c             |   99 +++---
 drivers/input/keyboard/newtonkbd.c                 |   13 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   20 +-
 drivers/input/keyboard/omap-keypad.c               |   20 +-
 drivers/input/keyboard/omap4-keypad.c              |  133 ++++++--
 drivers/input/keyboard/pmic8xxx-keypad.c           |   20 +-
 drivers/input/keyboard/samsung-keypad.c            |   20 +-
 drivers/input/keyboard/spear-keyboard.c            |   92 ++++--
 drivers/input/keyboard/stmpe-keypad.c              |   16 +-
 drivers/input/keyboard/stowaway.c                  |   13 +-
 drivers/input/keyboard/sunkbd.c                    |   17 +-
 drivers/input/keyboard/tc3589x-keypad.c            |   41 +--
 drivers/input/keyboard/tca8418_keypad.c            |   15 +-
 drivers/input/keyboard/tegra-kbc.c                 |   68 +++--
 drivers/input/keyboard/tnetv107x-keypad.c          |   21 +-
 drivers/input/keyboard/twl4030_keypad.c            |   25 +-
 drivers/input/keyboard/w90p910_keypad.c            |   27 +-
 drivers/input/keyboard/xtkbd.c                     |   13 +-
 drivers/input/matrix-keymap.c                      |  163 +++++++++
 drivers/input/misc/cma3000_d0x.c                   |    2 +-
 drivers/input/misc/mpu3050.c                       |    2 +-
 drivers/input/misc/twl6040-vibra.c                 |   46 ++-
 drivers/input/mouse/Kconfig                        |   12 +
 drivers/input/mouse/Makefile                       |    1 +
 drivers/input/mouse/alps.c                         |   81 ++++-
 drivers/input/mouse/alps.h                         |    2 +
 drivers/input/mouse/navpoint.c                     |  369 ++++++++++++++++=
+++
 drivers/input/mouse/sentelic.c                     |   34 ++-
 drivers/input/mouse/sentelic.h                     |    8 +
 drivers/input/mouse/sermouse.c                     |   13 +-
 drivers/input/mouse/synaptics.c                    |   20 +-
 drivers/input/mouse/vsxxxaa.c                      |   14 +-
 drivers/input/of_keymap.c                          |   87 -----
 drivers/input/serio/pcips2.c                       |   15 +-
 drivers/input/serio/ps2mult.c                      |   13 +-
 drivers/input/serio/serio_raw.c                    |   65 ++--
 drivers/input/serio/xilinx_ps2.c                   |   35 +-
 drivers/input/tablet/aiptek.c                      |    2 +-
 drivers/input/tablet/wacom.h                       |    4 +-
 drivers/input/tablet/wacom_sys.c                   |  244 ++++++++++----
 drivers/input/tablet/wacom_wac.c                   |  298 ++++++++++++++--
 drivers/input/tablet/wacom_wac.h                   |   13 +
 drivers/input/touchscreen/Kconfig                  |   34 ++-
 drivers/input/touchscreen/Makefile                 |    2 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   33 +--
 drivers/input/touchscreen/da9052_tsi.c             |  370 ++++++++++++++++=
++++
 drivers/input/touchscreen/dynapro.c                |   17 +-
 drivers/input/touchscreen/elo.c                    |   17 +-
 drivers/input/touchscreen/fujitsu_ts.c             |   13 +-
 drivers/input/touchscreen/gunze.c                  |   17 +-
 drivers/input/touchscreen/h3600_ts_input.c         |   17 +-
 drivers/input/touchscreen/hampshire.c              |   17 +-
 drivers/input/touchscreen/inexio.c                 |   17 +-
 drivers/input/touchscreen/lpc32xx_ts.c             |   10 +
 drivers/input/touchscreen/mtouch.c                 |   17 +-
 drivers/input/touchscreen/penmount.c               |   17 +-
 drivers/input/touchscreen/st1232.c                 |   20 +-
 drivers/input/touchscreen/touchit213.c             |   17 +-
 drivers/input/touchscreen/touchright.c             |   17 +-
 drivers/input/touchscreen/touchwin.c               |   17 +-
 drivers/input/touchscreen/tsc40.c                  |   12 +-
 drivers/input/touchscreen/wacom_i2c.c              |  282 +++++++++++++++
 drivers/input/touchscreen/wacom_w8001.c            |   13 +-
 include/linux/gameport.h                           |   13 +
 include/linux/i2c/adp5588.h                        |    1 +
 include/linux/input/lm8333.h                       |   24 ++
 include/linux/input/matrix_keypad.h                |   54 +---
 include/linux/input/navpoint.h                     |   12 +
 include/linux/serio.h                              |   13 +
 106 files changed, 2845 insertions(+), 1299 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/spear-keyboard.=
txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/lpc=
32xx-tsc.txt
 create mode 100644 Documentation/devicetree/bindings/input/twl6040-vibra.t=
xt
 create mode 100644 drivers/input/keyboard/lm8333.c
 create mode 100644 drivers/input/matrix-keymap.c
 create mode 100644 drivers/input/mouse/navpoint.c
 delete mode 100644 drivers/input/of_keymap.c
 create mode 100644 drivers/input/touchscreen/da9052_tsi.c
 create mode 100644 drivers/input/touchscreen/wacom_i2c.c
 create mode 100644 include/linux/input/lm8333.h
 create mode 100644 include/linux/input/navpoint.h

--=20
Dmitry


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvfIQAAoJEH70+W8r6ZYqeKsQAJghURy0KertiejPe9qo6l7x
JQbYx5E/+atzK7d6Oi443vOCDrqBb8NQhuy9IBp3cpPS1a8Ew4fkT9n+bImD0ci1
HZSa0Vi9Nv/n7KpisgD2IgLacyPmomgyIY2Ik37ea7bqhS0PkI40c+yKMI3nmdaY
eHIZvq9yK2hRUZu2Xa/K0E1lCAIiIUZuB6DbVMvOfxZUqYEh33AmbvAnilSvoCcs
hpF37L2/q13ztftVfjm+u7fcAOr9g3muG21g2ZirGwvuGXfnVz1QGSKRj2mY4f6Z
yLe2h3LJMzHKZRzj164j0nuOH8PvxTdTAyPb7wulN/2f/2O97q7RRSsy8tC5LPkk
rgA/DQQF0M4lGeOGdCfrqg2yjvmKL5UVQBCe4HVp+YMavQ+m+4BICiAuFPc/Avt1
YEPS6mfabRaAnGDo5gHckRKZf+F8TtbLze66M58b4BgrIdiBDcLzRY80KDJfKZbn
SV3APjJP5uZbtxxRzJGqNIZ/cv9InCW3GuNmSEgxgDoMyPDecRKTLSuCFEfPBV4z
ovnTbWwHB6VWCkRsTSio5fTGtRdFbVfle1FYf4N0sW7KzfpOUXv8gb7PGhG+RrSB
R6KGQx0agpwQm+ep2rLhkdcjAAoODtFfuOjSXZLoQifqBBgUGeZ6H+2wtAGfs7sx
qVNVS+MrsSCdBRfH11oZ
=pPVK
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
