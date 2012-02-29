Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966003Ab2B2A3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:29:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48674 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965700Ab2B2A3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:29:01 -0500
Date: Wed, 29 Feb 2012 11:28:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC][PATCH 5/6] x86, efi: Fix endian issues and unaligned
 accesses
Message-Id: <20120229112852.44bb80f99795999e61608267@canb.auug.org.au>
In-Reply-To: <20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
	<1330436245-24875-6-git-send-email-matt@console-pimps.org>
	<20120229105210.312c6a8f8115659d41337518@canb.auug.org.au>
	<20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_11_28_52_+1100_8m47qflftD7wlmH8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_11_28_52_+1100_8m47qflftD7wlmH8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, 29 Feb 2012 11:13:22 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> OK, I tried just that patch on top of Linus' tree and obviously that
> didn't work :-) so I pulled the x86/build branch from the tip tree into
> my tree (which contained just Linus' tree of today
> (v3.3-rc5-97-g891003a)). and the build failed like this:
>=20
> arch/x86/boot/tools/build.c:36:22: error: asm/boot.h: No such file or dir=
ectory
>=20
> The build is an ARCH=3Dx86_64 defconfig with CONFIG_EFI_STUB=3Dy.

I added V=3D1 and the command line for the build of build.c is

gcc -Wp,-MD,arch/x86/boot/tools/.build.d -Iarch/x86/boot -Wall -Wmissing-pr=
ototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -I/scratch/sfr/x86_=
seg.obj/include   -I/scratch/sfr/x86_seg/tools/include -include /scratch/sf=
r/x86_seg/include/linux/kconfig.h -o arch/x86/boot/tools/build /scratch/sfr=
/x86_seg/arch/x86/boot/tools/build.c =20

I am using a separate object tree as well (source tree
is /scratch/sfr/x86_seg, object is /scratch/sfr/x86_seg.obj).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_11_28_52_+1100_8m47qflftD7wlmH8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTXFEAAoJEECxmPOUX5FE6AsP/3Dxjlu7M9CKncDYbsdExM8+
U2LZHPzkqxWsvOm/T1S7Ahq7P0m0H0bC+J0H7JY1OBi0LdeH/nKZnHoNjeljhoXS
g9fgUpz/7t4ilxw6OJQU5T39RG7Q4X6685DTNPNErAVtH1OULZIAmxsj1is7K2XH
0bcOBKwtdL44U2ZHrFkGEyZuQ+9avBIPimAnU5kdhQiWRmztnMo1NcF9tcBnD5nM
toTBuZ46N2PmQ2b4IezhNkf+JgUuocdiHazwPo5eKY38kk208MEpC4wKzr8q8r4o
6YSIEk04tC7MhQK4KTeNjekQq1TftLOkfEtxiWCveUuTRgDjie608wzMyQ7yk3xc
bcIxwYhTo+vBekoXamTFLfwOC9Vlpyc6efbYAvHVMfJsL90pv8TZqMu8E3YwNX4z
Ga9TP7/q8Oogd6ppT8el6mQeSfTefTxdd/u1YG1VZVRgH+g3hyA4y5vHULWj9s2Y
f4eTkCQ6ufbcEFPQyYdYdDXXOizlWQorghcVZDl2Nv5CoPJnm74H5fEl6BBykuZS
C1+I+91O7mRXzKJEmxRFDLIWyTSDfMFq2t5R9y1Xj7ryXxHS3zVmrCEprvxlXm8A
XBrtJLdTK/bVR/ERblOjbnWq+Dmx5RvnNgGcEEClOEnxuSMyCOtgEUYzvozOlhAS
Nfi8IgldEo090FwMG9FM
=pRks
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_11_28_52_+1100_8m47qflftD7wlmH8--
