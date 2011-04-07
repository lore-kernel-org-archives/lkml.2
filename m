Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab1DGBGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:06:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44416 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab1DGBGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:06:40 -0400
Date: Thu, 7 Apr 2011 11:06:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Ott <alan@signal11.us>
Subject: linux-next: build failure after merge of the hid tree
Message-Id: <20110407110626.397202fb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Apr_2011_11_06_26_+1000_IaFTRZp2oWdx7hcK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Apr_2011_11_06_26_+1000_IaFTRZp2oWdx7hcK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

samples/hidraw/hid-example.c: In function 'main':
samples/hidraw/hid-example.c:103: warning: implicit declaration of function=
 'HIDIOCSFEATURE'
samples/hidraw/hid-example.c:111: warning: implicit declaration of function=
 'HIDIOCGFEATURE'
tmp/ccK96SHd.o: In function `main':
hid-example.c:(.text+0x205): undefined reference to `HIDIOCSFEATURE'
hid-example.c:(.text+0x23e): undefined reference to `HIDIOCGFEATURE'

Caused by commit c54ea4918c2b ("HID: Documentation for hidraw").  I can
only assume that linux/hidraw.h is being included from /usr/include and
not the kernel tree being built?

I have used the hid tree from next-20110406 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Apr_2011_11_06_26_+1000_IaFTRZp2oWdx7hcK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnQ4SAAoJEDMEi1NhKgbsuTQH/19GwR+FpBzkeX66xu/5HJrk
iao8it5PsM8GPh/nMdsMgPuJysRxIZEAIy9zoSLcc70wxLuM9TEV1QRFuGez/Hog
5113QnqUgy2tX1BMfHt+cXrqr1YwJfLnEDDeIMbC6JVDYtuu+m3amJDyC2CsMlkn
U09ONzqF6Uu5mOpIeckxKpp1sy93JX3GTOsWZ1dMSqMDH2oL711WoI83ayrZTE4H
jjYsjgakhkpsFZJz7BzB7nSN66Da5G+Vqeb8LBQqlI7AdQ1PF8wW8Zv+n31zWl7W
T0bq3L4Ky/r/GjGYhxunZ1tlvC7udMdBd/x7lxub4Wk/wpdUfb7RQ6ELVZUvKX8=
=au/I
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Apr_2011_11_06_26_+1000_IaFTRZp2oWdx7hcK--
