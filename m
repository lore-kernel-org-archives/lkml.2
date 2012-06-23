Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2FWMyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:54:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45487 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab2FWMyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:54:49 -0400
Date: Sat, 23 Jun 2012 13:54:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/7] mfd: Wolfson Arizona and WM5102 support
Message-ID: <20120623125446.GX4037@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aIPTgi9H47uqouUT"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aIPTgi9H47uqouUT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch series adds the MFD core driver for the WM5102 and other
Wolfson Arizona class devices. =20

The series has a dependency on a new regmap feature, support for wake
IRQs.  Assuming the code is OK I don't know how you want to handle this
- I've provided a pull request below which in turn pulls in a signed tag
=66rom the regmap tree so you can pull into the MFD tree providing you
there's no rebases.  Alternatively I could carry the code in the regmap
tree, though that might get a bit silly as it'll dwarf the actual
changes in there.

The following changes since commit 485802a6c524e62b5924849dd727ddbb1497cc71:

  Linux 3.5-rc3 (2012-06-16 17:25:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd/w=
m5102

for you to fetch changes up to 3afbac957e3c59037a4ecaf19d68f6c8104299fc:

  mfd: wm5102: Build system hookup (2012-06-23 13:30:43 +0100)

----------------------------------------------------------------
mfd: Initial support for Wolfson Arizona platform and WM5102 devices

The Wolfson Arizona platform is used to provide common register
interface to a series of low power audio hub CODECs, starting with the
WM5102. Since the features of these devices work over a range of
subsystems an MFD core driver is provided to instantiate the subdevices
and arbitrate access between them.

As the new regmap wake IRQ functionality is used as part of the driver
it is incorporated as a dependency.

----------------------------------------------------------------
Mark Brown (10):
      regmap: Don't try to map non-existant IRQs
      regmap: Implement support for wake IRQs
      Merge branch 'topic/irq' of git://git.kernel.org/.../broonie/regmap i=
nto wm5102
      mfd: arizona: Register definitions
      mfd: arizona: Core driver
      mfd: arizona: Interrupt support
      mfd: arizona: I2C bus interface
      mfd: arizona: SPI bus interface
      mfd: wm5102: Initial support for WM5102
      mfd: wm5102: Build system hookup

 drivers/base/regmap/regmap-irq.c      |   51 +
 drivers/mfd/Kconfig                   |   29 +
 drivers/mfd/Makefile                  |    7 +
 drivers/mfd/arizona-core.c            |  527 +++
 drivers/mfd/arizona-i2c.c             |   89 +
 drivers/mfd/arizona-irq.c             |  267 ++
 drivers/mfd/arizona-spi.c             |   91 +
 drivers/mfd/arizona.h                 |   33 +
 drivers/mfd/wm5102-tables.c           | 2399 +++++++++++++
 include/linux/mfd/arizona/core.h      |  102 +
 include/linux/mfd/arizona/pdata.h     |  119 +
 include/linux/mfd/arizona/registers.h | 6222 +++++++++++++++++++++++++++++=
++++
 include/linux/regmap.h                |    2 +
 13 files changed, 9938 insertions(+)
 create mode 100644 drivers/mfd/arizona-core.c
 create mode 100644 drivers/mfd/arizona-i2c.c
 create mode 100644 drivers/mfd/arizona-irq.c
 create mode 100644 drivers/mfd/arizona-spi.c
 create mode 100644 drivers/mfd/arizona.h
 create mode 100644 drivers/mfd/wm5102-tables.c
 create mode 100644 include/linux/mfd/arizona/core.h
 create mode 100644 include/linux/mfd/arizona/pdata.h
 create mode 100644 include/linux/mfd/arizona/registers.h

--aIPTgi9H47uqouUT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5byOAAoJEBus8iNuMP3d6VoP/23FreShLgNYtUdwvPxA1X6c
xVMBASxSbmUVQliq1DdevHdeEfbqluOKyabCndEAcq5J85CUC/yuGDd4kqN0KUoq
0DDOb1DkhVI9a5OVylQrMeouciCl3nTkDGe/Fa2RDkTua57flqpplzBuAIetVn5B
C07skCanuVN34CuJ1BjieyIIXXCX99bmFLe0HTN7Bn/n/Wc6VZgh/StwaYcUiie9
aoxBNjqLWx26kiCKkdokAYuESvhGGjQHhSME+tYKFUNPUHm8i7kJCv4CQ5+Um9S4
YyZ+FoCDypBoYSvw9IZdcCKw13HyYSKMXtru1i3IjRT+zGTeCQMUiADeynl659/2
VfRxK/xhcyx3OIGIIY0Zhw3wJ/afHj0M+qa0vRaosLwNcDZkc5iMp1F6eNEp5mB1
4tffPITkMDPH/Nwpx1rxmoBc+ZSog7kuh/rCjel2oafFKcbUtxw0opZ8g63bcmia
ctpfrhCydgE1UMqBpddbbvcOLn3blStdcjjvSq2lfVYMfpVXy2HUa1f3S5xS3Uvw
r10yWGRhovJ+UMv4a/twQSuBjMQsYFXjnR9zhtRWjiOnSEIqW9w5+os/CHdYN6lw
N2NLIwmSLkVDzAGFuOlrYZI1aDL7nTnrfz+6llsYouR8I7dPAOmKdKZ2nBNPuPeu
M0Iq/9IU1fd7YX3lTRxv
=NZJf
-----END PGP SIGNATURE-----

--aIPTgi9H47uqouUT--
