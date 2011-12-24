Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1LXLP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 06:15:27 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:4889 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab1LXLPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 06:15:22 -0500
Date: Sat, 24 Dec 2011 11:59:51 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20111224105951.GA3938@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111220202711.GD6830@alea.gnuu.de>
 <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alexander Graf hat am Fri 23. Dec, 14:50 (+0100) geschrieben:
> On 20.12.2011, at 21:27, J=F6rg Sommer wrote:
> >  BOOTCC  arch/powerpc/boot/fdt_strerror.o
> >  BOOTAR  arch/powerpc/boot/wrapper.a
> >  WRAP    arch/powerpc/boot/zImage.pmac
> >  WRAP    arch/powerpc/boot/zImage.coff
> > ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
> > make[3]: *** [__modpost] Fehler 1
> > make[2]: *** [modules] Fehler 2
> > make[2]: *** Warte auf noch nicht beendete Prozesse...
> >  WRAP    arch/powerpc/boot/zImage.miboot
> > make[1]: *** [deb-pkg] Fehler 2
> > make: *** [deb-pkg] Fehler 2
>=20
> This is odd. kvmppc_h_pr shouldn't be accessed when not in book3s_64_pr m=
ode:
>=20
> #ifdef CONFIG_KVM_BOOK3S_64_PR
>                         if (kvmppc_h_pr(vcpu, cmd) =3D=3D EMULATE_DONE) {
>                                 r =3D RESUME_GUEST;
>                                 break;
>                         }
> #endif

I had simply reverted the commit a668f2bd3f14ce7f92e119f4b5d9b50cdc59e855
and now, I get these lines:

[  539.183154] BUG: sleeping function called from invalid context at /home/=
joerg/kein_Backup/git/linux/arch/powerpc/include/asm/uaccess.h:438
[  539.183193] in_atomic(): 1, irqs_disabled(): 0, pid: 1889, name: qemu-sy=
stem-ppc
[  539.183205] Call Trace:
[  539.183231] [e33f5e00] [c000bcf4] show_stack+0xbc/0x194 (unreliable)
[  539.183253] [e33f5e50] [c04601cc] dump_stack+0x30/0x38
[  539.183277] [e33f5e60] [c0033edc] __might_sleep+0xf8/0x100
[  539.183302] [e33f5e70] [c0053f70] copy_siginfo_to_user+0x64/0x5ac
[  539.183320] [e33f5e90] [c00547ac] sys_rt_sigtimedwait+0x124/0x168
[  539.183337] [e33f5f40] [c0013c70] ret_from_syscall+0x0/0x38
[  539.183378] --- Exception: c01 at 0xf5bbd34
[  539.183383]     LR =3D 0x1000eea4
[  539.183886] BUG: scheduling while atomic: qemu-system-ppc/1889/0x10000003
[  539.183901] Modules linked in: kvm ipv6 fuse option usb_wwan usbserial s=
nd_powermac b43 mac80211 snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm s=
nd_page_alloc snd_seq cfg80211 firewire_ohci usb_storage sr_mod evdev firew=
ire_core rng_core snd_timer snd_seq_device snd pmac_zilog cdrom crc_itu_t s=
erial_core soundcore ssb snd_aoa_soundbus
[  539.184000] Call Trace:
[  539.184018] [e33f5630] [c000bcf4] show_stack+0xbc/0x194 (unreliable)
[  539.184038] [e33f5680] [c04601cc] dump_stack+0x30/0x38
[  539.184054] [e33f5690] [c0460628] __schedule_bug+0x68/0x70
[  539.184074] [e33f56a0] [c0456af0] __schedule+0x94/0x55c
[  539.184094] [e33f57a0] [c00361b0] __cond_resched+0x34/0x48
[  539.184110] [e33f57b0] [c0457074] _cond_resched+0x48/0x54
[  539.184138] [e33f57c0] [c00e8ce0] __get_user_pages+0x3c8/0x488
[  539.184155] [e33f5830] [c00e8e64] get_user_pages+0x60/0x68
[  539.184181] [e33f5840] [c001b028] get_user_pages_fast+0x144/0x190
[  539.184238] [e33f5890] [ea4458f8] hva_to_pfn.isra.40+0x124/0x344 [kvm]
[  539.184269] [e33f58d0] [ea445bd4] __gfn_to_pfn+0xbc/0xc4 [kvm]
[  539.184298] [e33f58f0] [ea445c54] gfn_to_pfn+0x38/0x40 [kvm]
[  539.184334] [e33f5900] [ea44de78] kvmppc_gfn_to_pfn+0xb8/0xc8 [kvm]
[  539.184363] [e33f5920] [ea4520fc] kvmppc_mmu_map_page+0x3c/0x274 [kvm]
[  539.184393] [e33f5970] [ea44ed28] kvmppc_handle_pagefault+0x264/0x3d0 [k=
vm]
[  539.184423] [e33f59c0] [ea44f254] kvmppc_handle_exit+0x250/0x734 [kvm]
[  539.184452] [e33f5a00] [ea450e5c] kvmppc_handler_highmem+0x5c/0x6c [kvm]
[  539.184481] [e33f5ac0] [ea44fc94] kvmppc_vcpu_run+0x164/0x224 [kvm]
[  539.184511] [e33f5e20] [ea44a1bc] kvm_arch_vcpu_ioctl_run+0x350/0x37c [k=
vm]
[  539.184542] [e33f5e50] [ea4441b4] kvm_vcpu_ioctl+0x158/0xa08 [kvm]
[  539.184565] [e33f5ea0] [c011e508] do_vfs_ioctl+0x730/0x7a8
[  539.184581] [e33f5f10] [c011e5e8] sys_ioctl+0x68/0x8c
[  539.184597] [e33f5f40] [c0013c70] ret_from_syscall+0x0/0x38
[  539.184620] --- Exception: c01 at 0xf668048
[  539.184625]     LR =3D 0xf667fac
[  539.190159] Page fault in user mode with in_atomic() =3D 1 mm =3D e3398c=
40
[  539.192448] NIP =3D 10029af0  MSR =3D d032
[  539.194530] BUG: scheduling while atomic: qemu-system-ppc/1889/0x10000003
[  539.196654] Modules linked in: kvm ipv6 fuse option usb_wwan usbserial s=
nd_powermac b43 mac80211 snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm s=
nd_page_alloc snd_seq cfg80211 firewire_ohci usb_storage sr_mod evdev firew=
ire_core rng_core snd_timer snd_seq_device snd pmac_zilog cdrom crc_itu_t s=
erial_core soundcore ssb snd_aoa_soundbus
[  539.203960] Call Trace:
[  539.205886] [e33f5c00] [c000bcf4] show_stack+0xbc/0x194 (unreliable)
[  539.207936] [e33f5c50] [c04601cc] dump_stack+0x30/0x38
[  539.209939] [e33f5c60] [c0460628] __schedule_bug+0x68/0x70
[  539.211968] [e33f5c70] [c0456af0] __schedule+0x94/0x55c
[  539.214000] [e33f5d70] [c00361b0] __cond_resched+0x34/0x48
[  539.216042] [e33f5d80] [c0457074] _cond_resched+0x48/0x54
[  539.218100] [e33f5d90] [c0458404] mutex_lock+0x3c/0x64
[  539.220162] [e33f5da0] [c000edcc] die+0xb4/0x244
[  539.222161] [e33f5dd0] [c045a1f4] do_page_fault+0x168/0x5e0
[  539.224146] [e33f5f40] [c00140a0] handle_page_fault+0xc/0x80
[  539.226148] --- Exception: 301 at 0x10029af0
[  539.226154]     LR =3D 0x10029ae8
[  539.252137] Oops: Weird page fault, sig: 11 [#1]
[  539.254123] PowerMac
[  539.255945] Modules linked in: kvm ipv6 fuse option usb_wwan usbserial s=
nd_powermac b43 mac80211 snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm s=
nd_page_alloc snd_seq cfg80211 firewire_ohci usb_storage sr_mod evdev firew=
ire_core rng_core snd_timer snd_seq_device snd pmac_zilog cdrom crc_itu_t s=
erial_core soundcore ssb snd_aoa_soundbus
[  539.262919] NIP: 10029af0 LR: 10029ae8 CTR: c00fe560
[  539.264843] REGS: e33f5f50 TRAP: 0301   Not tainted  (3.2.0-rc6-00065-g6=
f39f29)
[  539.266785] MSR: 0000d032 <EE,PR,ME,IR,DR>  CR: 24000464  XER: 00000000
[  539.268894] DAR: 48023008, DSISR: 40000000
[  539.270737] TASK =3D e68cd4a0[1889] 'qemu-system-ppc' THREAD: e33f4000
[  539.270974] GPR00: 10029ae8 bf92ce60 4804ce30 10c7df00 48023000 24000464=
 00000002 0f668048=20
[  539.273129] GPR08: 0000d032 00000000 00001032 e33f5f40 e33f4000=20
[  539.276827] NIP [10029af0] 0x10029af0
[  539.278668] LR [10029ae8] 0x10029ae8
[  539.280446] Call Trace:
[  539.282173] ---[ end trace e4d95fa8275f9d6a ]---
[  539.283945] note: qemu-system-ppc[1889] exited with preempt_count 1
[  539.285754] BUG: scheduling while atomic: qemu-system-ppc/1889/0x10000002
[  539.287576] Modules linked in: kvm ipv6 fuse option usb_wwan usbserial s=
nd_powermac b43 mac80211 snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm s=
nd_page_alloc snd_seq cfg80211 firewire_ohci usb_storage sr_mod evdev firew=
ire_core rng_core snd_timer snd_seq_device snd pmac_zilog cdrom crc_itu_t s=
erial_core soundcore ssb snd_aoa_soundbus
[  539.293830] Call Trace:
[  539.295444] [e33f5b90] [c000bcf4] show_stack+0xbc/0x194 (unreliable)
[  539.297171] [e33f5be0] [c04601cc] dump_stack+0x30/0x38
[  539.298816] [e33f5bf0] [c0460628] __schedule_bug+0x68/0x70
[  539.300450] [e33f5c00] [c0456af0] __schedule+0x94/0x55c
[  539.302053] [e33f5d00] [c00361b0] __cond_resched+0x34/0x48
[  539.303652] [e33f5d10] [c0457074] _cond_resched+0x48/0x54
[  539.305252] [e33f5d20] [c0458854] down_read+0x3c/0x64
[  539.306838] [e33f5d30] [c0081188] acct_collect+0x48/0x17c
[  539.308422] [e33f5d50] [c00429b0] do_exit+0x1ac/0x710
[  539.309994] [e33f5da0] [c000ef50] die+0x238/0x244
[  539.311540] [e33f5dd0] [c045a1f4] do_page_fault+0x168/0x5e0
[  539.313103] [e33f5f40] [c00140a0] handle_page_fault+0xc/0x80
[  539.314670] --- Exception: 301 at 0x10029af0
[  539.314676]     LR =3D 0x10029ae8
[  539.321849] BUG: scheduling while atomic: qemu-system-ppc/1889/0x10000002
[  539.323505] Modules linked in: kvm ipv6 fuse option usb_wwan usbserial s=
nd_powermac b43 mac80211 snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm s=
nd_page_alloc snd_seq cfg80211 firewire_ohci usb_storage sr_mod evdev firew=
ire_core rng_core snd_timer snd_seq_device snd pmac_zilog cdrom crc_itu_t s=
erial_core soundcore ssb snd_aoa_soundbus
[  539.329287] Call Trace:
[  539.330837] [e33f5ac0] [c000bcf4] show_stack+0xbc/0x194 (unreliable)
[  539.332455] [e33f5b10] [c04601cc] dump_stack+0x30/0x38
[  539.334012] [e33f5b20] [c0460628] __schedule_bug+0x68/0x70
[  539.335580] [e33f5b30] [c0456af0] __schedule+0x94/0x55c
[  539.337143] [e33f5c30] [c00361b0] __cond_resched+0x34/0x48
[  539.338700] [e33f5c40] [c0457074] _cond_resched+0x48/0x54
[  539.340234] [e33f5c50] [c0458404] mutex_lock+0x3c/0x64
[  539.341740] [e33f5c60] [c00eb004] unlink_file_vma+0x40/0x60
[  539.343265] [e33f5c80] [c00e5e20] free_pgtables+0x68/0xc0
[  539.344725] [e33f5cb0] [c00ec274] exit_mmap+0x108/0x144
[  539.346192] [e33f5d10] [c003c2bc] mmput+0x68/0x120
[  539.347623] [e33f5d20] [c00427fc] exit_mm+0x144/0x14c
[  539.349067] [e33f5d50] [c00429d4] do_exit+0x1d0/0x710
[  539.350507] [e33f5da0] [c000ef50] die+0x238/0x244
[  539.351934] [e33f5dd0] [c045a1f4] do_page_fault+0x168/0x5e0
[  539.353365] [e33f5f40] [c00140a0] handle_page_fault+0xc/0x80
[  539.354795] --- Exception: 301 at 0x10029af0
[  539.354801]     LR =3D 0x10029ae8
--=20
IRC: Der [Prof. Andreas Pfitzmann, TU Dresden] hat gerade vorgeschlagen, sie
  sollen doch statt Trojanern die elektromagnetische Abstrahlung nutzen. Das
  sei nicht massenf=E4hig, ginge ohne Eingriff ins System, sei zielgerichte=
t,
  und, der Hammer, das funktioniere ja bei Wahlcomputern schon sehr gut.

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk71sKcACgkQwe0mZwH1VICwOgCghAygoyeimV3xYqoEE1CY8Im7
5xoAn3z0Qv+Y+9fooo3pBYwZblq/I0+C
=4k5y
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
