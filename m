Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1JYU0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:26:46 -0400
Received: from imr4.ericy.com ([198.24.6.9]:43671 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1JYU0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:26:45 -0400
Date: Tue, 25 Oct 2011 13:24:59 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.2
Message-ID: <20111025202459.GA24858@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.2 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

New chips: EXYNOS4, ADM1276, Intersil DC/DC controllers, LTC3880, Lineage DC/DC controllers,
and AD7314. Plus some cleanup and minor enhancements here and there.

The larger patches have been in -next for at least a month. A couple of minor enhancements
are from 1-2 weeks ago.

Thanks,
Guenter

------

The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Dmitry Artamonow (1):
      hwmon: (w83627ehf) add caseopen detection

Donggeun Kim (1):
      hwmon: Add driver for EXYNOS4 TMU

Guenter Roeck (13):
      hwmon: (pmbus) Add comments explaining internal driver API return values
      hwmon: (pmbus) Don't return errors from driver remove functions
      hwmon: (pmbus/adm1275) Add support for second current limit
      hwmon: (pmbus/adm1275) Add support for ADM1276
      hwmon: (pmbus) Provide more documentation
      hwmon: (pmbus) Replace EINVAL return codes with more appropriate errors
      hwmon: (pmbus) Always call _pmbus_read_byte in core driver
      hwmon: (pmbus) Add support for Intersil power management chips
      hwmon: (pmbus) Add support for TEMP2 peak attributes
      hwmon: (pmbus/ltc2978) Explicit driver for LTC2978
      hwmon: (pmbus/ltc2978) Add support for LTC3880 to LTC2978 driver
      hwmon: (pmbus) Add support for Lineage Power DC-DC converters
      hwmon: (pmbus_core) Simplify sign extensions

Hans de Goede (3):
      hwmon/f71882fg: Make all fan/pwm attr tables 2 dimensional
      hwmon/f71882fg: Add a f71882fg_create_fan_sysfs_files helper function
      hwmon/f71882fg: Make the decision wether to register fan attr. per fan

Jean Delvare (5):
      hwmon: (w83627ehf) Skip reading unused voltage registers
      hwmon: (w83627ehf) Move fan pins check to a separate function
      hwmon: (lm75) Document why clones are not detected
      hwmon: (w83627ehf) Uninline is_word_sized
      hwmon: (w83627ehf) Better fix for negative temperature values

Jonathan Cameron (1):
      hwmon: AD7314 driver (ported from IIO)

Michael Hennerich (1):
      hwmon: (lm75) Add support for Analog Devices ADT75

Yong Zhang (1):
      hwmon: (exynos4_tmu) Remove IRQF_DISABLED

 Documentation/hwmon/ad7314                |   25 ++
 Documentation/hwmon/adm1275               |   40 ++-
 Documentation/hwmon/exynos4_tmu           |   81 +++++
 Documentation/hwmon/lm75                  |   61 ++--
 Documentation/hwmon/ltc2978               |  103 ++++++
 Documentation/hwmon/pmbus                 |   13 +-
 Documentation/hwmon/pmbus-core            |  283 ++++++++++++++++
 Documentation/hwmon/zl6100                |  125 +++++++
 drivers/hwmon/Kconfig                     |   21 ++
 drivers/hwmon/Makefile                    |    2 +
 drivers/hwmon/ad7314.c                    |  186 ++++++++++
 drivers/hwmon/exynos4_tmu.c               |  524 +++++++++++++++++++++++++++++
 drivers/hwmon/f71882fg.c                  |  231 +++++++------
 drivers/hwmon/lm75.c                      |   39 ++-
 drivers/hwmon/pmbus/Kconfig               |   28 ++-
 drivers/hwmon/pmbus/Makefile              |    2 +
 drivers/hwmon/pmbus/adm1275.c             |  159 ++++++++-
 drivers/hwmon/pmbus/lm25066.c             |   17 +-
 drivers/hwmon/pmbus/ltc2978.c             |  408 ++++++++++++++++++++++
 drivers/hwmon/pmbus/max16064.c            |    3 +-
 drivers/hwmon/pmbus/max34440.c            |   13 +-
 drivers/hwmon/pmbus/max8688.c             |    9 +-
 drivers/hwmon/pmbus/pmbus.c               |   10 +-
 drivers/hwmon/pmbus/pmbus.h               |   23 ++-
 drivers/hwmon/pmbus/pmbus_core.c          |   85 +++--
 drivers/hwmon/pmbus/ucd9000.c             |   13 +-
 drivers/hwmon/pmbus/ucd9200.c             |    5 +-
 drivers/hwmon/pmbus/zl6100.c              |  256 ++++++++++++++
 drivers/hwmon/w83627ehf.c                 |  238 +++++++++-----
 include/linux/platform_data/exynos4_tmu.h |   83 +++++
 30 files changed, 2755 insertions(+), 331 deletions(-)
 create mode 100644 Documentation/hwmon/ad7314
 create mode 100644 Documentation/hwmon/exynos4_tmu
 create mode 100644 Documentation/hwmon/ltc2978
 create mode 100644 Documentation/hwmon/pmbus-core
 create mode 100644 Documentation/hwmon/zl6100
 create mode 100644 drivers/hwmon/ad7314.c
 create mode 100644 drivers/hwmon/exynos4_tmu.c
 create mode 100644 drivers/hwmon/pmbus/ltc2978.c
 create mode 100644 drivers/hwmon/pmbus/zl6100.c
 create mode 100644 include/linux/platform_data/exynos4_tmu.h

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpxsbAAoJEMsfJm/On5mBc0MQAJ0phvSQIJxWV9sS1+QEN/hy
HrCHUe7QksO0bkgCoGVIX/dQNQVvnhI8B0Kc4VSnbwpfZgq0nFljyDH5ZnA8Gjj1
182ZjO7tHEv4hP7+l+9KS4fLaemW7qb5ZWc+d/15v1aRFC+WLPPH7wqqaj+G4Ylz
/uJHqXl9EwkIxaMpWFGQdRB5sKeZrFRMKRKCXvFJM3qhnec1LwithviylmeuSEph
g60zJOcg+ICdqxFz6fCDUuQsPS9Q/C1IZs3CfeIb+/41nRLZKBG0hwCGqZ5Qut0J
hYwlX0hMsotY79n2070vdR0Xe2R6x4zTG0LqTyfkr5AMoqUoQmvxEaJnedWl9B9d
23Yz9bUuQ5IgBC6rJL2qtr5vQ93svufJzklWfaqUVu+3I6Lgtq+u/8e8YUfrc6tq
U3rp6Yf8gDRK+NdWaLOH5bWjFjCcOCZsW0tcex76VdJ9md+i1syqBgVuGkJGo28b
7NIbDUcKMnmvSyP0bKQcMWPws7qfYpI4iUF3IO7GgxSe0znAGomppeX7m+BoKtNE
mMBulNyk3B7l4Ire7HQsgI3oEHDsAr6At1SzIyVGWU/O9JYqKLwtgxTwTXihmgQF
QTE8pDHP9/lITzDllTT7I2MydnS5udZ5FBsVnsoeGpTQUrYCRzyrx5DWrqcvzfEM
mY7FRBTUCsf7P18wndpa
=6QL/
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
