Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2BUIeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:34:37 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:2783 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2BUIeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:34:36 -0500
Date: Tue, 21 Feb 2012 09:32:13 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20120221083213.GA19059@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111122200414.GA28205@alea.gnuu.de>
 <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
 <20120220173844.GA2546@alea.gnuu.de>
 <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alexander Graf hat am Mon 20. Feb, 22:27 (+0100) geschrieben:
> On 20.02.2012, at 18:38, J=C3=B6rg Sommer wrote:
> > Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
> >> On 22.11.2011, at 21:04, J=C3=B6rg Sommer wrote:
> >>> [1] =C2=BBkernel BUG at include/linux/kvm_host.h:603!=C2=AB
> >>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
> >>=20
> >> This is unfortunately still there. It's because of preemption being
> >> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
> >=20
> > This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm getting
> > this Oops, when I start qemu.
>=20
> Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git? I
> fixed a bunch of things with preemption since then and it definitely
> worked for me. If it still fails in that tree, I can try again to
> reproduce it :).

This kernel (e9badff4b38a3f8b2c20aa8a30db210caf85a497) fails to build:

  CC [M]  arch/powerpc/kvm/book3s_pr.o
arch/powerpc/kvm/book3s_pr.c: In function =E2=80=98kvm_vcpu_ioctl_get_one_r=
eg=E2=80=99:
arch/powerpc/kvm/book3s_pr.c:883:45: error: cast to pointer from integer of=
 different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:80: error: cast to pointer from integer of=
 different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:284: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:327: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:459: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:748: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:1112: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:1476: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:883:1867: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c: In function =E2=80=98kvm_vcpu_ioctl_set_one_r=
eg=E2=80=99:
arch/powerpc/kvm/book3s_pr.c:898:79: error: cast to pointer from integer of=
 different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:898:114: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:898:319: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:898:364: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:898:502: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:898:591: error: cast to pointer from integer o=
f different size [-Werror=3Dint-to-pointer-cast]
arch/powerpc/kvm/book3s_pr.c:898:2061: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
cc1: all warnings being treated as errors
make[3]: *** [arch/powerpc/kvm/book3s_pr.o] Fehler 1
make[2]: *** [arch/powerpc/kvm] Fehler 2
make[2]: *** Warte auf noch nicht beendete Prozesse...

Sch=C3=B6ne Gr=C3=BC=C3=9Fe, J=C3=B6rg.
--=20
Manchmal denke ich, das sicherste Indiz daf=C3=BCr, da=C3=9F anderswo im Un=
iversum
intelligentes Leben existiert, ist, da=C3=9F niemand versucht hat, mit uns
Kontakt aufzunehmen.                           (Calvin und Hobbes)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9DVo0ACgkQwe0mZwH1VIBv/wCeJkq9IgjWhW6sH4/0HQnij6NU
aZwAn1F4fPDoQCfx6PgybJc02B7+0sNu
=7oUy
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
