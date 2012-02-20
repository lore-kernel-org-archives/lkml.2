Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2BTSUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:20:21 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:4660 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2BTSUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:20:18 -0500
X-Greylist: delayed 1628 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Feb 2012 13:20:18 EST
Date: Mon, 20 Feb 2012 18:38:45 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20120220173844.GA2546@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111122200414.GA28205@alea.gnuu.de>
 <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Alexander,

Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
> On 22.11.2011, at 21:04, J=C3=B6rg Sommer wrote:
> > J=C3=B6rg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
> >> I'm trying to build the kernel with the git commit-id
> >> 31555213f03bca37d2c02e10946296052f4ecfcd, but it fails
> >>=20
> >>  CHK     include/linux/version.h
> >>  HOSTCC  scripts/mod/modpost.o
> >>  CHK     include/generated/utsrelease.h
> >>  UPD     include/generated/utsrelease.h
> >>  HOSTLD  scripts/mod/modpost
> >>  GEN     include/generated/bounds.h
> >>  CC      arch/powerpc/kernel/asm-offsets.s
> >> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In functi=
on =E2=80=98compute_tlbie_rb=E2=80=99:
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: er=
ror: =E2=80=98HPTE_V_SECONDARY=E2=80=99 undeclared (first use in this funct=
ion)
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: no=
te: each undeclared identifier is reported only once for each function it a=
ppears in
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: er=
ror: =E2=80=98HPTE_V_1TB_SEG=E2=80=99 undeclared (first use in this functio=
n)
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: er=
ror: =E2=80=98HPTE_V_LARGE=E2=80=99 undeclared (first use in this function)
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: war=
ning: right shift count >=3D width of type [enabled by default]
> >> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
> >> make[2]: *** [prepare0] Fehler 2
> >> make[1]: *** [deb-pkg] Fehler 2
> >> make: *** [deb-pkg] Fehler 2
> >=20
> > I'm still having this problem. I can' build
> > 6fe4c6d466e95d31164f14b1ac4aefb51f0f4f82. Are there any patches to
> > make the kernel builds and do not oops [1] on PowerPC?
>=20
> The failures above should be fixed by now.
>=20
> > [1] =C2=BBkernel BUG at include/linux/kvm_host.h:603!=C2=AB
> >  http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
>=20
> This is unfortunately still there. It's because of preemption being
> enabled. Please just use CONFIG_PREEMPT_NONE for the time being

This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm getting
this Oops, when I start qemu.

% uname -a
Linux ibook 3.3.0-rc3-00279-g8e4baad #74 Sun Feb 19 03:57:54 CET 2012 ppc G=
NU/Linux

% cat /proc/cpuinfo
processor	: 0
cpu		: 7455, altivec supported
clock		: 606.000000MHz
revision	: 3.3 (pvr 8001 0303)
bogomips	: 36.86
timebase	: 18432000
platform	: PowerMac
model		: PowerBook6,3
machine		: PowerBook6,3
motherboard	: PowerBook6,3 MacRISC3 Power Macintosh
detected as	: 287 (iBook G4)
pmac flags	: 0000001b
L2 cache	: 256K unified
pmac-generation	: NewWorld
Memory		: 640 MB

% grep PREEM /boot/config-$(uname -r)
# CONFIG_PREEMPT_RCU is not set
CONFIG_PREEMPT_NOTIFIERS=3Dy
CONFIG_PREEMPT_NONE=3Dy
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=3Dy

% qemu-system-ppc --version
QEMU emulator version 1.0 (Debian 1.0+dfsg-3), Copyright (c) 2003-2008 Fabr=
ice Bellard

% qemu-system-ppc -M mac99 -cpu 7400 -prom-env 'auto-boot?=3Dfalse' -k de -=
enable-kvm

[ 4205.444343] ------------[ cut here ]------------
[ 4205.444373] kernel BUG at include/linux/kvm_host.h:634!
[ 4205.444407] Oops: Exception in kernel mode, sig: 5 [#1]
[ 4205.444418] PowerMac
[ 4205.444426] Modules linked in: kvm ppp_async crc_ccitt ppp_generic slhc =
ipv6 fuse snd_powermac option usb_wwan
[ 4205.444562] NIP: ea823c34 LR: ea823bcc CTR: 00000000
[ 4205.444579] REGS: e3617a10 TRAP: 0700   Not tainted  (3.3.0-rc3-00279-g8=
e4baad)
[ 4205.444590] MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 28002462  XER: 00000000
[ 4205.444624] TASK =3D e3405bc0[4169] 'qemu-system-ppc' THREAD: e3616000
[ 4205.444634] GPR00: 00000001 e3617ac0 e3405bc0 e3617be0 e34060fc 00000000=
 e3617ddc 00000000=20
[ 4205.444664] GPR08: 00000000 00000000 00000000 00000000 00000000 1036c490=
 103051b8 10304e48=20
[ 4205.444693] GPR16: 48048000 10e2a5c0 10e2ada8 1014662c 00000007 48021018=
 00400000 0000d032=20
[ 4205.444723] GPR24: 00000000 00000900 ffffffff e362f000 00000001 e3405bc0=
 ea83b000 e3617ac0=20
[ 4205.444817] NIP [ea823c34] kvmppc_vcpu_run+0x138/0x210 [kvm]
[ 4205.444843] LR [ea823bcc] kvmppc_vcpu_run+0xd0/0x210 [kvm]
[ 4205.444853] Call Trace:
[ 4205.444876] [e3617ac0] [e3616000] 0xe3616000 (unreliable)
[ 4205.444909] [e3617e20] [ea81e12c] kvm_arch_vcpu_ioctl_run+0x350/0x37c [k=
vm]
[ 4205.444940] [e3617e50] [ea817c98] kvm_vcpu_ioctl+0x158/0x888 [kvm]
[ 4205.444967] [e3617ea0] [c0129020] do_vfs_ioctl+0x714/0x78c
[ 4205.444984] [e3617f10] [c0129100] sys_ioctl+0x68/0x8c
[ 4205.445004] [e3617f40] [c0013b70] ret_from_syscall+0x0/0x38
[ 4205.445022] --- Exception: c01 at 0xf4efa98
[ 4205.445028]     LR =3D 0xf4ef9fc
[ 4205.445036] Instruction dump:
[ 4205.445049] 41a20014 7fc3f378 38800800 38a02000 4bffe929 54290024 380000=
00 8129000c=20
[ 4205.445080] 2f890000 409e000c 7c0000a6 54008ffe <0f000000> 8002000c 7f63=
db78 7fc4f378=20
[ 4205.445119] ---[ end trace 03417e90b5c8db01 ]---
[ 4205.445129]=20
[ 4205.445141] BUG: sleeping function called from invalid context at kernel=
/rwsem.c:21
[ 4205.445156] in_atomic(): 0, irqs_disabled(): 1, pid: 4169, name: qemu-sy=
stem-ppc
[ 4205.445168] Call Trace:
[ 4205.445182] [e36177c0] [c000bc44] show_stack+0xbc/0x194 (unreliable)
[ 4205.445214] [e3617810] [c047bbd4] dump_stack+0x30/0x38
[ 4205.445237] [e3617820] [c0062010] __might_sleep+0xf8/0x100
[ 4205.445253] [e3617830] [c0473324] down_read+0x38/0x60
[ 4205.445278] [e3617840] [c004621c] exit_signals+0x30/0x16c
[ 4205.445300] [e3617870] [c0034ec8] do_exit+0x100/0x74c
[ 4205.445319] [e36178c0] [c000ee6c] die+0x270/0x278
[ 4205.445336] [e36178f0] [c000ef34] _exception+0x64/0x104
[ 4205.445354] [e36179e0] [c0474f70] program_check_exception+0x1dc/0x1e4
[ 4205.445371] [e3617a00] [c00141d0] ret_from_except_full+0x0/0x4c
[ 4205.445421] --- Exception: 700 at kvmppc_vcpu_run+0x138/0x210 [kvm]
[ 4205.445428]     LR =3D kvmppc_vcpu_run+0xd0/0x210 [kvm]
[ 4205.445446] [e3617ac0] [e3616000] 0xe3616000 (unreliable)
[ 4205.445477] [e3617e20] [ea81e12c] kvm_arch_vcpu_ioctl_run+0x350/0x37c [k=
vm]
[ 4205.445508] [e3617e50] [ea817c98] kvm_vcpu_ioctl+0x158/0x888 [kvm]
[ 4205.445526] [e3617ea0] [c0129020] do_vfs_ioctl+0x714/0x78c
[ 4205.445543] [e3617f10] [c0129100] sys_ioctl+0x68/0x8c
[ 4205.445558] [e3617f40] [c0013b70] ret_from_syscall+0x0/0x38
[ 4205.445577] --- Exception: c01 at 0xf4efa98
[ 4205.445583]     LR =3D 0xf4ef9fc

Bye, J=C3=B6rg.
--=20
Man soll Denken lehren, nicht Gedachtes.

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9ChSQACgkQwe0mZwH1VIDDlgCfRdjBNm3GYmnmjMMivromRLxK
FqYAn23NcpdgmYmIPhWSOi2e1uVWGl2L
=obZk
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
