Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2EZOG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 10:06:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34093 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2EZOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 10:06:55 -0400
Date: Sat, 26 May 2012 16:06:50 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Arnd Bergmann <arnd@arndb.de>, Roland Stigge <stigge@antcom.de>
Subject: [PULL REQUEST] i2c-embedded for 3.5
Message-ID: <20120526140650.GA7133@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
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


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here is the pull request for the embedded part of the i2c subsystem.
Major changes:

- lots of devicetree additions for existing drivers. I tried hard to
  make sure the bindings are proper. In more complicated cases, I
  requested acks from people having more experience with them than me.
  That took a bit of extra time and also some time went into discussions
  with developers about what bindings are and what not. I have the
  feeling that the workflow with bindings should be improved to scale
  better. I will spend some more thought on this...

- i2c-muxes are succesfully used meanwhile, so we dropped EXPERIMENTAL
  for them and renamed the drivers to a standard pattern to match the
  rest of the subsystem. They can also be used with devicetree now.

- ixp2000 was removed since the whole platform goes away.

- cleanups (strlcpy instead of strcpy, NULL instead of 0)

- The rest is typical driver fixes I assume.

All patches have been in linux-next at least since v3.4-rc6.

Note that you will get a trivial merge-conflict because some
lpc32xx-patches have already come in via arm-soc to reduce dependencies.
I read that you want to see such conflicts so I didn't take any actions.
I'll add Arnd and Roland to CC, because they know best about LPC32xx
changes.

Thanks,

   Wolfram

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-next

for you to fetch changes up to 9868a060ccf769c08ec378a9829137e272e9a92c:

  i2c: davinci: Free requested IRQ in remove (2012-05-12 20:36:24 +0200)

----------------------------------------------------------------
David Daney (2):
      i2c: Add a struct device * parameter to i2c_add_mux_adapter()
      i2c/of: Automatically populate i2c mux busses from device tree data.

Deepak Sikri (1):
      i2c: designware: add PM support

Ganesan Ramalingam (1):
      i2c: ocores: register OF i2c devices

Jean Delvare (1):
      i2c: Rename last mux driver to standard pattern

Karol Lewandowski (5):
      i2c-s3c2410: Drop unused define
      i2c-pxa: Drop leftover comment
      i2c: Dynamically assign adapter id if it wasn't explictly specified
      i2c-s3c2410: Rework device type handling
      i2c-s3c2410: Add HDMIPHY quirk for S3C2440

Lars-Peter Clausen (1):
      I2C: xiic: Add OF binding support

Laxman Dewangan (2):
      i2c: tegra: fix 10bit address configuration
      i2c: tegra: notify transfer-complete after clearing status.

Magnus Damm (1):
      i2c: sh_mobile: add device tree support

Marcus Folkesson (1):
      i2c: davinci: Free requested IRQ in remove

Rob Herring (1):
      i2c: ixp2000: remove driver

Roland Stigge (3):
      i2c-pnx.c: Use resources in platforms
      i2c-pnx.c: Remove duplicated i2c.h
      i2c: pnx: add device tree support

Stefan Roese (1):
      i2c: designware: Add support for 16bit register access

Stephen Warren (3):
      of/i2c: call i2c_verify_client from of_find_i2c_device_by_node
      i2c: implement i2c_verify_adapter
      of/i2c: implement of_find_i2c_adapter_by_node

Tomoya MORINAGA (3):
      i2c-eg20t: Call init() when wait-event timeout occurs
      i2c-eg20t: add helper function for xfer check
      i2c-eg20t: Merge two functions

Viresh Kumar (1):
      i2c: designware: Add clk_{un}prepare() support

Wolfram Sang (7):
      i2c: eg20t: use NULL instead of 0
      i2c: eg20t: pass on return value in i2c_xfer
      i2c: eg20t: remove unused function
      i2c: eg20t: don't use strcpy but strlcpy
      i2c: imx: don't use strcpy but strlcpy
      i2c: muxes are not EXPERIMENTAL anymore
      i2c: muxes: rename first set of drivers to a standard pattern

Zhao Chenhui (1):
      i2c-mpc: avoid I2C abnormal after resuming from deep sleep

 Documentation/devicetree/bindings/i2c/mux.txt      |   60 +++++
 Documentation/devicetree/bindings/i2c/pnx.txt      |   36 +++
 .../devicetree/bindings/i2c/samsung-i2c.txt        |    8 +-
 Documentation/devicetree/bindings/i2c/xiic.txt     |   22 ++
 .../i2c/muxes/{gpio-i2cmux =3D> i2c-mux-gpio}        |   12 +-
 MAINTAINERS                                        |    8 +-
 arch/arm/mach-lpc32xx/common.c                     |   67 ++++--
 arch/arm/mach-lpc32xx/include/mach/i2c.h           |   63 -----
 arch/arm/mach-pnx4008/i2c.c                        |   64 +++--
 arch/arm/mach-pnx4008/include/mach/i2c.h           |   64 -----
 drivers/i2c/Kconfig                                |    1 -
 drivers/i2c/busses/Kconfig                         |   14 --
 drivers/i2c/busses/Makefile                        |    1 -
 drivers/i2c/busses/i2c-davinci.c                   |    2 +-
 drivers/i2c/busses/i2c-designware-core.c           |   31 ++-
 drivers/i2c/busses/i2c-designware-core.h           |    5 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   33 ++-
 drivers/i2c/busses/i2c-eg20t.c                     |  246 ++++++----------=
----
 drivers/i2c/busses/i2c-gpio.c                      |    7 +-
 drivers/i2c/busses/i2c-imx.c                       |    2 +-
 drivers/i2c/busses/i2c-ixp2000.c                   |  157 -------------
 drivers/i2c/busses/i2c-mpc.c                       |   30 +++
 drivers/i2c/busses/i2c-ocores.c                    |    3 +
 drivers/i2c/busses/i2c-pca-platform.c              |    2 +-
 drivers/i2c/busses/i2c-pnx.c                       |  157 +++++++++----
 drivers/i2c/busses/i2c-pxa.c                       |    5 -
 drivers/i2c/busses/i2c-s3c2410.c                   |  109 +++++----
 drivers/i2c/busses/i2c-sh_mobile.c                 |   11 +
 drivers/i2c/busses/i2c-tegra.c                     |   24 +-
 drivers/i2c/busses/i2c-versatile.c                 |    9 +-
 drivers/i2c/busses/i2c-xiic.c                      |   23 +-
 drivers/i2c/i2c-core.c                             |   17 ++
 drivers/i2c/i2c-mux.c                              |   42 +++-
 drivers/i2c/muxes/Kconfig                          |    6 +-
 drivers/i2c/muxes/Makefile                         |    6 +-
 .../i2c/muxes/{gpio-i2cmux.c =3D> i2c-mux-gpio.c}    |   42 ++--
 drivers/i2c/muxes/{pca9541.c =3D> i2c-mux-pca9541.c} |    3 +-
 drivers/i2c/muxes/{pca954x.c =3D> i2c-mux-pca954x.c} |    2 +-
 drivers/of/of_i2c.c                                |   16 +-
 include/linux/{gpio-i2cmux.h =3D> i2c-mux-gpio.h}    |   14 +-
 include/linux/i2c-mux.h                            |    3 +-
 include/linux/i2c-pnx.h                            |   10 +-
 include/linux/i2c.h                                |    1 +
 include/linux/of_i2c.h                             |    4 +
 44 files changed, 720 insertions(+), 722 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/mux.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/pnx.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/xiic.txt
 rename Documentation/i2c/muxes/{gpio-i2cmux =3D> i2c-mux-gpio} (85%)
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/i2c.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/i2c.h
 delete mode 100644 drivers/i2c/busses/i2c-ixp2000.c
 rename drivers/i2c/muxes/{gpio-i2cmux.c =3D> i2c-mux-gpio.c} (73%)
 rename drivers/i2c/muxes/{pca9541.c =3D> i2c-mux-pca9541.c} (99%)
 rename drivers/i2c/muxes/{pca954x.c =3D> i2c-mux-pca954x.c} (99%)
 rename include/linux/{gpio-i2cmux.h =3D> i2c-mux-gpio.h} (74%)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/A43oACgkQD27XaX1/VRvk7wCfSXRDuUEepiVZwEuofAat9How
GowAn0xTXUw8TjIRfJpofssbSzKNtsay
=loD7
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
