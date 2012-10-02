Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2JBNfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:35:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:5974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2JBNfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:35:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="asc'?scan'208";a="229529060"
Message-ID: <1349184941.2017.70.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for 3.7-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Date: Tue, 02 Oct 2012 16:35:41 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xcgBzp3fMynv+biOxgtB"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xcgBzp3fMynv+biOxgtB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please, pull UBI changes.

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d=
:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.7-rc1

for you to fetch changes up to 55393ba1bdedc5ded79b34b4cc08898a7776cddb:

  UBI: fix trivial typo 'it' =3D> 'is' (2012-09-26 13:22:50 +0300)

----------------------------------------------------------------
The main change is the way we reserve eraseblocks for bad blocks
handling. We used to reserve 2% of the partition, but now we are
more aggressive and we reserve 2% of the entire chip, which is
what actually manufacturers specify in data sheets. We introduced
an option to users to override the default, though.

There are a couple of fixes as well, and a number of cleanups.

----------------------------------------------------------------
Artem Bityutskiy (7):
      UBI: print image sequence number as unsigned integer
      UBI: print PID in debug messages
      arm: sam9_l9260_defconfig: correct CONFIG_MTD_UBI_BEB_LIMIT
      UBI: fix autoresize handling in R/O mode
      UBI: comply with coding style
      UBI: use pr_ helper instead of printk
      UBI: print less

Brian Norris (1):
      UBI: fix trivial typo 'it' =3D> 'is'

Jiang Lu (1):
      UBI: load after mtd device drivers

Matthieu CASTET (1):
      UBI: erase free PEB with bitflip in EC header

Richard Genoud (9):
      mtd: mark mtd_is_partition argument as constant
      mtd: mtdparts: introduce mtd_get_device_size
      UBI: use the whole MTD device size to get bad_peb_limit
      UBI: separate bad_peb_limit in a function
      UBI: introduce MTD_PARAM_MAX_COUNT
      UBI: prepare for max_beb_per1024 module parameter addition
      UBI: check max_beb_per1024 value in ubi_attach_mtd_dev
      UBI: allow specifying bad PEBs limit using module parameter
      UBI: add max_beb_per1024 to attach ioctl

Shmulik Ladkani (5):
      arm: sam9_l9260_defconfig: prepare to UBI config change
      UBI: introduce new bad PEB limit
      UBI: limit amount of reserved eraseblocks for bad PEB handling
      UBI: kill CONFIG_MTD_UBI_BEB_RESERVE
      arm: sam9_l9260_defconfig: remove non-existing config option

 arch/arm/configs/sam9_l9260_defconfig |   2 +-
 drivers/mtd/mtdpart.c                 |  12 ++++++++++-
 drivers/mtd/ubi/Kconfig               |  40 ++++++++++++++++++++++++------=
------
 drivers/mtd/ubi/attach.c              |  46 ++++++++++++++++++++----------=
-----------
 drivers/mtd/ubi/build.c               | 204 ++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++--------------------------------------------------------------------=
--
 drivers/mtd/ubi/cdev.c                |  18 ++++++++--------
 drivers/mtd/ubi/debug.c               | 153 ++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++----------------------------------------=
-------------------------------
 drivers/mtd/ubi/debug.h               |  12 ++++-------
 drivers/mtd/ubi/eba.c                 |  33 ++++++++++++++----------------
 drivers/mtd/ubi/gluebi.c              |  30 +++++++++++++--------------
 drivers/mtd/ubi/io.c                  |  80 ++++++++++++++++++++++++++++++=
+++++------------------------------------
 drivers/mtd/ubi/misc.c                |  14 +++++++++----
 drivers/mtd/ubi/ubi.h                 |  16 +++++++--------
 drivers/mtd/ubi/vtbl.c                |  10 ++++-----
 drivers/mtd/ubi/wl.c                  |  48 +++++++++++++++++++++++++++---=
-------------
 include/linux/mtd/partitions.h        |   3 ++-
 include/mtd/ubi-user.h                |  16 ++++++++++++++-
 17 files changed, 412 insertions(+), 325 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-xcgBzp3fMynv+biOxgtB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQau2tAAoJECmIfjd9wqK0d4QP/3Gd2V5Sd5P16R0W+++lKP9a
1EhCzHz9i5fMyOllM6Tmh7/M0adYZ0buB7c41C37WUPubsxpu+SUWc1SnXcH4u97
b9D3rKfkP68Wy+Bf7qmWi6xJtqUyZClhXMVR/4Rjce8Kdsm0UHRsbz5fPZw4t2g2
hcxRHZp3FYKFgNuD3dpXcBtGyVcekQgi+yhLRfufdN6RBDY4mtfzuAbI9xB+SMPn
jdud0a2jyCQq9Pqg8fqpgv+gFnHejiwKHi2mLUNifxaTfaIle60QHC/iLg4MTk4X
6HIguj5C9m4ROI/N9pxte2Ao7RRUTb8O9z70SbaNcSqOsCLnVB3uC2DeHEN8QcQa
Iqunvt0BNTFGUuJFSDtJpYEl6xTaJtV4RAVRJGtzQMNNxTXrccwciyIb6mlQaTek
tN0kEQfYrpUwT6Rn/9CpRFQXq4yzrXh5PaZj5d+22jxXunF1dsXQgx+vtSLlCSFe
YI65rDVq87+vZpK7l2AR7/ds9qQEnelQZqrQOOpO0fw+Jdr0SrCTby28Ipguy0NL
EhP5qJ5Mv1/LflewLT3heJlo49w+mCx4aAQ/ffGxWJAgXe1EqQK9x7YizS4oHjQt
ma0i+D4zNKoct2yfFYU0AhHzvN4zbpCpG831o5Uw1e4fRUWXgW4zr0TrIfi7iBFt
7HvwV5T5Rg+eJFGHfAlP
=oQG9
-----END PGP SIGNATURE-----

--=-xcgBzp3fMynv+biOxgtB--

