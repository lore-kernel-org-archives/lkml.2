Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0HSJyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:54:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41061 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0HSJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MNH/MYNAriEsI+3CgVWXp/C8yEugO3DEaRmlRHMOLoEWQuwFbKdEU/3yOS3V0mlalX
         GjAaVXvI7Y4kkxsKPuYKGulFPmJoZh0x38150xSavYalkUfJNLHALFJyzVLLU5lvZnlo
         CkHZtGJcpF2bhyblbseLs3urSVQ9MwPR70q+U=
Date: Thu, 19 Aug 2010 12:54:29 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
Message-ID: <20100819095429.GA5201@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Got this trace (while echo 1 > /sys/devices/system/cpu/cpu3/online):

[  313.320295] lockdep: fixing up alternatives.
[  313.320303] SMP alternatives: switching to SMP code
[  313.331090] Booting Node 0 Processor 3 APIC 0x5
[  313.487258] kvm: enabling virtualization on CPU3
[  313.487326] NMI watchdog enabled, takes one hw-pmu counter.
[  313.489627] coretemp coretemp.3: TjMax is 105 C.
[  315.344223] lockdep: fixing up alternatives.
[  315.344236] Booting Node 0 Processor 2 APIC 0x4
[  315.487292] ------------[ cut here ]------------
[  315.487322] kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978!
[  315.487352] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  315.487388] last sysfs file: /sys/devices/system/cpu/cpu2/online
[  315.487415] CPU 2=20
[  315.487425] Modules linked in: kvm_intel kvm ipv6 snd_seq_dummy ac batte=
ry snd_seq_oss snd_seq_midi_event snd_hwdep snd_seq snd_seq_device wmi usbh=
id hid snd_hda_codec_atihdmi radeon button snd_hda_codec_realtek snd_pcm_oss
snd_mixer_oss snd_hda_intel snd_hda_codec snd_pcm snd_timer snd soundcore s=
nd_page_alloc broadcom tg3 libphy psmouse serio_raw evdev ttm drm_kms_helpe=
r ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci
[  315.487728]=20
[  315.487739] Pid: 27687, comm: qemu-kvm Not tainted 2.6.36-rc1-dbg-git2-0=
0264-gd5a1964-dirty #134 Aspire 5741G    /Aspire 5741G   =20
[  315.487787] RIP: 0010:[<ffffffffa02f2446>]  [<ffffffffa02f2446>] kvm_han=
dle_fault_on_reboot+0xf/0x11 [kvm]
[  315.487839] RSP: 0000:ffff88013c333b18  EFLAGS: 00010246
[  315.487863] RAX: ffff88013c333b40 RBX: ffff88012dcb0000 RCX: ffff88010c7=
e9000
[  315.487893] RDX: ffff880002280000 RSI: ffff8801563e8728 RDI: ffff88010c7=
e9000
[  315.487922] RBP: ffff88013c333b18 R08: ffff880002213cd0 R09: 00000000000=
003c7
[  315.487952] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00002
[  315.487982] R13: ffff88010c7e9000 R14: ffff8801563e8000 R15: 00000000000=
00000
[  315.488012] FS:  00007f15014be710(0000) GS:ffff880002280000(0000) knlGS:=
0000000000000000
[  315.488046] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  315.488070] CR2: 0000000000000000 CR3: 0000000154b42000 CR4: 00000000000=
006e0
[  315.488100] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  315.488130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  315.488160] Process qemu-kvm (pid: 27687, threadinfo ffff88013c332000, t=
ask ffff8801563e8000)
[  315.488194] Stack:
[  315.488205]  ffff88013c333b68 ffffffffa026d0a2 ffff88013c333b58 ffffffff=
81062e91
[  315.488244] <0> ffff8801563e8000 000000010c7e9000 ffff880157d78000 ffff8=
8012dcb0000
[  315.488290] <0> 0000000000000002 0000000000014240 ffff88013c333b98 fffff=
fffa02fb4cc
[  315.488337] Call Trace:
[  315.488353]  [<ffffffffa026d0a2>] vmx_vcpu_load+0x90/0x1a0 [kvm_intel]
[  315.488384]  [<ffffffff81062e91>] ? mark_held_locks+0x50/0x72
[  315.488415]  [<ffffffffa02fb4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[  315.488446]  [<ffffffffa02f2cd8>] kvm_sched_in+0xd/0xf [kvm]
[  315.488474]  [<ffffffff8102de1f>] finish_task_switch+0x90/0xd7
[  315.488500]  [<ffffffff8102dd8f>] ? finish_task_switch+0x0/0xd7
[  315.488529]  [<ffffffff81373381>] schedule+0x81d/0x8f2
[  315.488553]  [<ffffffff81062e91>] ? mark_held_locks+0x50/0x72
[  315.488584]  [<ffffffffa030d82c>] ? kvm_cpu_has_interrupt+0x3a/0x56 [kvm]
[  315.488617]  [<ffffffffa02f5057>] kvm_vcpu_block+0x8e/0xa9 [kvm]
[  315.488645]  [<ffffffff81052dbd>] ? autoremove_wake_function+0x0/0x34
[  315.488678]  [<ffffffffa030024d>] kvm_arch_vcpu_ioctl_run+0x97d/0xca0 [k=
vm]
[  315.488712]  [<ffffffffa030016a>] ? kvm_arch_vcpu_ioctl_run+0x89a/0xca0 =
[kvm]
[  315.488743]  [<ffffffff813747d1>] ? mutex_lock_nested+0x2f3/0x31b
[  315.488771]  [<ffffffff8103441b>] ? sub_preempt_count+0x92/0xa5
[  315.488800]  [<ffffffffa02f4164>] kvm_vcpu_ioctl+0x113/0x4e9 [kvm]
[  315.488829]  [<ffffffff81376247>] ? _raw_spin_unlock_irq+0x3c/0x59
[  315.488859]  [<ffffffff810e8d5b>] do_vfs_ioctl+0x4c1/0x502
[  315.488885]  [<ffffffff810dc496>] ? fget_light+0xe0/0xf8
[  315.488909]  [<ffffffff810dc408>] ? fget_light+0x52/0xf8
[  315.490162]  [<ffffffff810e8ded>] sys_ioctl+0x51/0x74
[  315.491403]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[  315.492649] Code: 2f 02 00 85 c0 75 13 ba 01 00 00 00 31 f6 48 c7 c7 bb =
27 2f a0 e8 6a db d4 e0 c9 c3 55 80 3d 59 2f 02 00 00 48 89 e5 74 02 eb fe =
<0f> 0b 55 48 89 e5 53 48 89 f3 48 83 ec 08 48 8b 87 90 00 00 00=20
[  315.495975] RIP  [<ffffffffa02f2446>] kvm_handle_fault_on_reboot+0xf/0x1=
1 [kvm]
[  315.498317]  RSP <ffff88013c333b18>
[  315.510526] ---[ end trace ac38cfaaa84a0bdf ]---
[  315.510763] kvm: enabling virtualization on CPU2
[  315.513518] note: qemu-kvm[27687] exited with preempt_count 1
[  315.514858] NMI watchdog enabled, takes one hw-pmu counter.



	Sergey

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxs/1UACgkQfKHnntdSXjTadgQAyZx0Mw6zZ1hNHH4jzRUFOz3H
cDCCtahshgngyKwX6o9jy3MYZlltzYaj73BXcTHi8E1EA02pm0gojyEzfDF4sBAT
r3OcuOvw+wA1Nk9dCOeQCgm4FaVp3sGqwvrD/vyJsyJ63xdF6UOulC95I94BL3q3
+wraHQ2qPEnKVkF3Gh8=
=+JCO
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
