Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2AERog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:44:36 -0500
Received: from imr4.ericy.com ([198.24.6.9]:59064 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2AERof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:44:35 -0500
Date: Thu, 5 Jan 2012 09:42:25 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.3
Message-ID: <20120105174225.GA9257@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.3 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
hwmon-for-linus

No new drivers this time, only cleanups, minor fixes, and added support for
new chips to existing drivers.

Most of the patches have been in -next for a while, but there are some clea=
nups
and minor fixes which I only added in the last couple of days (the patches
submitted by Frans). Some of those may be missing in the -next snapshot you=
 use
as base to determine what to accept and what not (all are in next-20120105,
though). I have no problem taking those out and resubmit later into an -rc
if you prefer. Please let me know.

Thanks,
Guenter

------

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hw=
mon-for-linus

Bj=F6rn Gerhart (1):
      hwmon: (f75375s) Add support for F75387SG/RG

Frans Meulenbroeks (7):
      hwmon: (ltc4261) set data->valid to 0 if error
      hwmon: (lm75) added error handling
      hwmon: (lm75) fix checkpatch warning
      hwmon: replaced strict_str* with kstr*
      hwmon: (lm80) fix checkpatch messages
      hwmon: (lm75) fix checkpatch warnings
      max1111.c: fix checkpatch warning

Guenter Roeck (9):
      hwmon: (pmbus/adm1275) Validate device ID
      hwmon: (pmbus/zl6100) Add support for ZL2005
      hwmon: (pmbus/zl6100) Add support for Ericsson BMR45[0,1] and BMR46[2=
,3,4]
      hwmon: (pmbus/zl6100) Only instantiate external temperature sensor if=
 enabled
      hwmon: (f75375s) Fix checkpatch errors and warnings
      hwmon: (f75375s) Use standard sysfs attribute names
      hwmon: (f75375s) Fix value range for PWM modes
      hwmon: (f75375s) Initialize pwmX_mode and pwmX_enable if there is no =
platform data
      hwmon: (f75375s) Disable setting DC fan control mode for F75373

 Documentation/hwmon/pmbus        |    5 +-
 Documentation/hwmon/zl6100       |   15 ++
 drivers/hwmon/Kconfig            |    4 +-
 drivers/hwmon/acpi_power_meter.c |    6 +-
 drivers/hwmon/adcxx.c            |    2 +-
 drivers/hwmon/adm1031.c          |    2 +-
 drivers/hwmon/adm9240.c          |    2 +-
 drivers/hwmon/adt7411.c          |    2 +-
 drivers/hwmon/adt7462.c          |   28 ++--
 drivers/hwmon/adt7470.c          |   26 ++--
 drivers/hwmon/adt7475.c          |   20 ++--
 drivers/hwmon/amc6821.c          |   14 +-
 drivers/hwmon/applesmc.c         |    6 +-
 drivers/hwmon/asc7621.c          |   24 ++--
 drivers/hwmon/ds620.c            |    2 +-
 drivers/hwmon/emc1403.c          |    6 +-
 drivers/hwmon/emc2103.c          |   10 +-
 drivers/hwmon/emc6w201.c         |    6 +-
 drivers/hwmon/f71882fg.c         |   32 ++--
 drivers/hwmon/f75375s.c          |  309 ++++++++++++++++++++++++++++------=
---
 drivers/hwmon/g760a.c            |    2 +-
 drivers/hwmon/gpio-fan.c         |    6 +-
 drivers/hwmon/ibmaem.c           |    2 +-
 drivers/hwmon/it87.c             |   34 ++--
 drivers/hwmon/jc42.c             |    4 +-
 drivers/hwmon/lm73.c             |    2 +-
 drivers/hwmon/lm75.c             |   25 ++-
 drivers/hwmon/lm75.h             |    5 +-
 drivers/hwmon/lm80.c             |   70 +++++----
 drivers/hwmon/lm90.c             |   10 +-
 drivers/hwmon/lm95241.c          |    8 +-
 drivers/hwmon/lm95245.c          |    8 +-
 drivers/hwmon/ltc4261.c          |    1 +
 drivers/hwmon/max1111.c          |    2 +-
 drivers/hwmon/max16065.c         |    2 +-
 drivers/hwmon/max6639.c          |    8 +-
 drivers/hwmon/max6642.c          |    2 +-
 drivers/hwmon/pc87427.c          |    6 +-
 drivers/hwmon/pmbus/Kconfig      |    9 +-
 drivers/hwmon/pmbus/adm1275.c    |   71 ++++++---
 drivers/hwmon/pmbus/pmbus.c      |    2 -
 drivers/hwmon/pmbus/zl6100.c     |   43 +++++-
 drivers/hwmon/sht15.c            |    2 +-
 drivers/hwmon/tmp102.c           |    2 +-
 drivers/hwmon/tmp401.c           |   10 +-
 drivers/hwmon/w83627ehf.c        |   22 ++--
 drivers/hwmon/w83791d.c          |    8 +-
 drivers/hwmon/w83792d.c          |    2 +-
 drivers/hwmon/w83793.c           |    2 +-
 drivers/hwmon/w83795.c           |   32 ++--
 50 files changed, 588 insertions(+), 335 deletions(-)

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPBeEBAAoJEMsfJm/On5mBW1MP/RqlRnO2ckoIKVheABf4BnFL
YDJMyKwRjwXf/axHe9tjjlsgooz4deBNcg9QaAVeVLLadq/GvHbaetjS2UqcgagF
C8Js00NEmGttKS4a8vsDarsW5njcgljok7kWj25xJPMAxYzxJDdR9ekmwHwqwk3S
KdsZMtCYP4ji+DxG/pemiZqKa+yIdL1gsOivS7+b3zgc/kNmYhkYzY64U0Zwu7NF
HbsjDkQs9GrNmTVAksT+QC7E9RIhH9B+qAfhsCz3WpENeyc51uUH0IdHXqoI6ZFM
EV6fQOK49SZdo0C4AipAvINpKIit6IRuDl+kZWVGFnQmSyXprbAZTqftCpvLnBp6
HQ8gNLjuG1nVCD6/zoihwQV6p6S1KWAPvpJLn8g92FFOyrLqsqh8tV8mic5fG++R
GWyAsmLLgXTMmlzMU8nBdZpcH3BqK4GGwGCsHvBcZt5yeyQOTG5LNFR1sWshtuOr
DTsddg0mWtkCIU/OCZbs5DK+rM8rL6zRWpHZy0i+1DHuQOkekc+UmYzZggfCKmu2
sMG+QFoO8SR2smOjB+WKpaFdxOawvD+MWxciQjA7lcjzRF/aejxTLZ6b8CJGncLM
TjUaA4xl6C3qJ/x8fjeJsh9QPZt1kjiffVU/Xl19gnzyvL0LTSDo7HquHwxZzlqy
MqxIFKDIeKvQ7je1xd5s
=HrFn
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
