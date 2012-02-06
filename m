Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2BFJMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 04:12:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58198 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2BFJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 04:12:17 -0500
Message-ID: <1328519654.22240.31.camel@sauron.fi.intel.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Date: Mon, 06 Feb 2012 11:14:14 +0200
In-Reply-To: <20120206120706.cf5d951972d22eb7fa134fbd@canb.auug.org.au>
References: <20120206120706.cf5d951972d22eb7fa134fbd@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PEazU30TuUcS8KRchU3/"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PEazU30TuUcS8KRchU3/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-06 at 12:07 +1100, Stephen Rothwell wrote:
> Hi Artem,
>=20
> After merging the l2-mtd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/mtd/devices/pmc551.c:191:12: error: conflicting types for 'pmc551=
_unpoint'
> include/linux/mtd/pmc551.h:37:13: note: previous declaration of 'pmc551_u=
npoint' was here
> drivers/mtd/devices/pmc551.c: In function 'pmc551_unpoint':
> drivers/mtd/devices/pmc551.c:196:1: warning: no return statement in funct=
ion returning non-void [-Wreturn-type]
>=20
> Caused by commit 753c57f84b57 ("mtd: return error code from
> mtd_unpoint").  [Mind you, I don't understand why those static functions
> would be declared in a header file ...]

Thanks, fixed. I am doing rather massive MTD API cleaning, so new small
issues are possible.

WRT the header file - I think it should not be in 'inlude/linux' at all
- I'll try to cook a patch to kick it out of there, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-PEazU30TuUcS8KRchU3/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPL5nmAAoJECmIfjd9wqK00vgP/jTXzDlebZ5EHRT1jhXFa5O2
OUrrBpqHMl81uq7A70JctZXbwVh0nJnc0Uj53SbxCuvjqoPrve7ymC6jLOcWqBU7
M+CZZGmp63jzH5LQzeEVS03bDARqjMDoGh9hO0G+B0fhaqR8IhwUZT5nVvmUwYji
GbuiBD/jqH78Oi+Cl5MwNgYGFXbBpdVCuIBmI2oH9RI4TrNnHS910FsKLOXpTzBM
QHFXUMYt1nhU1mnrjRcx8bWYMrPacwfiS9Xcm6YT9lZngbYnQhNZMkfavr4wwuSk
bH0RUuYGE1Xlbt4lxP5hn8Z4P8FARzu30b5pxuesBZxDQet028EcjRz3gU/laEsJ
H/PCdj7KZLk9RLyp14bkgSh7mX0kQSoi8kKx0uaS0QHBtUbhl2PBXRxH4H1Dqf0D
AoCbtBb/HbaglodVJSf5JnEWz6G8RPmLUQf7wU1510LgSMEUrj9evSwe4EBn7lUP
smniMyefA0FCqt4sCO1M+afaunPiAQeRIA8oLMT06nMm3vh+L36RBIDMRtJ9kHGb
8hnU6199gC4iBNaXjFHZ2h3T7cZHDJ5clCAbQuxVQCCJ41yDlHFFziSpsdIHfnSh
eFakQlTSCzX2C6FTAuZPv8oMqc1Qqlyp/eh2rjTVcC5291RsblT/FCFiFnFu26Hd
xHg4wp2mdy+sLX8QNtSr
=B/mH
-----END PGP SIGNATURE-----

--=-PEazU30TuUcS8KRchU3/--

