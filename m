Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab2JSC4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:56:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47822 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2JSC4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:56:34 -0400
Date: Fri, 19 Oct 2012 13:56:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-Id: <20121019135631.3974b95cb4d8b40e6e8c4550@canb.auug.org.au>
In-Reply-To: <20121018145101.GA17439@linux-mips.org>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
	<20121018145101.GA17439@linux-mips.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Oct_2012_13_56_31_+1100_DstGz=asMZfayNs/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Oct_2012_13_56_31_+1100_DstGz=asMZfayNs/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Thu, 18 Oct 2012 16:51:01 +0200 Ralf Baechle <ralf@linux-mips.org> wrote:
>
> On Thu, Oct 18, 2012 at 05:22:01PM +1100, Stephen Rothwell wrote:
>=20
> > After merging the final tree, today's linux-next build (s390 allyesconf=
ig)
> > failed like this:
> >=20
> > mm/huge_memory.c:1424:2: error: implicit declaration of function 'pmd_p=
gprot' [-Werror=3Dimplicit-function-declaration]
> > mm/huge_memory.c:1424:7: error: incompatible types when assigning to ty=
pe 'pgprot_t' from type 'int'
> >=20
> > (see http://kisskb.ellerman.id.au/kisskb/buildresult/7383823/)
> >=20
> > Caused by commit 35d3d3427314 ("s390/thp: select
> > HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
> > commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
> > from the tip tree.
> >=20
> > N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
> > e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
> > and so will be broken in some configs now as well.
> >=20
> > Anyone have suggested merge fix patches I can apply?
>=20
> See below.

I have added that to linux-next today as a merge fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Oct_2012_13_56_31_+1100_DstGz=asMZfayNs/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgMFfAAoJEECxmPOUX5FEL3kP/R5Ib9BWJFipGr2Gk4JaLSex
l5BnWotzM78OgBFk2Qpb2kL20rFmTPIzoDfdUmt9Rb4K8gWlnt+DwL3bU4ePl+1Z
DoR+uh7sgQ3S9n2dy/Vx81kFOIu9GmIfLF79sIYBSXiD0jDyzjcHjpEY0R6uAHp1
icFpeJKyakNRf66elOU3Gty2R1daypFgQf60wWc+lNncHtrfSNDdbMVnRVLfHNyO
hVCjv+ZzaWvDotHSBbWeWoganjavEqkBghDXvaziK6TZ2WalVLduAYlfM8zqVZF2
0sleU+pNnlWnw1PHotFpiirYfr1hsB9/3h+oR44jKM73/147QDTOHQd262FaY/UJ
1ocWpwSOhuw8rGgeGzbfw+eooOC/Vsh8YX8zT/2eBkznWtWrFY/wMtBSZtzTb+O0
thtdjOXX1YeGRCmeKxER40fXVoTnL7ALbWXY9VbS92xjBFvQv+8PQz/Bt+zZXdI+
PTuCJfeqlbFpe94mPGYAi1Uf9+a+ovJovtgokJdIylouhnGaP1dLDd+B3LGVYZKi
pGGfCdnXHFcfmwgmKLTkpfnK28hPgEEMX6onTTQ90yOj8uadyjFI3pM0QuYDzx0r
i349Z+AY0rz6XS6yfTssng4Xq2SaAJvKYq2FazdQOW46bhVBtd0wVhNgev1oPuAx
dnqzEVysSjPIaI9xxub8
=Z1eG
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Oct_2012_13_56_31_+1100_DstGz=asMZfayNs/--
