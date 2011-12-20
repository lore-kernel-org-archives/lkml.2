Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1LTUzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:55:15 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:4540 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1LTUzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:55:10 -0500
Date: Tue, 20 Dec 2011 21:27:12 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20111220202711.GD6830@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20111107194838.GA23558@alea.gnuu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Alexander,

J=C3=B6rg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
>   CHK     include/linux/version.h
>   HOSTCC  scripts/mod/modpost.o
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   HOSTLD  scripts/mod/modpost
>   GEN     include/generated/bounds.h
>   CC      arch/powerpc/kernel/asm-offsets.s
> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In function =
=E2=80=98compute_tlbie_rb=E2=80=99:
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: error=
: =E2=80=98HPTE_V_SECONDARY=E2=80=99 undeclared (first use in this function)
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: note:=
 each undeclared identifier is reported only once for each function it appe=
ars in
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: error=
: =E2=80=98HPTE_V_1TB_SEG=E2=80=99 undeclared (first use in this function)
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: error=
: =E2=80=98HPTE_V_LARGE=E2=80=99 undeclared (first use in this function)
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: warnin=
g: right shift count >=3D width of type [enabled by default]
> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
> make[2]: *** [prepare0] Fehler 2
> make[1]: *** [deb-pkg] Fehler 2
> make: *** [deb-pkg] Fehler 2

I'm so sorry to have to report a new bug in one of your patches. It was
covered by the one above. I've picked the commit for it from your git
repository and now, the kernel build fails with this error:

  BOOTCC  arch/powerpc/boot/fdt_strerror.o
  BOOTAR  arch/powerpc/boot/wrapper.a
  WRAP    arch/powerpc/boot/zImage.pmac
  WRAP    arch/powerpc/boot/zImage.coff
ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
make[3]: *** [__modpost] Fehler 1
make[2]: *** [modules] Fehler 2
make[2]: *** Warte auf noch nicht beendete Prozesse...
  WRAP    arch/powerpc/boot/zImage.miboot
make[1]: *** [deb-pkg] Fehler 2
make: *** [deb-pkg] Fehler 2

The bug was introduced by this commit

HEAD is now at aacf9aa KVM: PPC: Stub emulate CFAR and PURR SPRs
a668f2bd3f14ce7f92e119f4b5d9b50cdc59e855 is the first bad commit
commit a668f2bd3f14ce7f92e119f4b5d9b50cdc59e855
Author: Alexander Graf <agraf@suse.de>
Date:   Mon Aug 8 17:26:24 2011 +0200

    KVM: PPC: Support SC1 hypercalls for PAPR in PR mode
   =20
    PAPR defines hypercalls as SC1 instructions. Using these, the guest mod=
ifies
    page tables and does other privileged operations that it wouldn't be al=
lowed
    to do in supervisor mode.
   =20
    This patch adds support for PR KVM to trap these instructions and route=
 them
    through the same PAPR hypercall interface that we already use for HV st=
yle
    KVM.
   =20
    Signed-off-by: Alexander Graf <agraf@suse.de>

Bye, J=C3=B6rg.
--=20
=E2=80=9CPerl=E2=80=94the only language that looks the same
 before and after RSA encryption.=E2=80=9D           (Keith Bostic)

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7w758ACgkQwe0mZwH1VIBYegCZAd1r6ElQEfZwjgTv2l72r1Vi
jK0An1+I7MfAMGHTdNfcVNhM3ibXqK53
=05eO
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
