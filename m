Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2B1XwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 18:52:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41373 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2B1XwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:52:22 -0500
Date: Wed, 29 Feb 2012 10:52:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC][PATCH 5/6] x86, efi: Fix endian issues and unaligned
 accesses
Message-Id: <20120229105210.312c6a8f8115659d41337518@canb.auug.org.au>
In-Reply-To: <1330436245-24875-6-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
	<1330436245-24875-6-git-send-email-matt@console-pimps.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_10_52_10_+1100_UX5dupHxQJRWr3PU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_10_52_10_+1100_UX5dupHxQJRWr3PU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 28 Feb 2012 13:37:24 +0000 Matt Fleming <matt@console-pimps.org> wr=
ote:
>
> From: Matt Fleming <matt.fleming@intel.com>
>=20
> We may need to convert the endianness of the data we read from/write
> to 'buf', so let's use {get,put}_unaligned_le32() to do that. Failure
> to do so can result in accessing invalid memory, leading to a
> segfault.  Stephen Rothwell noticed this bug while cross-building an
> x86_64 allmodconfig kernel on PowerPC.
>=20
> We need to read from and write to 'buf' a byte at a time otherwise
> it's possible we'll perform an unaligned access, which can lead to bus
> errors when cross-building an x86 kernel on risc architectures.
>=20
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Nick Bowler <nbowler@elliptictech.com>
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Just to be absolutely clear, I have not yet tested this version of the
patch and also this fixes a problem with cross building Linus' tree (i.e.
this is a regression with cross building introduced in v3.3-rc1).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Feb_2012_10_52_10_+1100_UX5dupHxQJRWr3PU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTWiqAAoJEECxmPOUX5FE5CgP/1bxIQpEjGBIYk36nAWP1+XL
xrEn6+e1yEIgiMH7Xqwdn/J7SMg0LrloHwXtFIv60Ji7PBbHCCvEWXILd9qo54nV
8Yp+BYYaHSEXbcavj2YFENrMjQx/Y0YZpJo8Upym4/D70S+Xk9qc721eWj3wMATv
QZq3/qzrC4qUggygqIumsdjplZUWoiTzwSn6ygRL8gLiC6zLQq1VcUiPdsCkXmW9
+8iJADduN7qukDty9tBQXCRxSyQiC4o/d88yxTZO/rV8gHLaN/3G9zhliuDMTmgu
krgmrPsTbT+kBMNjgrSuuQ+Uj3bbw0COhYOL0sBXqiFlzdcqEXjIfFQHG2eJI3f0
Iq4kuA1pl1qNn+7I3WsDwl2+lNB58qluIMjAuayKu7FNdi58fSdVIbyA4R53y9Ld
+ZA51z+pTG28GH1pxqMAp5UfBEAzJJxrskUcyOL6ZbkDCAr9fYnFOT8ZaHF89Lua
EVS/bCNNSfTQFBUuL/BjYzJTDqvedmcMKutf7WoMXfhTb7NvzUUGKcyXLTYQKRAK
xqf/icO62LL16EcGEuFTZVjNEWtX4qfkbOWoJaEy28g999AH6NmuS2Hug4zRIkPZ
wvTDhRK4eBXfVkF6udAHEDbEEnyd+zNaYpZ92IkvBPOFrtHKtTS5wEE3BpXnXt+V
1BFdCIgn+Z/nghAJb9Kz
=/75Z
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_10_52_10_+1100_UX5dupHxQJRWr3PU--
