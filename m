Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab2INRYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:24:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2INRYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:24:15 -0400
Date: Fri, 14 Sep 2012 10:24:09 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.6-rc6
Message-ID: <20120914172408.GA22346@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit e9bd8f1624cb0f647867d6cced79cb26ef3651bf:

  Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6 (2012-09-11 05:52:49 +0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.6-rc6-fixes

for you to fetch changes up to 8335eafc2859e1a26282bef7c3d19f3d68868b8a:

  eCryptfs: Copy up attributes of the lower target inode after rename (2012-09-14 09:36:03 -0700)

----------------------------------------------------------------
- Fixes a regression, introduced in 3.6-rc1, when a file is closed before its
  shared memory mapping is dirtied and unmapped. The lower file was being
  released when the eCryptfs file was closed and the dirtied pages could not be
  written out.
- Adds a call to the lower filesystem's ->flush() from ecryptfs_flush().
- Fixes a regression, introduced in 2.6.39, when a file is renamed on top of
  another file. The target file's inode was not being evicted and the space
  taken by the file was not reclaimed until eCryptfs was unmounted.

----------------------------------------------------------------
Tyler Hicks (3):
      eCryptfs: Write out all dirty pages just before releasing the lower file
      eCryptfs: Call lower ->flush() from ecryptfs_flush()
      eCryptfs: Copy up attributes of the lower target inode after rename

 fs/ecryptfs/file.c  |   10 ++++++++--
 fs/ecryptfs/inode.c |    5 +++++
 fs/ecryptfs/main.c  |    1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQU2g4AAoJENaSAD2qAscKHq8QAJZWdC9Xgoal8aldGX82e4Fz
L8Cgg0aqA3IHcmwGfrj8JQ6G/2JrKwLOYbcLrfjXIa7R/vEnhsdBwiQZQiFWPf3z
vOgtL73p2BE7X0CIhU7F+EbF7EbTztKTxeQ7xpxdi96B5uhyvzou1EwzF1zJ6WPS
OXcGzaeqi7y2awuDbPLPjyKGJz3e7Zi8sQb6Knj0duseNgFplIJOD1p2/V1VpQkw
VWJBmwti5xLARgEXNijFJOwa86wkgjl5mOdvd16+YY2GxoDBEt+hhv+Ufy774Xkn
DXDstlfT+vogvoogUTf09I058CZoSwUQsl8IgulWJwhS+aFf6WPvHwcsR3tCWGJE
wRoM8/eHylFEPP2grxpvfBuQzFHOI2NgplO6Envj3+xisqx1K4psN1fi6w3xBHow
oOc1siJ9dCSpKvs81Efe4ImQvh4xgOLVXkcG0gdx0cm+EUHCDkHWBxtTcAhsJcBp
92I+6Prv/oDBceDSf9naGuS0iwm3+oNWP6sGb9V3RqYcgCn9XPVV4tMUBbZA06tA
Y/mTi3TfVBvhdUX5q54UGLbOvx9UHgTgXBoDhrcHdM/VDB8oDz50JPKSCTg3aSuQ
go0EyJdnVVVawqOKOEbsfhXD9f+DTC9rDHn+Frzv3YvURUXqEj8aa0bbWT/NBCMR
iI+Vpe6SaHWv1h1395Op
=qiKA
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
