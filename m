Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1HJCVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:21:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44653 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1HJCVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:21:19 -0400
Date: Wed, 10 Aug 2011 12:21:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>, Jouni Malinen <jouni@qca.qualcomm.com>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20110810122109.a81b3186e4131aba82a4cae0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Aug_2011_12_21_09_+1000_QRT0m2tUiJZh3On9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Aug_2011_12_21_09_+1000_QRT0m2tUiJZh3On9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/net/wireless/ath/ath6kl/built-in.o: In function `htc_start':
(.opd+0x600): multiple definition of `htc_start'
drivers/net/wireless/ath/ath9k/built-in.o:(.opd+0x3e40): first defined here
drivers/net/wireless/ath/ath6kl/built-in.o: In function `.htc_stop':
(.text+0x7b40): multiple definition of `.htc_stop'
drivers/net/wireless/ath/ath9k/built-in.o:(.text+0x67b34): first defined he=
re
drivers/net/wireless/ath/ath6kl/built-in.o: In function `.htc_start':
(.text+0x7d18): multiple definition of `.htc_start'
drivers/net/wireless/ath/ath9k/built-in.o:(.text+0x67ba0): first defined he=
re
drivers/net/wireless/ath/ath6kl/built-in.o: In function `htc_stop':
(.opd+0x5e8): multiple definition of `htc_stop'
drivers/net/wireless/ath/ath9k/built-in.o:(.opd+0x3e28): first defined here

Probably caused by commit bdcd81707973 ("Add ath6kl cleaned up driver").

I have reverted commit 392e741939dd ("Merge branch 'ath6kl-next' of
master.kernel.org:/pub/scm/linux/kernel/git/kvalo/ath6kl") for today.

John, this has happened a couple of times before where people have just
copied an existing driver that happens to have some badly named global
variables.  :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Aug_2011_12_21_09_+1000_QRT0m2tUiJZh3On9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQesVAAoJEDMEi1NhKgbsvToH/A+lSkorOJhMbzfTc/i0qNAF
kLZYWLhoWMxT53pw1BGkND5jSD4d1XZ34OXzUncCbuFpwOnQAQHEO9WOUXGCqi6L
mUjb2sGp+HbOofVwZPPLJ7MkK3BewLIPPsXPbqulghgLJlQXd3+4fntvLdRUF3j1
BuD0SNCQHZjotoE9AAazfhD0aIy0QPeW2TKQIm/KKG5tPvWzEq/LUQMmDjNYr4iw
rYEJ3lVGFz55jZsNV5PuYreYJmbeAuNzlyR8FlD0vECn1hMs5RhidYki4EKLv73l
IvyCsHZnUHhihm34qD5SUK+d+6ENNvdKCyJijjGSPLSh9sKm6qT1Z+vGv+Oxxqg=
=RjcL
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Aug_2011_12_21_09_+1000_QRT0m2tUiJZh3On9--
