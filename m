Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab2CRXvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 19:51:23 -0400
Received: from ozlabs.org ([203.10.76.45]:35023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2CRXvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 19:51:22 -0400
Date: Mon, 19 Mar 2012 10:51:15 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: linux-next: triage for March 18, 2012
Message-ID: <20120318235114.GA30497@thor.bakeyournoodle.com>
Mail-Followup-To: Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>
References: <20120318184105.GC2095@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20120318184105.GC2095@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 18, 2012 at 02:41:05PM -0400, Paul Gortmaker wrote:
> This represents the state of things as of Friday since I didn't
> get a report out then.  Four new arches have been added but none
> of them yet build (top four below).
>=20
> New breakage since last report:
> 	AM33:asb2303_defconfig,asb2364_defconfig (toolchain?)
> 	frv:defconfig  (arch/frv/kernel/head.S operand out of range)
> 	h8300:defconfig (time.c: implicit declaration 'get_irq_regs')
> 	m32r:m32700ut.smp_defconfig (No rule to make vmlinux.bin)
> 	m68k:allmodconfig (persistent_ram.c: implicit declaration 'memblock_rese=
rve')
> 	sparc[64]:allmodconfig (hda/patch_sigmatel.c: 'stac93xx_set_power_state'=
 undeclared)
> 	sparc/m68k:allmodconfig (implicit completion.h - already fixed)
>=20
> Randconfig fails that may or may not be new (by their very nature):
> 	i386: samsung-laptop.c: implicit declaration of 'isalnum'
> 		(http://kisskb.ellerman.id.au/kisskb/buildresult/5884289/)
> 	powerpc: kernel/fadump.c:407:2: error: 'crashing_cpu' undeclared
> 		(http://kisskb.ellerman.id.au/kisskb/buildresult/5884411/)
> 	x86_64: No rule to make scsi/aic7xxx/aicasm/*.[chyl]
> 		http://kisskb.ellerman.id.au/kisskb/buildresult/5884287/
>=20
> Builds that are fixed since last report:
> 	ARM:orion5x_defconfig
> 	powerpc:allmodconfig
>=20
>=20
> Note: The randconfig fails are only listed once and not tracked
> in the below listing.
>=20
>             ------------------------------------------------
>=20
> Latest results at:
> 	http://kisskb.ellerman.id.au/kisskb/branch/9/
>=20
> Failures as of March 18th, 2012:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>=20
> AM33:asb2303_defconfig,asb2364_defconfig
> 	when:	Mar 15, 18:04
> 	why:	cc1: error: unrecognized command line option '-mmem-funcs'
> 	status:	incompatible toolchain?
> 	fix:
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
> ----------------

I submitted a patch for this it hasn't been taken up yet.
	http://marc.info/?l=3Dlinux-kernel&m=3D133185020313818&w=3D2
<SNIP>

> frv:defconfig
> 	when:	Mar 15
> 	why:	arch/frv/kernel/head.S operand out of range
> 	status:
> 	fix:
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884666/
> ----------------

Quite willing to accept that I have built this compiler wrong.

~$ /opt/cross/gcc-4.6.3-nolibc/frv-linux/bin/frv-linux-gcc -v
Using built-in specs.
COLLECT_GCC=3D/opt/cross/gcc-4.6.3-nolibc/frv-linux/bin/frv-linux-gcc
COLLECT_LTO_WRAPPER=3D/opt/crosstool/gcc-4.6.3-nolibc/frv-linux/bin/../libe=
xec/gcc/frv-linux/4.6.3/lto-wrapper
Target: frv-linux
Configured with: /home/tony/buildall/src/gcc/configure --target=3Dfrv-linux=
 --host=3Dppc64-linux-gnu --build=3Dppc64-linux-gnu --enable-targets=3Dall =
--prefix=3D/home/tony/buildall/cross.ppc64/gcc-4.6.3-nolibc/frv-linux/ --en=
able-languages=3Dc --with-newlib --without-headers --enable-sjlj-exceptions=
 --with-system-libunwind --disable-nls --disable-threads --disable-shared -=
-disable-libmudflap --disable-libssp --disable-libgomp --disable-decimal-fl=
oat --enable-checking=3Drelease --with-mpfr=3D/home/tony/buildall/src/sys-p=
pc64 --with-gmp=3D/home/tony/buildall/src/sys-ppc64 --disable-bootstrap --d=
isable-libquadmath
Thread model: single
gcc version 4.6.3 (GCC)=20

If there is somethign I need to chenge when building gcc let me know.

> h8300:defconfig
> 	when:	Mar 15
> 	why:	time.c: implicit declaration of function 'get_irq_regs'
> 	status:=09
> 	fix:
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
> ----------------

Later there is also an internal compiler error reported at:=20
	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D52598

Yours Tony

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZnTyAAoJEEsCiJRY75GK3NYP/1phN/QkydEYZfKkUbY1SJeM
+F74ObG615dLyMs5aCtBD6lKYb41PjS0XCoeRToG881bN3+f/XQMcet8M52qEbaS
/JMkdckOcoNNXZLlesh3YCgKPxl9MReNKn9rZerWNxEQ9oKNotXTT/MhSyj7Dy+1
iXhxWZOB15/gsk++ZKZGJEoeeYObuPj3oKpshmXdtRAUyr7hwFO5cnckwyVU+XgU
tCmT1DwZ9hggbJ6BDXmwguvI1xA/uZluUS13+yHMEn2DuiH64W6gWmgXogwKLv0s
8UbTrRa2PMP26McONQIOs0JI0AvxRebrHHbmK1tmXKAPjwuis6ej23ONtJKh0xQV
NmKaIwYdGJcgfJU2g3n4V9Rk27ktSPAUyUHhlzoqvrqm4soFhj0F8OIedxak4WE8
Q6ZlzSWHM6fKsQVr2ik8lLD7px7d2JYOYL/zOLZ0xaYa6c1CKBc9AssMfhBF0Dfy
i9Eh8/FM+pFax3i7c4pbtmSPgJvbeQ+FHmtS4Iw1glNym20OLC0q1b0VPqMhjjsY
UQgI4CAlhm4V0lC++CbJyh43oVXXvWsscZuT4Bihg3zU78xKna2K4WrqslhCN3bQ
xwhV6mqkBDgNlUPv19WYQPoE/rOb592yVRnDIsdyvYn2U2brT6KeMV+BdkSBdR7R
NQZvK07WSSfscQWUEblW
=MwQv
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
