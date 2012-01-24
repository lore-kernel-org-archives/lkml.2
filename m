Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2AXAvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:51:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52980 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab2AXAvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:51:22 -0500
Date: Tue, 24 Jan 2012 11:51:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure in Linus' tree
Message-Id: <20120124115110.a94c5c0393253bf5b8c3b048@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Jan_2012_11_51_10_+1100_BXDbPWF3drHbnf2A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jan_2012_11_51_10_+1100_BXDbPWF3drHbnf2A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the origin tree, today's linux-next build (x86_64 allmodconfi=
g)
failed like this:

usr/include/linux/fs.h:13: included file 'linux/migrate_mode.h' is not expo=
rted

Caused by commit 6536e3123e5d ("mm: fix warnings regarding enum migrate_mod=
e").

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 24 Jan 2012 11:41:32 +1100
Subject: [PATCH] migrate_mode.h is not exported to user mode

so move its include into fs.h inside the __KERNEL__ protection.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4b3a41f..386da09 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -10,7 +10,6 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
-#include <linux/migrate_mode.h>
=20
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -397,6 +396,7 @@ struct inodes_stat_t {
 #include <linux/rculist_bl.h>
 #include <linux/atomic.h>
 #include <linux/shrinker.h>
+#include <linux/migrate_mode.h>
=20
 #include <asm/byteorder.h>
=20
--=20
1.7.9.rc0.23.g7e521

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__24_Jan_2012_11_51_10_+1100_BXDbPWF3drHbnf2A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHgB+AAoJEECxmPOUX5FE5XcP/RDzSfGZnnzLHKINuQFNPtBr
VFrUFS4d9yjmJKfX4rYrxJt7sT4k0vYwox+rymukKCCjN+F9/QjQGBlfLc69tisR
wYsxNnwcy+VE+r/7YWdiNDNshAzx6A/aRCBVp1vZj6adhaHC3wQ+bDiSidW61JTX
Jo6VUX6oj5AlkMn03C8M0FfzlVxJFDW30f4VFC4Pr7+QIxXPSgQO+HPuqT0Zzk8u
KXus2uWvuNEzqpaks3puwK5CmcpevWE8hVD9nzs6dz8FX4QhTt9fwyq1wctUOqY1
48X/Iq1XZJ1jeM/BMtGhzy30URxPGb1xtoXdmHZaCvVw91JSJyhHw3xetUj4G7Jb
shxNE57FVZ4XtH8MOX5Oy+ls/5Vl0QxAeA9WgKbz1XmYB2a2JRRXtmIQrqSZ8dW7
l1F4iMYBjKq+tWJj4pBpDN7Xlg6K5pO9bWCx3T+1pz7EU917vuzWioNa5QB7dZz/
zc5FTlO0UMgVIPAjRW+ZyZPMFAeCKaGicMjhtEnvacq0jwcYgG1ThnC/hmJLG610
R348ditoYk9/0u0J6ENZGZh6E0mMWLRNGHfcQ0SslWvudjvpiKuRP093GU+nQJ5i
NiasQy9r8jZQVYLGMscoZ24nFP7aZwza30L7sCq2m4Jo68UaSA6asxu0tylECCwl
BAythB0vb8HTW6j6sIY6
=uNiI
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jan_2012_11_51_10_+1100_BXDbPWF3drHbnf2A--
