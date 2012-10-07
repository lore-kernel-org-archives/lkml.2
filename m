Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2JGKxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 06:53:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58988 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2JGKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 06:53:48 -0400
Date: Sun, 7 Oct 2012 12:53:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.7-rc1
Message-ID: <20121007105342.GA10218@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VP/Z9TZ3dTJ7u43CsghDZYZ20SGFH5iM2Qfnze80pol
 91QnC70kGrdpVrzDY5nLFgE7snrUI4yWSFcCuwJWkZKQP7WHZZ
 xFwmM4kGEcMyUUWqzkHeI8tzC5qEkpo10YFwLvgN4ewyoUGHrT
 TnazAhKzS6IkdKucvwbY4WEOl+ygSXdNClKO4BeOBmWY5/08zd
 a/XhYhh1nrG08GmlK6nCgYMPCCRZGz19pNEOdT6zjaWzIZObcQ
 pEVDtk3QV69tV466qIBIY/ScAMM3p0u4rAoR4CI3AByy0BsAzO
 YmkXbmYyFDCnkCh2n+vB4Q+yWHk96qdhYIMloKMDgTbN8Z2HME
 xBu9IqRwCGXtnudd/gJZEkA8Iq7V56g3kvbQHH3mHCW9Vns0J0
 CpTVKsni4Ira2ACOnXsvANV4WcNphL1+q/1F8WQF1hRUVNZF7n
 KxK1u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 01b2d4536f0215c6d97d77e157afee04300ffc90:

  pwm: pwm-tiehrpwm: Fix conflicting channel period setting (2012-09-10 17:04:38 +0200)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.7-rc1

for you to fetch changes up to 85f8879ca4f3d26a7f473522101fb74a79bda3f2:

  pwm: dt: Fix description of second PWM cell (2012-10-07 12:11:53 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.7-rc1

All legacy PWM providers have now been moved to the PWM subsystem. The
plan for 3.8 is to adapt all board files to provide a lookup table for
PWM devices in order to get rid of the global namespace. Subsequently,
users of the legacy pwm_request() and pwm_free() functions can be
migrated to the new pwm_get() and pwm_put() functions. Once this has
been completed, the legacy API and the compatibility code in the core
can be removed.

In addition to the above, these changes also add support for configuring
the polarity of a PWM signal (currently only supported on ECAP and
EHRPWM) and include a much needed rework of the i.MX driver. Managed
functions to obtain and release a PWM device (devm_pwm_get() and
devm_pwm_put()) have been added and the pwm-backlight driver has been
updated to use them. If the PWM subsystem hasn't been enabled, dummy
functions are provided that allow the subsystem to safely compile out.

Some common checks on input parameters have been moved to the core and
removed from the drivers. Finally, a small fix corrects the description
of the PWM specifier's second cell in the device tree representation.

----------------------------------------------------------------
Alexandre Courbot (1):
      pwm: add devm_pwm_get() and devm_pwm_put()

Philip, Avinash (3):
      pwm: Add support for configuring the PWM polarity
      pwm: pwm-tiecap: Add support for configuring polarity of PWM
      pwm: pwm-tiehrpwm: Add support for configuring polarity of PWM

Philipp Zabel (2):
      pwm: i.MX: add devicetree support
      pwm: i.MX: fix clock lookup

Sachin Kamat (1):
      pwm-backlight: Use devm_pwm_get() instead of pwm_get()

Sascha Hauer (5):
      pwm: i.MX: factor out SoC specific functions
      pwm: i.MX: remove unnecessary if in pwm_[en|dis]able
      pwm: i.MX: add functions to enable/disable pwm.
      pwm: i.MX: Use module_platform_driver
      pwm: i.MX: use per clock unconditionally

Thierry Reding (10):
      pwm: Move AB8500 PWM driver to PWM framework
      unicore32: pwm: Properly remap memory-mapped registers
      unicore32: pwm: Use module_platform_driver()
      unicore32: pwm: Remove unnecessary indirection
      unicore32: pwm: Use managed resource allocations
      pwm: Move PUV3 PWM driver to PWM framework
      MIPS: JZ4740: Export timer API
      pwm: Add Ingenic JZ4740 support
      pwm: Check for negative duty-cycle and period
      pwm: dt: Fix description of second PWM cell

Tushar Behera (1):
      pwm: Fix compilation error when CONFIG_PWM is not defined

 Documentation/devicetree/bindings/pwm/imx-pwm.txt  |  17 ++
 Documentation/devicetree/bindings/pwm/mxs-pwm.txt  |   2 +-
 .../devicetree/bindings/pwm/nvidia,tegra20-pwm.txt |   2 +-
 Documentation/driver-model/devres.txt              |   4 +
 Documentation/pwm.txt                              |   3 +-
 arch/mips/include/asm/mach-jz4740/platform.h       |   1 +
 arch/mips/include/asm/mach-jz4740/timer.h          | 113 +++++++++
 arch/mips/jz4740/Kconfig                           |   3 -
 arch/mips/jz4740/Makefile                          |   2 +-
 arch/mips/jz4740/board-qi_lb60.c                   |   1 +
 arch/mips/jz4740/platform.c                        |   6 +
 arch/mips/jz4740/pwm.c                             | 177 -------------
 arch/mips/jz4740/time.c                            |   2 +-
 arch/mips/jz4740/timer.c                           |   4 +-
 arch/mips/jz4740/timer.h                           | 136 ----------
 arch/unicore32/Kconfig                             |  12 +-
 arch/unicore32/include/mach/regs-ost.h             |  18 +-
 arch/unicore32/kernel/Makefile                     |   1 -
 arch/unicore32/kernel/pwm.c                        | 263 -------------------
 drivers/misc/Kconfig                               |  10 -
 drivers/misc/Makefile                              |   1 -
 drivers/pwm/Kconfig                                |  29 ++-
 drivers/pwm/Makefile                               |   3 +
 drivers/pwm/core.c                                 |  82 +++++-
 drivers/{misc/ab8500-pwm.c => pwm/pwm-ab8500.c}    | 116 ++++-----
 drivers/pwm/pwm-bfin.c                             |   3 -
 drivers/pwm/pwm-imx.c                              | 278 ++++++++++++++-------
 drivers/pwm/pwm-jz4740.c                           | 221 ++++++++++++++++
 drivers/pwm/pwm-puv3.c                             | 161 ++++++++++++
 drivers/pwm/pwm-pxa.c                              |   3 -
 drivers/pwm/pwm-samsung.c                          |   3 -
 drivers/pwm/pwm-tiecap.c                           |  24 +-
 drivers/pwm/pwm-tiehrpwm.c                         |  75 ++++--
 drivers/video/backlight/pwm_bl.c                   |   7 +-
 include/linux/pwm.h                                | 108 +++++++-
 35 files changed, 1069 insertions(+), 822 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt
 delete mode 100644 arch/mips/jz4740/pwm.c
 delete mode 100644 arch/mips/jz4740/timer.h
 delete mode 100644 arch/unicore32/kernel/pwm.c
 rename drivers/{misc/ab8500-pwm.c => pwm/pwm-ab8500.c} (52%)
 create mode 100644 drivers/pwm/pwm-jz4740.c
 create mode 100644 drivers/pwm/pwm-puv3.c

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQcV82AAoJEN0jrNd/PrOh1aEQAJAqFAoeVVCeB4sjrci4kk69
jA2fI6AS1n+keKxhPQbpbE233itnmwWunnreze7gnQehDGTmWcYNA6REZ7RKbsR9
VDKpHVj6Lm2KLHzEWcQyZ8IRcZmgFMm3nniNroyoiQ6+RBRX/24UiFy85XZxR7Hg
0CNbSm62n9uMTu+DvM7/JRg7YCA9A88/AcK3p7XdWcICv+owP9FckygIydN90mga
+WvJGszKOOGmX/r0yszkrPCPOpHAswCbMlajeZjrtniCcMm2f9no/xZbg6UleUSR
kZqgXMXVA/FkcxU9N8S7iAjQFLWn0wyz1BToiXKjGT2FkzT7mO43uKIkUSyMBw8W
ISX3U4ozs9Nh1GEc1xlSP492l7V3i0y2sxKrOuEvKDu25YPHkLVqWDA4GrdZ8HmH
k+62TANFvbLRxdvsD/k8uv/CLOf2GOSsUJ8x1vt6CUw92XUgviASzmjTYsMLB7Jy
80iOzv3nYiEKVPxK8eY7Vr8uXSLvH1uZgeWxYJW+OXfTkzTvm+7py7pnq9/5hkLP
XorXTau2qxs3amBJPGvDWaePHVIsELYL3J+wVaQLtVP8qcuBVpigIowsH8wYLd3P
lkZTh4P3M5mKSL70WKbZFwaEjyelyNYLj2raKB6mQRRq4GxCRXzYWPXwm2z5hmmx
ZtxD5CCtp0sisli5NmTt
=p1j5
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
