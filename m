Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2B2IFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:05:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50363 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2B2IFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:05:24 -0500
Date: Wed, 29 Feb 2012 19:04:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC][PATCH 5/6] x86, efi: Fix endian issues and unaligned
 accesses
Message-Id: <20120229190456.f62620c4113466490a4851b5@canb.auug.org.au>
In-Reply-To: <20120229112852.44bb80f99795999e61608267@canb.auug.org.au>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
	<1330436245-24875-6-git-send-email-matt@console-pimps.org>
	<20120229105210.312c6a8f8115659d41337518@canb.auug.org.au>
	<20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
	<20120229112852.44bb80f99795999e61608267@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_19_04_56_+1100_7dTKBW/Uj3ZSBt7+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_19_04_56_+1100_7dTKBW/Uj3ZSBt7+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Feb 2012 11:28:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi again,
>=20
> On Wed, 29 Feb 2012 11:13:22 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > OK, I tried just that patch on top of Linus' tree and obviously that
> > didn't work :-) so I pulled the x86/build branch from the tip tree into
> > my tree (which contained just Linus' tree of today
> > (v3.3-rc5-97-g891003a)). and the build failed like this:
> >=20
> > arch/x86/boot/tools/build.c:36:22: error: asm/boot.h: No such file or d=
irectory
> >=20
> > The build is an ARCH=3Dx86_64 defconfig with CONFIG_EFI_STUB=3Dy.
>=20
> I added V=3D1 and the command line for the build of build.c is
>=20
> gcc -Wp,-MD,arch/x86/boot/tools/.build.d -Iarch/x86/boot -Wall -Wmissing-=
prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -I/scratch/sfr/x8=
6_seg.obj/include   -I/scratch/sfr/x86_seg/tools/include -include /scratch/=
sfr/x86_seg/include/linux/kconfig.h -o arch/x86/boot/tools/build /scratch/s=
fr/x86_seg/arch/x86/boot/tools/build.c =20
>=20
> I am using a separate object tree as well (source tree
> is /scratch/sfr/x86_seg, object is /scratch/sfr/x86_seg.obj).

I have refetched x86/build after these two patches:
	x86, tools: Remove unneeded header files from tools/build.c
	x86, build: Fix portability issues when cross-building

And the kernel build now completes.

Thank you all for all the work.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_19_04_56_+1100_7dTKBW/Uj3ZSBt7+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTdwoAAoJEECxmPOUX5FEk6QP/3VAYXnng0s0VaBZwKT5yVGI
zEZymkq5KjRAd6uM812fi5lIaShD8cWzyXsymo/LHqy3LEZaLPpIwchJynu0gUNb
YcSBADW4P8awT+kJUExyKT2Py/e1YvoLJR+RV91GSMtLvno/MdRGrHDCjWarz77a
7mSigzERrfC1pfi6ldXrHP4vga1CYzDYA8BPAjuBe18pIGBEp3L7CgHdo9OadNWE
rTsAsohSRj482Y4RscPhjNFT5xeIpEAPi6uWsl0OmBTIN4+dhNLbY7Smwy8GyDnA
hogt/ZWonbCNWvvYfyDR+VYJd+FXHGDqnDb8ipHVJ0chosaG8uRclUCbZLCa6lUl
GKzrZUhbhxj+IdFmKAyn/oTA99+HosQEYoikx+udrYOLsPEyqCbRlfYRk/4rbkn2
ub4TPlctUBFR0wqZmt4t3amBzvLEK2Qx1lzQxyRullukxPGsJ/hzHuP13+H6H7wg
hwgxft+i8h6GUiwvUXJkRTnTzYuG3UjnH69sA134/gGNydGKdw7rnAy1qWy8KZr4
nwtyScZrSUQB4RtNk3KscMGvW0IRjKku63MxAbu33OEgJqP/hkLLktSFTTuQdmPb
mO8FP4STRJzamkOzvk98dW05bCi85CtwJtLWRe2Z1OlHGNVlggCOt2sa571PqLTH
v6YMew8QWJhHgPhTa7n9
=4Uur
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_19_04_56_+1100_7dTKBW/Uj3ZSBt7+--
