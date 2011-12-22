Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1LVU4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:56:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab1LVU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:56:32 -0500
Date: Thu, 22 Dec 2011 14:56:26 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fix for 3.2-rc7
Message-ID: <20111222205626.GB1927@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus - Here is a fix for ecryptfs_statfs(). It had simply deferred
to the lower filesystem's statfs(), but the filename encryption feature
significantly reduces the max filename length. There are a few
applications that have trouble with the filename length limitation and I
think exposing the maximum length in statfs() calls is the first step in
improving the situation.

I'm a little torn on whether the fix needs to go in so late in the
cycle, but I feel it is low risk. If you disagree, I have no problem
waiting for 3.3.

The other patch is an update to Dustin's email address in MAINTAINERS.

The following changes since commit 511585a28e5b5fd1cac61e601e42efc4c5dd64b5:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2011-12-19 15:13:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git for-linus

Dustin Kirkland (1):
      MAINTAINERS: Update eCryptfs maintainer address

Tyler Hicks (1):
      eCryptfs: Improve statfs reporting

 MAINTAINERS                   |    2 +-
 fs/ecryptfs/crypto.c          |   68 ++++++++++++++++++++++++++++++++++++----
 fs/ecryptfs/ecryptfs_kernel.h |    5 +++
 fs/ecryptfs/keystore.c        |    9 ++---
 fs/ecryptfs/super.c           |   14 ++++++++-
 5 files changed, 83 insertions(+), 15 deletions(-)

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJO85l6AAoJENaSAD2qAscKUqkQAMI9i7VPwwRI1aZBBqKkT2iF
8/1U27QTC9GBmwHodYMXpfaydfK674/avjmXiyuyeDClpzZKuW8EXKT0gA3cip31
rRZaIR39myEN0iYm8KnkiIeIbrArSo12pX3u82zguudVYGc6X3TBtwj2noew88E6
eBabqAUjO0hd5fxgAG9Cm5I5dyWyfx5xoFa1MAGM3END+DhisY7eorQJmusLsJi+
KphOOt8jOfTEesTwvOLwOregNc+mm1TT7beml2+0sBjckMQa/R/0/lvSWCIO2vRN
YBzjIcOLVfGfNlLnF9s0Lfps3Y1vJPa0x2kNpmUMUyi7NjHZzdvHBDYM37nOf2Gq
CszdYmy4jaeshoa1ChdtBE+GRN0MoV4nHvgT8igNa/s4Ai6KP7FwcQmo0fyCXPCu
P+BdWQcvsL34HJEckW+RtkJZlUOluHubrwr3vStVnA9YmT2uDElF3h0PY4BbCzg5
/9XVoUakJfr00hz0TW6AFMRG0NGZSu3P+buYEePwHhzbtzl2Hyf4QYDbYbl0+bVn
PQpmvPugSjpyhHy369zIg2i8jRY6/SldoZdEnmNBPZ76TbnVOhKyCaexYmQ9VRpF
djv20QsZcxx4D3cZrOl2XGB6yZRRvvx4EibGkOeFyz8ISObYBsIMl09oaBKGv7uB
WXWBvHiYAuP9ucYrm0vo
=farI
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
