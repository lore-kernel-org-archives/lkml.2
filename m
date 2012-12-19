Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2LSITg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 03:19:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2LSITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 03:19:30 -0500
Date: Wed, 19 Dec 2012 09:19:26 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.8-rc1
Message-ID: <20121219081926.GA31210@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:b1wCUVZshI8twos76ZZvsr570rFHVAvLvJ/cu50251s
 ln6wIkQNSsvaxDWnzDdICf2b7PtVMASqFAyrKgTaRzMAavTdXy
 fhDUAMKXekOJGabgf9Pa6haQfzR0IIyiRNtd3/pIuHbNTJy4MJ
 ak1wpAIIOtM7c9GwsqCXxD+kC+P5alVHu9ZIOnt9k67EW2H+bL
 KnKxPoTv25vf1IfqAj7KT4FygGz4+J5r9uXUbwk54skVNFU6Gq
 EddgBVwvPm0Z/uRN3FQRZDrJtDv52KYvx4appx+4MKjvsI5zaR
 Yf9yErmEM1M9GPjcn1nnge+CpAloj+GEIB/afeqO0JRggPhj/H
 sZcad86mLs8/5R4eFdU6/NjSafGjWFo5mtZ/p9vpwt0w2ENnP9
 iNNMRvvM/sPagnYW8TQxWE+6RiqfIGjGviBuJKTL6aE7HcT5Sk
 Wm0mk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.8-rc1

for you to fetch changes up to 20e8ac3eea4dcfeea6ebeae57cd2c739fa48da11:

  pwm: samsung: add missing s3c->pwm_id assignment (2012-12-14 08:32:58 +01=
00)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.8-rc1

A new driver has been added for the SPEAr platform and the TWL4030/6030
driver has been replaced by two drivers that control the regular PWMs
and the PWM driven LEDs provided by the chips.

The vt8500, tiecap, tiehrpwm, i.MX, LPC32xx and Samsung drivers have all
been improved and the device tree bindings now support the PWM signal
polarity.

----------------------------------------------------------------
Alban Bedel (3):
      pwm: lpc32xx: Fix the PWM polarity
      pwm: lpc32xx: Properly disable the clock on device removal
      pwm: lpc32xx: Set the chip base for dynamic allocation

Axel Lin (1):
      pwm: spear: Staticize spear_pwm_config()

Joonyoung Shim (1):
      pwm: samsung: add missing s3c->pwm_id assignment

Lothar Wa=C3=9Fmann (1):
      pwm: i.MX: eliminate build warning

Peter Ujfalusi (3):
      pwm: New driver to support PWMs on TWL4030/6030 series of PMICs
      pwm: New driver to support PWM driven LEDs on TWL4030/6030 series of =
PMICs
      pwm: Remove pwm-twl6030 driver

Philip, Avinash (7):
      pwm: Device tree support for PWM polarity
      pwm: Add TI PWM subsystem driver
      pwm: tiecap: Add device-tree binding
      pwm: pwm-tiecap: pinctrl support
      pwm: pwm-tiehrpwm: Adding TBCLK gating support.
      pwm: tiehrpwm: Add device-tree binding
      pwm: pwm-tiehrpwm: pinctrl support

Shiraz Hashim (1):
      pwm: Add SPEAr PWM chip driver support

Thierry Reding (1):
      pwm: Export of_pwm_xlate_with_flags()

Tony Prisk (3):
      pwm: vt8500: Update vt8500 PWM driver support
      pwm: vt8500: Fix build error
      pwm: vt8500: Ensure PWM clock is enabled during pwm_config

 .../devicetree/bindings/pwm/pwm-tiecap.txt         |  23 ++
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |  23 ++
 .../devicetree/bindings/pwm/pwm-tipwmss.txt        |  31 ++
 Documentation/devicetree/bindings/pwm/pwm.txt      |  17 +-
 .../devicetree/bindings/pwm/spear-pwm.txt          |  18 ++
 .../devicetree/bindings/pwm/ti,twl-pwm.txt         |  17 +
 .../devicetree/bindings/pwm/ti,twl-pwmled.txt      |  17 +
 .../devicetree/bindings/pwm/vt8500-pwm.txt         |  17 +
 drivers/pwm/Kconfig                                |  39 ++-
 drivers/pwm/Makefile                               |   5 +-
 drivers/pwm/core.c                                 |  29 ++
 drivers/pwm/pwm-imx.c                              |   2 +-
 drivers/pwm/pwm-lpc32xx.c                          |  23 +-
 drivers/pwm/pwm-samsung.c                          |   1 +
 drivers/pwm/pwm-spear.c                            | 276 ++++++++++++++++
 drivers/pwm/pwm-tiecap.c                           |  48 ++-
 drivers/pwm/pwm-tiehrpwm.c                         |  62 +++-
 drivers/pwm/pwm-tipwmss.c                          | 139 ++++++++
 drivers/pwm/pwm-tipwmss.h                          |  39 +++
 drivers/pwm/pwm-twl-led.c                          | 344 +++++++++++++++++=
+++
 drivers/pwm/pwm-twl.c                              | 359 +++++++++++++++++=
++++
 drivers/pwm/pwm-twl6030.c                          | 184 -----------
 drivers/pwm/pwm-vt8500.c                           |  98 ++++--
 include/linux/pwm.h                                |   3 +
 24 files changed, 1593 insertions(+), 221 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tipwmss.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/spear-pwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
 create mode 100644 drivers/pwm/pwm-spear.c
 create mode 100644 drivers/pwm/pwm-tipwmss.c
 create mode 100644 drivers/pwm/pwm-tipwmss.h
 create mode 100644 drivers/pwm/pwm-twl-led.c
 create mode 100644 drivers/pwm/pwm-twl.c
 delete mode 100644 drivers/pwm/pwm-twl6030.c

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0XiOAAoJEN0jrNd/PrOhqtMP/iVYFymd0wrUq7zpoqi+TsA5
m2JfmwbMUxB6kQQKmOXtWdKnO/JcpDlxRICg+nIES8iGZDP9AyW0MlcoqYI8Xi2J
cxqQAUhxqAELNgTjxSslxW9wSH61xZl1arNVbBPzkP+uUdvtY+95reYoJtbDz8Jz
5XVbBdNihI1XZD8BHHJrZUuK1BFgDfJkbuMygF/3ypT0vw/zuV2NwlCkf5K+cRAv
83HXI94V5Xrhs67XI6dPHxJ6kBEH31wndDJBhlOr3sb2IchoLzshxSgtIuCAbxxG
Q5EV4z/K36Ffdr0birs4BtULcYjRYdz/fS3JoBX7BABeNwEzD2XLpl1MlI1g0fff
SR3S48f0UATnbB36E6sELounMVr41hafgKiCP6URzq86fs8+i5pmvwkSqHL3O+ai
FcO/R5QRDcSBU/Uh5btPanoktky014oJaLb5d59DP3636OgYFSVDmMGR070K+3o7
koZDKk3apS4a0PlnKmg60uKcAaFrUVg3RUcgGhoEaAtWJvgkIuv5OTFJOK2Ht/8N
fYdpFsJE0LjEAhxclpP/M2bEMwZ/ScTGiPhiYD+5YJUNkaEWuYqPzXME4YRHt9Y9
HIL9DhDtiWRtgAnQe59HGPFxd9u4f2Zmm5fkZCsi7gO/aCx980zVokbuCETqms52
047sjS5wnoCko4Cc5BU9
=9qS7
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
