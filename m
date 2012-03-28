Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2C1PGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:06:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:5905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab2C1PGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="146994344"
Message-ID: <1332947356.31549.92.camel@sauron.fi.intel.com>
Subject: [Announce] Aiaiai
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Wed, 28 Mar 2012 18:09:16 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rJ2AZdyinIDpv3PWNhLx"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rJ2AZdyinIDpv3PWNhLx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I here is a tool which I find very helpful for subsystem maintainers and
individual developers. This tool checks patches or patch-sets using various
existing tools and reports new issues.

The main thing it does is:
1. Build the kernel before the patch and after the patch
2. Compare 2 build logs
3. Report about _new_ gcc warnings, coccinelle/spatch/smatch/cppcheck
   complaints.

For example, you can feed Aiaiai a patch-set, and it may report something
like this:

---------------------------------------------------------------------------=
-----

1  Successfully built configuration "my_defconfig,i386", results:
2
3  --- before_patching.log
4  +++ after_patching.log
5  @@ @@
6  -drivers/staging/cruft/my_drv.c: In function =E2=80=98my_pool_destroy=E2=
=80=99:
7  -drivers/staging/cruft/my_drv.c:165:22: warning: variable =E2=80=98test1=
=E2=80=99 set but not used [-Wunused-but-set-variable]
8  @@ @@
9  +drivers/staging/cruft/my_drv.c: In function =E2=80=98my_event_handler=
=E2=80=99:
10 +drivers/staging/cruft/my_drv.c:311:36: warning: unused variable =E2=80=
=98reg=E2=80=99 [-Wunused-variable]
11 +drivers/staging/cruft/my_drv.c:1001:1-7: preceding lock on line 837 [co=
ccinelle]
12 +drivers/staging/cruft/my_drv.c:834 my_int_data(12) warn: variable deref=
erenced before check 'priv' (see line 827) [smatch]

---------------------------------------------------------------------------=
-----

Line 1 says that configuration my_defconfig for architecture i386 has been =
built,
so the patch-set is at least compilable.

Starting from line 3 we have a diff of 2 build logs - before and after patc=
hing.

Lines 6 and 7 tell that the patch-set eliminated a warning - which is very =
welcome.

Lines 9 and 10 tell that the patch-set introduced a gcc warning - not good.

Line 11 tells that the patch made coccinelle complain about locking - worth=
 checking
as coccinelle scripts we have in the kernel are rather high quality.

Line 12 tells that smatch has a complaint - also worth looking if this is a
false-positive or not.

Additionally, Aiaiai runs the bisectability tests when the patch-set contai=
ns
more than one patch. It applies patches one-by-one and compiles at each ste=
p,
and will report if compilation breaks.

Aiaiai also checks if the patch changes a defconfig file, and if it does, i=
t will
verify that it is changed properly (make savedefconfig was used).

And Aiaiai also runs checkpatch.pl for the whole patch-set (squashed) and
every individual patch.

Aiaiai also includes scripts which may be used to attach it to an e-mail ad=
dress,
so that when you can send patches to this e-mail address, and it will respo=
nd
with test results.

E.g., I use Aiaiai to verify incoming patches for the MTD subsystem since r=
ecently.
I have small helper scripts which run Aiaiai for several configurations and
architectures (i386, x86_64, ia64, ppc64, arm, mips). This makes me feel "s=
afe"
when I apply patches to my l2-mtd.git' tree. I do this also for UBIFS and U=
BI
now.

The README file contains more information:
http://git.infradead.org/users/dedekind/aiaiai.git/blob/refs/heads/master:/=
README

Sorry if this stuff is not very user-friendly - feel free to ask questions =
and
send patches.

You can find Aiaiai here:
git://git.infradead.org/users/dedekind/aiaiai.git
Gitweb: http://git.infradead.org/users/dedekind/aiaiai.git

Credits:
* Intel and my colleagues
* Kirill Shutemov - he started writing this stuff, review, gave ideas, etc
* AltLinux guys for libshell
  (git://git.altlinux.org/people/ldv/packages/libshell.git)
* Al Viro for the remapper
  (git://git.kernel.org/pub/scm/linux/kernel/git/viro/remap.git)
* Julia Lawall for amending coccinelle kernel patches to meet Aiaiai needs
* Dan Carpenter for amending smatch to meet Aiaiai needs
* Eric Melski for the serialize-log idea

--=20
Best Regards,
Artem Bityutskiy

--=-rJ2AZdyinIDpv3PWNhLx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPcymcAAoJECmIfjd9wqK0irgQAM35lwzWuspNHezsa/i3/e1K
BhhgyQeDOc3kEyTpTv97q42BtHHSVIXrthYAncu74jhQSf4tU6PHszp50N2QmSlt
lYDBRN5ffUxDlc5vvtMEfhdJgQzY/gbibe3aEoehXmES6TUjoRUyOB7OsSPAQt7D
ucUrjKlM1BSwWsahbq2WiDjeNOAqY1ALBOoWWYBJVPa7QMgWAK/UplAYDMX3oU8e
Q6ZqD24pARV2PKEwO/PhzbY2Q+MzlWXgUq6xRqZjt8TlSMcYCEeqhJHZRJJ8PPyM
l77wze1ukNlal6YJWw++1bRbGpu5VWqC+um+7rgUg05+iETSAOxCiiwNehYwz2OO
TR25qrFwpS/WJJRIjlAY4+p6rSq8qMIssK39Ixe7AWDj2SvmGG1rf2KyyWtR1c3O
qt0NqTwZoF/8bTZIV1RPlBO2GwioRZI2473AC9VlIbUjH/Ndx60+XscAJ3ntivex
CzatSCedFnS9v3HwEU9N0G3wseFMi9PFKA75CB23/5qHHMkYxCddYgjWQePRj6QC
JWoStd4/K/nZr/MPAvdagRkH6R1Ve/Rry7piE1DNRYuLrWMtIxt1fd4wyxk/bxVk
DagcYOA4tgIvtIIsQgseMmSNAjxVVCRDLmjMnc0ThCKSoQGwxsx1qz+HhUhpKeHZ
BEk/YmsPlDhvNgP+Zo33
=8qvn
-----END PGP SIGNATURE-----

--=-rJ2AZdyinIDpv3PWNhLx--

