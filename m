Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2B0Lc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:32:57 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:3899 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2B0Lcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:32:55 -0500
Date: Mon, 27 Feb 2012 12:31:34 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20120227113133.GA2739@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111122200414.GA28205@alea.gnuu.de>
 <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
 <20120220173844.GA2546@alea.gnuu.de>
 <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de>
 <20120221083213.GA19059@alea.gnuu.de>
 <20120225145115.GB22460@alea.gnuu.de>
 <3E36BEF4-E15F-410A-82C1-A8EB17AEF0DA@suse.de>
 <20120227000847.GA30855@alea.gnuu.de>
 <FE16BFF8-0C0C-4FFB-B64F-BF4497B12AA4@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <FE16BFF8-0C0C-4FFB-B64F-BF4497B12AA4@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alexander Graf hat am Mon 27. Feb, 01:30 (+0100) geschrieben:
> On 27.02.2012, at 01:08, J=C3=B6rg Sommer wrote:
>=20
> > Alexander Graf hat am Sun 26. Feb, 12:43 (+0100) geschrieben:
> >> On 25.02.2012, at 15:51, J=C3=B6rg Sommer wrote:
> >>> J=C3=B6rg Sommer hat am Tue 21. Feb, 09:32 (+0100) geschrieben:
> >>>> Alexander Graf hat am Mon 20. Feb, 22:27 (+0100) geschrieben:
> >>>>> On 20.02.2012, at 18:38, J=C3=B6rg Sommer wrote:
> >>>>>> Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
> >>>>>>> On 22.11.2011, at 21:04, J=C3=B6rg Sommer wrote:
> >>>>>>>> [1] =C2=BBkernel BUG at include/linux/kvm_host.h:603!=C2=AB
> >>>>>>>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
> >>>>>>>=20
> >>>>>>> This is unfortunately still there. It's because of preemption bei=
ng
> >>>>>>> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
> >>>>>>=20
> >>>>>> This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm ge=
tting
> >>>>>> this Oops, when I start qemu.
> >>>>>=20
> >>>>> Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git?=
 I
> >>>>> fixed a bunch of things with preemption since then and it definitely
> >>>>> worked for me. If it still fails in that tree, I can try again to
> >>>>> reproduce it :).
> >>>>=20
> >>>> This kernel (e9badff4b38a3f8b2c20aa8a30db210caf85a497) fails to buil=
d:
> >>>>=20
> >>>> CC [M]  arch/powerpc/kvm/book3s_pr.o
> >>>> arch/powerpc/kvm/book3s_pr.c: In function =E2=80=98kvm_vcpu_ioctl_ge=
t_one_reg=E2=80=99:
> >>>> arch/powerpc/kvm/book3s_pr.c:883:45: error: cast to pointer from int=
eger of different size [-Werror=3Dint-to-pointer-cast]
> >>>> arch/powerpc/kvm/book3s_pr.c:883:80: error: cast to pointer from int=
eger of different size [-Werror=3Dint-to-pointer-cast]
> >=20
> >> Yikes. Does this patch work for you?
> >=20
> >> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr=
=2Ec
> >> index ee222ec..f329eae 100644
> >> --- a/arch/powerpc/kvm/book3s_pr.c
> >> +++ b/arch/powerpc/kvm/book3s_pr.c
> >> @@ -880,7 +880,8 @@ int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vc=
pu, struct kvm_one_reg *reg)
> >>=20
> >>        switch (reg->id) {
> >>        case KVM_REG_PPC_HIOR:
> >> -               r =3D put_user(to_book3s(vcpu)->hior, (u64 __user *)re=
g->addr);
> >> +               r =3D put_user(to_book3s(vcpu)->hior,
> >> +                            (u64 __user *)(long)reg->addr);
> >=20
> > Yes and no. It brings me a step further, but not to a working kernel.
> >=20
> >  CHK     include/linux/version.h
> >  CHK     include/generated/utsrelease.h
> >  CALL    scripts/checksyscalls.sh
> >  CC [M]  arch/powerpc/kvm/book3s_pr.o
> >  LD [M]  arch/powerpc/kvm/kvm.o
> >  Building modules, stage 2.
> >  MODPOST 227 modules
> > ERROR: "__get_user_bad" [arch/powerpc/kvm/kvm.ko] undefined!
>=20
> Ah, because you can't get_user u64s I suppose. Sigh. As a quick hack,
> just comment out the get/put_user lines - you don't care about
> configuring HIOR on ppc32 anyways. I'll try to come up with something
> :)

I've removed these lines and got a kernel. But it crashes:

# modprobe kvm
# qemu-system-ppc -enable-kvm -curses
[  155.982144] BUG: sleeping function called from invalid context at arch/p=
owerpc/kvm/../../../virt/kvm/kvm_main.c:1078
[  155.982552] in_atomic(): 0, irqs_disabled(): 1, pid: 1727, name: qemu-sy=
stem-ppc
[  155.982807] Call Trace:
[  155.982916] [e31ad820] [c000bc44] show_stack+0xbc/0x194 (unreliable)
[  155.983175] [e31ad870] [c047bc2c] dump_stack+0x30/0x38
[  155.983372] [e31ad880] [c0062070] __might_sleep+0xf8/0x100
[  155.983620] [e31ad890] [ea6c1830] hva_to_pfn.isra.41+0xc0/0x340 [kvm]
[  155.983869] [e31ad8d0] [ea6c1b6c] __gfn_to_pfn+0xbc/0xc4 [kvm]
[  155.984110] [e31ad8f0] [ea6c1bec] gfn_to_pfn+0x38/0x40 [kvm]
[  155.984335] [e31ad900] [ea6c9f60] kvmppc_gfn_to_pfn+0xb8/0xc8 [kvm]
[  155.984571] [e31ad920] [ea6ce454] kvmppc_mmu_map_page+0x3c/0x274 [kvm]
[  155.984817] [e31ad970] [ea6cadc4] kvmppc_handle_pagefault+0x264/0x3d0 [k=
vm]
[  155.985083] [e31ad9c0] [ea6cb22c] kvmppc_handle_exit+0x18c/0x800 [kvm]
[  155.985329] [e31ada00] [ea6cd18c] kvmppc_handler_highmem+0x5c/0x6c [kvm]
[  155.985580] [e31adac0] [ea6cbebc] kvmppc_vcpu_run+0x184/0x244 [kvm]
[  155.985817] [e31ade20] [ea6c6170] kvm_arch_vcpu_ioctl_run+0x348/0x374 [k=
vm]
[  155.986080] [e31ade50] [ea6bfc70] kvm_vcpu_ioctl+0x158/0x888 [kvm]
[  155.986308] [e31adea0] [c0129080] do_vfs_ioctl+0x714/0x78c
[  155.986506] [e31adf10] [c0129160] sys_ioctl+0x68/0x8c
[  155.986693] [e31adf40] [c0013b70] ret_from_syscall+0x0/0x38
[  155.986915] --- Exception: c01 at 0xf4eda98
[  155.986921]     LR =3D 0xf4ed9fc
[  155.992590] Page fault in user mode with in_atomic() =3D 1 mm =3D e3021e=
00
[  155.992869] NIP =3D 1017551c  MSR =3D d032
[  155.993273] PowerMac
[  155.993357] Modules linked in: kvm ipv6 fuse option usb_wwan usbserial s=
nd_powermac b43 mac80211 cfg80211 snd_aoa_i2sbus usb_storage snd_pcm_oss sn=
d_mixer_oss snd_pcm snd_page_alloc snd_seq snd_timer snd_seq_d
[  155.994742] NIP: 1017551c LR: 10175514 CTR: 0f5a3420
[  155.994920] REGS: e31adf50 TRAP: 0301   Not tainted  (3.3.0-rc3-04608-ge=
9badff4-dirty)
[  155.995186] MSR: 0000d032 <EE,PR,ME,IR,DR,RI>  CR: 28002464  XER: 200000=
00
[  155.995516] DAR: 48023008, DSISR: 40000000
[  155.995663] TASK =3D e33322b0[1727] 'qemu-system-ppc' THREAD: e31ac000
10175514 48847c60 4884f8e0 10cadd08 48023000 28002464 00000002 0f4eda98=20
0000d032 00000000 00001032 00000001 e31ac000=20
[  155.996535] NIP [1017551c] 0x1017551c
[  155.996668] LR [10175514] 0x10175514
[  155.996793] Call Trace:
[  155.997049]=20
[  156.974149] Kernel panic - not syncing: Fatal exception in interrupt
[  156.974390] Rebooting in 180 seconds..
--=20
Prof: Ist etwas an der Tafel nicht zu lesen? Sie schauen so komisch.
Studentin: Nein, es ist alles in Ordnung.
Prof: Aber ihr Gesicht sieht =C3=BCberhaupt nicht in Ordnung aus.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9LaZUACgkQwe0mZwH1VIARfwCfXfcRYbEDfF1fhXBihApeeoJh
CZAAoLCkCmmYIHfAk7+w28es7iV9p7rl
=mAv5
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
