Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2BVWbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:31:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52298 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2BVWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:31:52 -0500
Date: Thu, 23 Feb 2012 09:31:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt@console-pimps.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: Fix unaligned access and endian issues
Message-Id: <20120223093140.3f8ad47252f9f331d355ea57@canb.auug.org.au>
In-Reply-To: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
References: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Feb_2012_09_31_40_+1100_VQ6Vfu0Nu5=PkT4w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Feb_2012_09_31_40_+1100_VQ6Vfu0Nu5=PkT4w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Wed, 22 Feb 2012 14:00:08 +0000 Matt Fleming <matt@console-pimps.org> wr=
ote:
>
> From: Matt Fleming <matt.fleming@intel.com>
>=20
> We need to read from and write to 'buf' a byte at a time otherwise
> it's possible we'll perform an unaligned access, which can lead to a
> segfault when cross-building an x86 kernel on risc architectures.
>=20
> Also, we may need to convert the endianness of the data we read
> from/write to buf, so let's add some helper functions to do that.
>=20
> Stephen Rothwell noticed this bug when he hit a segfault while
> cross-building an x86_64 allmodconfig kernel on PowerPC.
>=20
> Cc: H. Peter Anvin <hpa@zytor.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au> (cross build only)

The bzImage from a ARCH=3Dx86_64 defconfig+CONFIG_EFI_STUB cross build is
in http://ozlabs.org/~sfr/bzImage if you want to attempt to boot it.

One little thing is that those two new functions may we warned about as
unused if CONFIG_EFI_STUB is not set (I have not done that build yet).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__23_Feb_2012_09_31_40_+1100_VQ6Vfu0Nu5=PkT4w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRWzMAAoJEECxmPOUX5FEVgMP/2rNY6N6nU8k7vh0xlV+3/iW
Mi+FFcDdqzRIjgTkNRtGsg1sgmF29p5M8HbpaJ3ysukh4HgieZ+oazPbj6NcAlRn
lko10dYyTtXqG0DzwuM5NVgqxVWIBPYeuw0eH45avtNUI+sNRF9JdvHrGzb8t1Oo
5ub5srCKhdW3ooQtLZ//1L/eaipmMFDKA/KcOj+1AocEXwhBpiTOcMmLlUnRRiUB
YRajAznFZ2jx/w11rQpA2M1GEg8evtTt4ILXQ6oAB7dNXW8RWWdonail1co++jm/
pt0SP0g0GPA5NAXkkNmtrSuWTclR4ZoHU5+0ikytExzjREr8q7OoXg2+g7ayCDE2
2o283fnNCixh5pXierpn8Mi5Lz/T2JBL1beNQzRcotWFkAfu+X7PJNn+pSVyf1Dt
IFBFnRjvV+j4RiZtrAKINAmrMBWy1EfgIpqKuOfyvMSHmW40qctzP/8FhFIHRfgw
JDq6KFZHbGkKobPJaYT8jmZDWYYlzf1B8HLN/wyaaOmjdIlTjcLIJWTm1+gkl3r+
oB2cTqk7oNmycI7f7Jff57/6DVeLh2mPIGTdBfrYPmaLfzg/q/yaVg0/KYHKJhpQ
uO1uZ2/HEIBeUqkPGIPOtpPtFnwAKyg6/+ODhCEenwI4BW2neonzoxMuTyIpQ1s9
Z5dKm1/mAzWv1rAoL0AH
=Bcbk
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Feb_2012_09_31_40_+1100_VQ6Vfu0Nu5=PkT4w--
