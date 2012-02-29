Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab2B2ANd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:13:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58684 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965434Ab2B2ANb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:13:31 -0500
Date: Wed, 29 Feb 2012 11:13:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC][PATCH 5/6] x86, efi: Fix endian issues and unaligned
 accesses
Message-Id: <20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
In-Reply-To: <20120229105210.312c6a8f8115659d41337518@canb.auug.org.au>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
	<1330436245-24875-6-git-send-email-matt@console-pimps.org>
	<20120229105210.312c6a8f8115659d41337518@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_11_13_22_+1100_NYDJgF07vTjn=SSo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_11_13_22_+1100_NYDJgF07vTjn=SSo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 29 Feb 2012 10:52:10 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 28 Feb 2012 13:37:24 +0000 Matt Fleming <matt@console-pimps.org> =
wrote:
> >
> > From: Matt Fleming <matt.fleming@intel.com>
> >=20
> > We may need to convert the endianness of the data we read from/write
> > to 'buf', so let's use {get,put}_unaligned_le32() to do that. Failure
> > to do so can result in accessing invalid memory, leading to a
> > segfault.  Stephen Rothwell noticed this bug while cross-building an
> > x86_64 allmodconfig kernel on PowerPC.
> >=20
> > We need to read from and write to 'buf' a byte at a time otherwise
> > it's possible we'll perform an unaligned access, which can lead to bus
> > errors when cross-building an x86 kernel on risc architectures.
> >=20
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Nick Bowler <nbowler@elliptictech.com>
> > Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
>=20
> Just to be absolutely clear, I have not yet tested this version of the
> patch and also this fixes a problem with cross building Linus' tree (i.e.
> this is a regression with cross building introduced in v3.3-rc1).

OK, I tried just that patch on top of Linus' tree and obviously that
didn't work :-) so I pulled the x86/build branch from the tip tree into
my tree (which contained just Linus' tree of today
(v3.3-rc5-97-g891003a)). and the build failed like this:

arch/x86/boot/tools/build.c:36:22: error: asm/boot.h: No such file or direc=
tory

The build is an ARCH=3Dx86_64 defconfig with CONFIG_EFI_STUB=3Dy.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_11_13_22_+1100_NYDJgF07vTjn=SSo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTW2iAAoJEECxmPOUX5FEsvAP/ReH5r/l/8MhkLow34nMkXxX
KPoZ8bv0Jqrrmf8WllTAdf9MKdGBexN0Bw/HWjwsA6bE9SeT/L3jm65/l87jxP7o
oANLwkhYOUMeNux6ZQQwIn0uzmVo3nO4F2gn3xHKsk7Fh3fCE5eKX12IF0z1Mpxa
67ZHIEi2lup3qRHfIII55c7yxEd8FqDCeM/BLUbj4T3DWs5akR8vEx/UuF6qzGU+
KdvnUECi3R+ebG02reCTjZP7sCTlhVsdtsMhXDeINzyMDzqmQarpCzIL3BEEBGRt
zZApcWx1GsE7+hX8R+1XtN30CZgXEO3Muqh8oVCLIlVvCfdbEuSu6ems4lP+SFp7
ADp8tY89nihQwF/MePy17coAPY8k4tx43NnP7nNS11Od2JANUd9QQsTqqr0y+eVH
fDN0eBnA63BA9OMyHgym20UBFFB4AqQryA2pzeHjf4ksFHES08pQ0KiGfo2kKWby
fHoe7JTIp/cF9q/2KYv/VWEezwszxXpc2A2UrDvdUPPCWhykWLEyUhxOE3Gf9idi
IxGTTVhP+TWuVzWW4BEeMNEBa0N2ynAZfSiPKXq5lLwTP+hIa0Xg3X29DCICXDHY
0FcDPXFxbuIedJDoqvV85GH/eJwfFqsvyTNeEwazgzpOQe1laVkAEAUvpDa58GqT
/J7xGvBqNIKzOoq6f0om
=qiqK
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_11_13_22_+1100_NYDJgF07vTjn=SSo--
