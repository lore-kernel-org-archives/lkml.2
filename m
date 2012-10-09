Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2JIJEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:04:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2JIJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:04:00 -0400
Date: Tue, 9 Oct 2012 11:03:55 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c-embedded for 3.7
Message-ID: <20121009090355.GA19313@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
X-Mutt-PGP: S<0x7D7F551B>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull the changes for i2c-embedded for the 3.7 kernel. They include:

- massive rework of the omap driver
- massive rework of the at91 driver. In fact, the old driver gets removed; =
I am
  okay with this approach since the old driver was depending on BROKEN
  and its limitations made it practically unusable, so people used bitbangi=
ng
  instead. But even if there are users, there is no platform_data or module
  parameter which would need to be converted. It is just another driver doi=
ng
  I2C transfers, just way better. Modifications of arch/arm/at91 related fi=
les
  have proper acks from the maintainer.
- new driver for R-Car I2C
- devicetree and generic_clock conversions and fixes
- ususal driver fixes and changes.

The rework patches have come a long way and lots of people have been involv=
ed
in creating/testing them. Most patches have been in linux-next at least sin=
ce
3.6-rc5. A few have been added in the last week, I have to admit. An unexpe=
cted
(but welcome :)) peak in private life is the cause for that. The "late" pat=
ches
shouldn't cause any merge conflicts and I will have a special eye on them
during the stabilization phase. This is an exception and I want to have the
patches in place properly in time again for the next kernels. So, please pu=
ll.

Regards,

   Wolfram

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-next

for you to fetch changes up to 62885f59a26195d9f6a3f8c795225dfbab62a110:

  MXS: Implement DMA support into mxs-i2c (2012-10-08 12:47:33 +0200)

----------------------------------------------------------------
Fabio Estevam (2):
      i2c: imx: Use dev_info to indicate that i2c driver was succesfully re=
gistered
      i2c: imx: Use dev_dbg logging style

Felipe Balbi (21):
      i2c: omap: switch to devm_* API
      i2c: omap: simplify num_bytes handling
      i2c: omap: decrease indentation level on data handling
      i2c: omap: add blank lines
      i2c: omap: simplify omap_i2c_ack_stat()
      i2c: omap: split out [XR]DR and [XR]RDY
      i2c: omap: improve i462 errata handling
      i2c: omap: re-factor receive/transmit data loop
      i2c: omap: switch over to do {} while loop
      i2c: omap: ack IRQ in parts
      i2c: omap: switch to platform_get_irq()
      i2c: omap: bus: add a receiver flag
      i2c: omap: simplify errata check
      i2c: omap: always return IRQ_HANDLED
      i2c: omap: simplify IRQ exit path
      i2c: omap: resize fifos before each message
      i2c: omap: get rid of the "complete" label
      i2c: omap: switch to threaded IRQ support
      i2c: omap: remove unnecessary pm_runtime_suspended check
      i2c: omap: switch over to autosuspend API
      i2c: omap: sanitize exit path

Florian Vaussard (1):
      omap-i2c: fix incorrect log message when using a device tree

Heiko Schocher (1):
      i2c: davinci: add OF support

Jean Pihet (1):
      ARM: OMAP: convert I2C driver to PM QoS for MPU latency constraints

Joakim Tjernlund (1):
      i2c: mpc: Wait for STOP to hit the bus

Kuninori Morimoto (1):
      i2c: add Renesas R-Car I2C driver

Lee Jones (1):
      i2c: nomadik: Add Device Tree support to the Nomadik I2C driver

Linus Walleij (1):
      i2c: nomadik: stop fetching the regulator

Ludovic Desroches (5):
      ARM: at91: do not configure at91sam9g10 twi pio as open-drain
      i2c: at91: add dt support to i2c-at91
      ARM: at91: add clocks for I2C DT entries
      ARM: dts: add twi nodes for atmel SoCs
      ARM: dts: add twi nodes for atmel boards

Marek Vasut (1):
      MXS: Implement DMA support into mxs-i2c

Murali Karicheri (1):
      i2c: davinci: preparation for switch to common clock framework

Nikolaus Voss (4):
      Replace clk_lookup.con_id with clk_lookup.dev_id entries for twi clk
      i2c: at91: remove old polling driver
      i2c: at91: add new driver
      arm: at91: G45 TWI: remove open drain setting for twi function gpios

Shubhrajyoti D (1):
      i2c: omap: remove redundant status read

Thomas Abraham (1):
      i2c: s3c2410: use clk_prepare_enable and clk_disable_unprepare

Thomas Kavanagh (1):
      i2c: algo: pca: Fix chip reset function for PCA9665

Wolfram Sang (1):
      Merge tag 'v3.6-rc7' into i2c-embedded/for-next

 .../devicetree/bindings/i2c/atmel-i2c.txt          |   30 +
 Documentation/devicetree/bindings/i2c/davinci.txt  |   28 +
 Documentation/devicetree/bindings/i2c/i2c-mxs.txt  |    2 +
 Documentation/devicetree/bindings/i2c/nomadik.txt  |   23 +
 arch/arm/boot/dts/at91sam9260.dtsi                 |   10 +
 arch/arm/boot/dts/at91sam9263.dtsi                 |   10 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |    4 +
 arch/arm/boot/dts/at91sam9g25ek.dts                |   12 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   20 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    8 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   20 +
 arch/arm/boot/dts/at91sam9n12ek.dts                |    8 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   30 +
 arch/arm/boot/dts/imx28.dtsi                       |    2 +
 arch/arm/mach-at91/at91rm9200.c                    |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c            |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |    3 +
 arch/arm/mach-at91/at91sam9260_devices.c           |    8 +-
 arch/arm/mach-at91/at91sam9261.c                   |    2 +
 arch/arm/mach-at91/at91sam9261_devices.c           |   14 +-
 arch/arm/mach-at91/at91sam9263.c                   |    2 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    4 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |   10 +-
 arch/arm/mach-at91/at91sam9n12.c                   |    2 +
 arch/arm/mach-at91/at91sam9rl.c                    |    2 +
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-at91/at91sam9x5.c                    |    3 +
 arch/arm/mach-at91/include/mach/at91_twi.h         |   68 --
 arch/arm/plat-omap/i2c.c                           |   21 -
 drivers/i2c/algos/i2c-algo-pca.c                   |   27 +-
 drivers/i2c/busses/Kconfig                         |   27 +-
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-at91.c                      |  667 ++++++++++++----=
--
 drivers/i2c/busses/i2c-davinci.c                   |   58 +-
 drivers/i2c/busses/i2c-imx.c                       |    6 +-
 drivers/i2c/busses/i2c-mpc.c                       |   18 +-
 drivers/i2c/busses/i2c-mxs.c                       |  269 +++++++-
 drivers/i2c/busses/i2c-nomadik.c                   |   52 +-
 drivers/i2c/busses/i2c-omap.c                      |  474 ++++++++-----
 drivers/i2c/busses/i2c-rcar.c                      |  709 ++++++++++++++++=
++++
 drivers/i2c/busses/i2c-s3c2410.c                   |   18 +-
 include/linux/i2c-algo-pca.h                       |    1 +
 include/linux/i2c-omap.h                           |    1 -
 include/linux/i2c/i2c-rcar.h                       |   10 +
 include/linux/platform_data/i2c-nomadik.h          |    2 +-
 46 files changed, 2096 insertions(+), 597 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/atmel-i2c.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/davinci.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/nomadik.txt
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_twi.h
 create mode 100644 drivers/i2c/busses/i2c-rcar.c
 create mode 100644 include/linux/i2c/i2c-rcar.h

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBz6HsACgkQD27XaX1/VRt8ygCbBQbPadHusdAISaKEUSb615Kt
ui4AniHTfj2jOauKrNXoTZ8DJA/jEMp5
=PVvW
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
