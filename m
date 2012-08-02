Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2HBGGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:06:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2HBGAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:00:55 -0400
Date: Wed, 1 Aug 2012 23:00:47 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.6-rc1
Message-ID: <20120802060047.GA24033@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.6-rc1-fixes

for you to fetch changes up to 5f5b331d5c21228a6519dcb793fc1629646c51a6:

  eCryptfs: check for eCryptfs cipher support at mount (2012-07-13 17:20:34 -0700)

----------------------------------------------------------------
- Fixes a bug when the lower filesystem mount options include 'acl', but the
  eCryptfs mount options do not
- Cleanups in the messaging code
- Better handling of empty files in the lower filesystem to improve usability.
  Failed file creations are now cleaned up and empty lower files are converted
  into eCryptfs during open().
- The write-through cache changes are being reverted due to bugs that are not
  easy to fix. Stability outweighs the performance enhancements here.
- Improvement to the mount code to catch unsupported ciphers specified in the
  mount options

----------------------------------------------------------------
Tim Sally (1):
      eCryptfs: check for eCryptfs cipher support at mount

Tyler Hicks (6):
      eCryptfs: Copy up POSIX ACL and read-only flags from lower mount
      eCryptfs: Remove unused messaging declarations and function
      eCryptfs: Make all miscdev functions use daemon ptr in file private_data
      eCryptfs: Unlink lower inode when ecryptfs_create() fails
      eCryptfs: Initialize empty lower files when opening them
      eCryptfs: Revert to a writethrough cache model

 fs/ecryptfs/ecryptfs_kernel.h |   24 +++-----
 fs/ecryptfs/file.c            |   90 ++++++++++++---------------
 fs/ecryptfs/inode.c           |   65 ++++++++++----------
 fs/ecryptfs/main.c            |   23 ++++++-
 fs/ecryptfs/messaging.c       |  136 +++++------------------------------------
 fs/ecryptfs/miscdev.c         |   98 ++++++++---------------------
 fs/ecryptfs/mmap.c            |   39 ++++--------
 7 files changed, 158 insertions(+), 317 deletions(-)

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQGhePAAoJENaSAD2qAscK/ekP/3XOqtYJXgQmv/78VqOov+oR
9pmex23XpKVfc7Huok1ARxDJwvrLx4wjfmx/SMo5EBoxb0Y65KhiEum7CpG1GxXJ
qgdhOMAEYrpZhrZ125LsQufa2yaNJUsgNuhDpaKmidS76WtPkhGmSSEBV++PNng7
HSB7Rq+a7+BVwT1dAllzA2jVrdbHKfqrfxf/Dk6hgYLj3UgKow8Y4kFJAypFjNx8
4NfLaU1uEe04hv8qigLqEzArxuLktniGowgiv4VwtnmjBudSRBTR6c9kRjrkRmHf
E4svnrdUZtPKLZdUrA7IoWB6sxuyM4X6ymeVGfIAot9I5VnaZ2+WLvpIYyUyHccY
cwlMl8WNi47XgxzQ5Da+L3a618A/8aj1uTRZnfbgoje1wcalhGcbFWIGKKavlP7M
9CxSNyIx+N+houIFasREQC0IifpG9eWxcp0VSgb/SilD7pxQ1ari6K6PcwooKKm3
gV91bYJA8zVk1RJPiyfnRxJZn6jkStLraDXYbTAMkAeFBRXeZggM3cICxKAKzwIS
ZzlJlM1VIEqOPlHr/I8QOL2tlcPLyc7Zj+frsxQdxcv0ikTUAWdydVO8ilJoP+eK
KUH6rR1iLxIRy+y1OLtNdkqGZMN0PPgwNvKBmbh8SJNQJG00lQWlN7adfP6wXgsh
qFHtwT8t0h4OWkStsTH4
=Riet
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
