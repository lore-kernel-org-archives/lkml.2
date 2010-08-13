Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab0HMNtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:49:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44239 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab0HMNtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=neI4NC5NxRvfZ+Nd6vLspM5LRWtaa2RdTS0urepb+JFjW7HG31fn6GOM437o7iqcHn
         oHR5uhisf4OxSproJvyyQxLZvbIk4Np37VNapwj2bi3nXmh+FNDx9b+OvsMGnZE68hsP
         YWUOyY/vOIYBZ65p4oWouSD+p8D/5dPIo+gLg=
Date: Fri, 13 Aug 2010 16:49:47 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel paging request at ffffffffffffffff
Message-ID: <20100813134947.GB5235@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

yet another trace:

[ 5845.374558] CPU 1 is now offline
[ 5845.376169] INFO: trying to register non-static key.
[ 5845.376251] the code is fine but needs lockdep annotation.
[ 5845.376327] turning off the locking correctness validator.
[ 5845.376405] Pid: 6754, comm: bash Not tainted 2.6.36-rc0-git12-07921-g60=
bf26a-dirty #122
[ 5845.376521] Call Trace:
[ 5845.376570]  [<ffffffff81063e89>] __lock_acquire+0x2d1/0x17fd
[ 5845.376657]  [<ffffffff81132b2a>] ? sysfs_deactivate+0x3e/0xec
[ 5845.376747]  [<ffffffff81062ddd>] ? mark_held_locks+0x50/0x72
[ 5845.376834]  [<ffffffff81065893>] lock_acquire+0x97/0xb6
[ 5845.376917]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0x3e/=
0x93
[ 5845.377021]  [<ffffffff81374321>] ? mutex_lock_nested+0x2f3/0x31b
[ 5845.377113]  [<ffffffff81371446>] ? percpu_counter_hotcpu_callback+0x29/=
0x93
[ 5845.377218]  [<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x60
[ 5845.377312]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0x3e/=
0x93
[ 5845.377409]  [<ffffffff8137145b>] percpu_counter_hotcpu_callback+0x3e/0x=
93
[ 5845.377475]  [<ffffffff81057344>] notifier_call_chain+0x32/0x5e
[ 5845.377529]  [<ffffffff8105738f>] __raw_notifier_call_chain+0x9/0xb
[ 5845.377587]  [<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
[ 5845.377638]  [<ffffffff8103c703>] cpu_notify+0xe/0x10
[ 5845.377684]  [<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
[ 5845.377738]  [<ffffffff81362d82>] _cpu_down+0x151/0x206
[ 5845.377786]  [<ffffffff81362ea8>] cpu_down+0x28/0x35
[ 5845.377833]  [<ffffffff8136430d>] store_online+0x27/0x6e
[ 5845.377884]  [<ffffffff812923ab>] sysdev_store+0x1b/0x1d
[ 5845.377933]  [<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
[ 5845.377990]  [<ffffffff810daf92>] vfs_write+0xb0/0x14f
[ 5845.378038]  [<ffffffff810db22e>] sys_write+0x45/0x6c
[ 5845.378088]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[ 5845.378166] BUG: unable to handle kernel paging request at fffffffffffff=
fff
[ 5845.378236] IP: [<ffffffff81371487>] percpu_counter_hotcpu_callback+0x6a=
/0x93
[ 5845.378306] PGD 162f067 PUD 1630067 PMD 0=20
[ 5845.378362] Oops: 0000 [#1] PREEMPT SMP=20
[ 5845.378421] last sysfs file: /sys/devices/system/cpu/cpu1/online
[ 5845.378476] CPU 2=20
[ 5845.378497] Modules linked in: ipv6 snd_hda_codec_atihdmi snd_hwdep snd_=
seq_dummy battery ac snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device =
wmi button snd_hda_codec_realtek snd_pcm_oss snd_mixer_oss snd_hda_intel us=
b_storage
snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc psmouse serio_=
raw broadcom usbhid hid tg3 libphy evdev radeon ttm drm_kms_helper ehci_hcd=
 sr_mod usbcore cdrom sd_mod ahci libahci
[ 5845.379032]=20
[ 5845.379053] Pid: 6754, comm: bash Not tainted 2.6.36-rc0-git12-07921-g60=
bf26a-dirty #122 Aspire 5741G    /Aspire 5741G   =20
[ 5845.379146] RIP: 0010:[<ffffffff81371487>]  [<ffffffff81371487>] percpu_=
counter_hotcpu_callback+0x6a/0x93
[ 5845.379235] RSP: 0018:ffff880156bf9d68  EFLAGS: 00010282
[ 5845.379283] RAX: 0000000100000000 RBX: ffffffffffffffc7 RCX: 00000000000=
00282
[ 5845.379345] RDX: 0000000000000100 RSI: ffffffff81554abe RDI: ffffffff813=
7147f
[ 5845.379406] RBP: ffff880156bf9d78 R08: ffffffff81656a70 R09: ffffffff817=
31085
[ 5845.379466] R10: 0000000000000003 R11: ffff880157da7700 R12: 00000000000=
00001
[ 5845.379527] R13: 00000000ffffffe0 R14: ffffffff81656a70 R15: 00000000000=
00001
[ 5845.379589] FS:  00007fef586d3700(0000) GS:ffff880002280000(0000) knlGS:=
0000000000000000
[ 5845.379659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5845.381688] CR2: ffffffffffffffff CR3: 00000001551a1000 CR4: 00000000000=
006e0
[ 5845.383723] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 5845.386080] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 5845.388123] Process bash (pid: 6754, threadinfo ffff880156bf8000, task f=
fff8801569fbf60)
[ 5845.390158] Stack:
[ 5845.392176]  0000000000000001 0000000000000007 ffff880156bf9db8 ffffffff=
81057344
[ 5845.392253] <0> ffff880156bf9db8 0000000000000000 ffffffff81635020 00000=
00000000001
[ 5845.394370] <0> 0000000000000000 0000000000000000 ffff880156bf9dc8 fffff=
fff8105738f
[ 5845.398550] Call Trace:
[ 5845.400655]  [<ffffffff81057344>] notifier_call_chain+0x32/0x5e
[ 5845.402776]  [<ffffffff8105738f>] __raw_notifier_call_chain+0x9/0xb
[ 5845.405108]  [<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
[ 5845.407235]  [<ffffffff8103c703>] cpu_notify+0xe/0x10
[ 5845.409375]  [<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
[ 5845.411477]  [<ffffffff81362d82>] _cpu_down+0x151/0x206
[ 5845.413553]  [<ffffffff81362ea8>] cpu_down+0x28/0x35
[ 5845.415637]  [<ffffffff8136430d>] store_online+0x27/0x6e
[ 5845.417716]  [<ffffffff812923ab>] sysdev_store+0x1b/0x1d
[ 5845.419790]  [<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
[ 5845.421888]  [<ffffffff810daf92>] vfs_write+0xb0/0x14f
[ 5845.423984]  [<ffffffff810db22e>] sys_write+0x45/0x6c
[ 5845.426096]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[ 5845.428360] Code: 8b 53 48 48 89 df 48 89 c6 4a 03 14 e5 d0 9b 67 81 48 =
63 0a 48 01 4b 30 c7 02 00 00 00 00 e8 35 49 00 00 48 8b 5b 38 48 83 eb 38 =
<48> 8b 43 38 0f 18 08 48 8d 43 38 48 3d 60 1e 65 81 75 b9 48 c7=20
[ 5845.434413] RIP  [<ffffffff81371487>] percpu_counter_hotcpu_callback+0x6=
a/0x93
[ 5845.436882]  RSP <ffff880156bf9d68>
[ 5845.439310] CR2: ffffffffffffffff
[ 5845.451743] ---[ end trace f5dfc3cdb422158a ]---



	Sergey

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxlTXsACgkQfKHnntdSXjS94QP+K3LjZcaSkuXHYZo8Vt09WR58
Y1xwmyH1Se3C9CuCBqVOQ6QIe+V0Lkt4aslnyLKTNKV+crPt6dhBpY/YMk0gmgBK
PONa2dYa4+cLA6yA+DJ/CGNmeXknAXkjNNIC0AD2h3JDZWqEjMXdwQ6Eb7NIGmkT
9bZ22z4kj+TjEuc2aHU=
=jSCZ
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
