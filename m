Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1LXQfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 11:35:14 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:3499 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab1LXQfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 11:35:10 -0500
Date: Sat, 24 Dec 2011 12:13:59 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20111224111359.GB3938@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111220202711.GD6830@alea.gnuu.de>
 <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de>
 <20111224103108.GA19586@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20111224103108.GA19586@alea.gnuu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

J=C3=B6rg Sommer hat am Sat 24. Dec, 11:31 (+0100) geschrieben:
> Alexander Graf hat am Fri 23. Dec, 14:50 (+0100) geschrieben:
> > On 20.12.2011, at 21:27, J=C3=B6rg Sommer wrote:
> > > J=C3=B6rg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
> > >>  CHK     include/linux/version.h
> > >>  HOSTCC  scripts/mod/modpost.o
> > >>  CHK     include/generated/utsrelease.h
> > >>  UPD     include/generated/utsrelease.h
> > >>  HOSTLD  scripts/mod/modpost
> > >>  GEN     include/generated/bounds.h
> > >>  CC      arch/powerpc/kernel/asm-offsets.s
> > >> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
> > >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In func=
tion =E2=80=98compute_tlbie_rb=E2=80=99:
> > >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: =
error: =E2=80=98HPTE_V_SECONDARY=E2=80=99 undeclared (first use in this fun=
ction)
> > >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: =
note: each undeclared identifier is reported only once for each function it=
 appears in
> > >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: =
error: =E2=80=98HPTE_V_1TB_SEG=E2=80=99 undeclared (first use in this funct=
ion)
> > >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: =
error: =E2=80=98HPTE_V_LARGE=E2=80=99 undeclared (first use in this functio=
n)
> > >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: w=
arning: right shift count >=3D width of type [enabled by default]
> > >> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
> > >> make[2]: *** [prepare0] Fehler 2
> > >> make[1]: *** [deb-pkg] Fehler 2
> > >> make: *** [deb-pkg] Fehler 2
> > >=20
> > > I'm so sorry to have to report a new bug in one of your patches. It w=
as
> > > covered by the one above. I've picked the commit for it from your git
> > > repository and now, the kernel build fails with this error:
> > >=20
> > >  BOOTCC  arch/powerpc/boot/fdt_strerror.o
> > >  BOOTAR  arch/powerpc/boot/wrapper.a
> > >  WRAP    arch/powerpc/boot/zImage.pmac
> > >  WRAP    arch/powerpc/boot/zImage.coff
> > > ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
> > > make[3]: *** [__modpost] Fehler 1
> > > make[2]: *** [modules] Fehler 2
> > > make[2]: *** Warte auf noch nicht beendete Prozesse...
> > >  WRAP    arch/powerpc/boot/zImage.miboot
> > > make[1]: *** [deb-pkg] Fehler 2
> > > make: *** [deb-pkg] Fehler 2
> >=20
> > This is odd. kvmppc_h_pr shouldn't be accessed when not in book3s_64_pr=
 mode:
> >=20
> > #ifdef CONFIG_KVM_BOOK3S_64_PR
> >                         if (kvmppc_h_pr(vcpu, cmd) =3D=3D EMULATE_DONE)=
 {
> >                                 r =3D RESUME_GUEST;
> >                                 break;
> >                         }
> > #endif

Is this the change you've thought of?

commit b8624f11e94dd9c2280cb01bf2ede31e4316477d
Author: J=C3=B6rg Sommer <joerg@alea.gnuu.de>
Date:   Sat Dec 24 12:03:03 2011 +0100

    KVM: PPC: Use kvmppc_h_pr only if it's available
   =20
    The function kvmppc_h_pr() is only available when the config option
    CONFIG_KVM_BOOK3S_64_PR is set, which is not the case for 32-bit PowerP=
Cs
    for example. Building the kernel for these systems failed, because the
    symbol could not be resolved.
   =20
    ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
   =20
    Signed-off-by: J=C3=B6rg Sommer <joerg@alea.gnuu.de>

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 4b0f01b..eddab24 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -677,10 +677,12 @@ program_interrupt:
 			ulong cmd =3D kvmppc_get_gpr(vcpu, 3);
 			int i;
=20
+#ifdef CONFIG_KVM_BOOK3S_64_PR
 			if (kvmppc_h_pr(vcpu, cmd) =3D=3D EMULATE_DONE) {
 				r =3D RESUME_GUEST;
 				break;
 			}
+#endif
=20
 			run->papr_hcall.nr =3D cmd;
 			for (i =3D 0; i < 9; ++i) {
--=20
=E2=80=9EEs wurden und werden zu viele sprachlose B=C3=BCcher gedruckt, nac=
h deren
schon fl=C3=BCchtiger Lekt=C3=BCre man all die B=C3=A4ume um Vergebung bitt=
en m=C3=B6chte,
die f=C3=BCr den Schund ihr Leben lassen mussten.=E2=80=9C (Michael J=C3=BC=
rgs,
                      Seichtgebiete =E2=80=93 Warum wir hemmungslos verbl=
=C3=B6den)

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk71s/cACgkQwe0mZwH1VIAUXQCfTaH1k89tBd4sVlc3S3droWOw
gvoAn1GueXCxyL1yYJhCtMz4lanBNtvQ
=jh1E
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
