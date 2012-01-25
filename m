Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2AYWM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:12:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AYWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:12:56 -0500
Date: Wed, 25 Jan 2012 16:12:50 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.3-rc2
Message-ID: <20120125221249.GH16865@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dMdWWqg3F2Dv/qfw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dMdWWqg3F2Dv/qfw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus - Here's a pile of eCryptfs bug fixes.

Tim's logging message update will be really helpful to users when
they're trying to locate a problematic file in the lower filesystem with
filename encryption enabled.

You'll recognize the fix from Li, as you commented on that.

You should also be familiar with my setattr/truncate improvements, since
you were the one that pointed them out to us (thanks again!). Andrew
noted the /dev/ecryptfs write count sanitization needed to be improved,
so I've got a fix in there for that along with some other less important
cleanups of the /dev/ecryptfs read/write code.

They've all sat in -next for at least a day, while some have been there
around a week, I believe.

I'll get signed tags going for the next pull request I send. That was my
intention this time, but it just hit me that I forgot to do it.

Thanks,
Tyler

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git for-linus

Dustin Kirkland (1):
      MAINTAINERS: Update eCryptfs maintainer address

Li Wang (1):
      eCryptfs: Infinite loop due to overflow in ecryptfs_write()

Tim Gardner (2):
      ecryptfs: Improve metadata read failure logging
      ecryptfs: Remove unnecessary variable initialization

Tyler Hicks (7):
      eCryptfs: Sanitize write counts of /dev/ecryptfs
      eCryptfs: Report errors in writes to /dev/ecryptfs
      eCryptfs: Replace miscdev read/write magic numbers
      eCryptfs: Make truncate path killable
      eCryptfs: Check inode changes in setattr
      eCryptfs: Remove unused ecryptfs_read()
      eCryptfs: Fix oops when printing debug info in extent crypto functions

 MAINTAINERS                   |    2 +-
 fs/ecryptfs/crypto.c          |   54 +++-------------
 fs/ecryptfs/ecryptfs_kernel.h |    5 ++
 fs/ecryptfs/inode.c           |   48 +++++++++++----
 fs/ecryptfs/keystore.c        |    5 +-
 fs/ecryptfs/miscdev.c         |  140 +++++++++++++++++++++++++----------------
 fs/ecryptfs/read_write.c      |   96 +++++-----------------------
 7 files changed, 155 insertions(+), 195 deletions(-)

--dMdWWqg3F2Dv/qfw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPIH5hAAoJENaSAD2qAscKo+0P/3Zr22MgWwd9cnvoW5izn0T7
YezTFTbR2BZ8vRRuE0HAgmUdQDtMmv/UpZLs5WvUfAFk0BcYQHiN+N7dHbFNqY4q
g9ok9V2pBtFVYzFuTqy83JkGVzVkLutg4Bils9JE+K9dfOLTMQQiEwrD+qL8AfrY
rac5ICUUZsXrri24L9zOFMt+PxHTJ6Hhod89tvTosgxYhnfaUqGlWBG/wrNBUr1i
Msw98Cmjd7YkUbWa6FqGSgb1k0YODXek6wd5ah3MS1k1Ujuh+XElgGXu2LQLKfHS
IkRuhu1hhUS0JkXkPYd33d1wjxcDOj/BFdyJAwSMz7LDYg8J5BaSnPxO/1gH6Wp9
kKhcGytoS2jttbUkoC8ViN4lpvJOGWLjAtzp9lkuN8AtGE3yCE3JVc+ZbR+4ZLmx
HDTab1DNywOb3EjcrT0hW9OzDPgXfUivPeWjLZoW1lEI2hfDwt7Uxx5H+Il+B/CR
ycn7kO0av7O+7Pr7lEsRA8WuUi7wjuBLVP6LqF1mLQAL0/g4GdkPUtYhJuvdUiST
knzMxA6vLojg9wa5zPnVMlJMTnhL7ml/bwhZy5I0Fg6aUfnBVeOdLv95eeZ1k5jK
L13BMeBo8XNnlHhAyerLqgImD0F5oZLwWTvtxp9QjUVPTpv9V6dsBN6iij0EDN/T
ezAdSa2SJ5Vm0XPL9/hF
=PY6L
-----END PGP SIGNATURE-----

--dMdWWqg3F2Dv/qfw--
