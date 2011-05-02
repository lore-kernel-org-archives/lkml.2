Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1EBF5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:57:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38484 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1EBF5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:57:23 -0400
Date: Mon, 2 May 2011 15:57:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-Id: <20110502155712.ab6a64ba.sfr@canb.auug.org.au>
In-Reply-To: <20110502043642.GD11804@redhat.com>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
	<20110502022417.GA11804@redhat.com>
	<20110502134524.40da4245.sfr@canb.auug.org.au>
	<20110502142454.a7091ad5.sfr@canb.auug.org.au>
	<20110502043642.GD11804@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_May_2011_15_57_12_+1000_0W8Ph+ngFt8dNdim"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_May_2011_15_57_12_+1000_0W8Ph+ngFt8dNdim
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 2 May 2011 00:36:43 -0400 Dave Jones <davej@redhat.com> wrote:
>
> That's interesting. That suggests that something isn't being built with K=
BUILD_CFLAGS.
> I did a full defconfig build on x86-64 successfully (allmodconfig is chur=
ning away).
> Can you point me at something that doesn't build ?

I have just done an i386 defconfig build with V=3D1.  Every compilation has
that flag passed to it, but only one complains:

  i386-linux-gcc -Wp,-MD,kernel/.futex.o.d  -nostdinc -isystem /opt/cross/g=
cc-4.4.5-nolibc/i386-linux/bin/../lib/gcc/i386-linux/4.4.5/include -I/scrat=
ch/sfr/next/arch/x86/include -Iarch/x86/include/generated -Iinclude  -I/scr=
atch/sfr/next/include -include include/generated/autoconf.h  -I/scratch/sfr=
/next/kernel -Ikernel -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-t=
rigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declara=
tion -Wno-format-security -fno-delete-null-pointer-checks -Os -m32 -msoft-f=
loat -mregparm=3D3 -freg-struct-return -mpreferred-stack-boundary=3D2 -marc=
h=3Di686 -mtune=3Dgeneric -Wa,-mtune=3Dgeneric32 -ffreestanding -DCONFIG_AS=
_CFI=3D1 -DCONFIG_AS_CFI_SIGNAL_FRAME=3D1 -DCONFIG_AS_CFI_SECTIONS=3D1 -pip=
e -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-=
sse2 -mno-3dnow -Wframe-larger-than=3D2048 -fno-stack-protector -Wno-unused=
-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdec=
laration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-=
stack    -D"KBUILD_STR(s)=3D#s" -D"KBUILD_BASENAME=3DKBUILD_STR(futex)"  -D=
"KBUILD_MODNAME=3DKBUILD_STR(futex)" -c -o kernel/futex.o /scratch/sfr/next=
/kernel/futex.c
/scratch/sfr/next/kernel/futex.c: In function 'fixup_pi_state_owner':
/scratch/sfr/next/kernel/futex.c:1549: warning: 'curval' may be used uninit=
ialized in this function
/scratch/sfr/next/kernel/futex.c: In function 'futex_lock_pi_atomic':
/scratch/sfr/next/kernel/futex.c:678: warning: 'curval' may be used uniniti=
alized in this function
/scratch/sfr/next/kernel/futex.c: In function 'handle_futex_death':
/scratch/sfr/next/kernel/futex.c:2454: warning: 'nval' may be used uninitia=
lized in this function
At top level:
cc1: warning: unrecognized command line option "-Wno-unused-but-set-variabl=
e"

I removed kernel/futex.o and recompiled to verify.  futex.c doesn't seem
to be built any differently to anything else.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_May_2011_15_57_12_+1000_0W8Ph+ngFt8dNdim
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNvke4AAoJEDMEi1NhKgbsZXUH/3mKFehSW9ZxBAM/1YkbkcW0
ZWLdAEg1qc3616fGKeGYYAGLiONDpopcqHI8WC4vRz7DNrA/1LyfYHcUlK7DN3gJ
znyttATrsPzly1s+FzHsPjhJI3CD4+QIh3TLrS/rMNgOgmaPuzPoALBBHLSs0ira
B+jv14LDRJJms63LkTWyGGdprGGY0JGaXlHJ3zS9PWukcCMcjJNdEakwN4aY5B+c
gxJr1AjjVPqrta5A9P+RU16cRmP4z9XK0U5JbMXZ0FP/CmosdeHlUXs1xUFbez6R
DQp5Rv/LPhaS90ivmM6BzF1nGhBwXBJHXcmCjEZ531aUkHCwBBH0Sbc4EeGiwQ8=
=W6ZN
-----END PGP SIGNATURE-----

--Signature=_Mon__2_May_2011_15_57_12_+1000_0W8Ph+ngFt8dNdim--
