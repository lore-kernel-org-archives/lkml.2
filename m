Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1K3Olx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:41:53 -0500
Received: from out.selfhost.de ([82.98.82.95]:36470 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756708Ab1K3Ols (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:41:48 -0500
Message-ID: <4ED640A8.5010707@afaics.de>
Date: Wed, 30 Nov 2011 15:41:44 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.1.4: null pointer dereference on usb disconnect
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I got this on pulling out an usb stick:

Nov 30 15:34:43 cecil kernel: [18443.732421] usb 4-1.3.1.4: USB disconnect, device number 10
Nov 30 15:34:43 cecil kernel: [18443.732812] scsi: killing requests for dead queue
Nov 30 15:34:43 cecil kernel: [18443.732941] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
Nov 30 15:34:43 cecil kernel: [18443.732947] IP: [<ffffffffa00a9974>] sd_revalidate_disk+0x23/0x1676 [sd_mod]
Nov 30 15:34:43 cecil kernel: [18443.732957] PGD 1f7441067 PUD 10596c067 PMD 0
Nov 30 15:34:43 cecil kernel: [18443.732962] Oops: 0000 [#1] PREEMPT SMP
Nov 30 15:34:43 cecil kernel: [18443.732966] CPU 0
Nov 30 15:34:43 cecil kernel: [18443.732967] Modules linked in: vboxpci vboxnetadp vboxnetflt vboxdrv bnep rfcomm bluetooth rfkill ip6table_filter ip6_tables iptable_filter ip_tables x_tables acpi_cpufreq mperf cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave autofs4 uinput
fuse nfsd nfs lockd auth_rpcgss nfs_acl sunrpc bridge ipv6 stp llc dm_crypt coretemp tcp_cubic tcp_htcp loop kvm_intel kvm snd_hda_codec_hdmi nvidia(P) snd_hda_codec_via snd_seq_dummy snd_hda_intel snd_seq_oss snd_hda_codec snd_seq_midi snd_pcm_oss snd_rawmidi snd_mixer_oss evdev snd_seq_midi_event
snd_pcm snd_seq psmouse snd_timer snd_seq_device i2c_i801 intel_agp pcspkr i2c_core intel_gtt snd serio_raw agpgart soundcore snd_page_alloc rtc_cmos video wmi processor button ext4 mbcache jbd2 crc16 btrfs crc32c libcrc32c dm_mod sr_mod cdrom sd_mod usbhid usb_storage uas ahci libahci libata
xhci_hcd r8169 mii ehci_hcd usbcore [last unloaded: evbug]
Nov 30 15:34:43 cecil kernel: [18443.733038]
Nov 30 15:34:43 cecil kernel: [18443.733041] Pid: 21439, comm: udisks-daemon Tainted: P            3.1.4 #1 System manufacturer System Product Name/P8H67-I
Nov 30 15:34:43 cecil kernel: [18443.733048] RIP: 0010:[<ffffffffa00a9974>]  [<ffffffffa00a9974>] sd_revalidate_disk+0x23/0x1676 [sd_mod]
Nov 30 15:34:43 cecil kernel: [18443.733059] RSP: 0018:ffff8801a6e05b08  EFLAGS: 00010246
Nov 30 15:34:43 cecil kernel: [18443.733062] RAX: 0000000000000000 RBX: ffff8801f11968c0 RCX: 0000000000000003
Nov 30 15:34:43 cecil kernel: [18443.733066] RDX: 0000000000000003 RSI: ffff8800441d15c0 RDI: ffff8801046e8000
Nov 30 15:34:43 cecil kernel: [18443.733069] RBP: 0000000000000000 R08: 00000008ffffffff R09: 0000000000000006
Nov 30 15:34:43 cecil kernel: [18443.733073] R10: dead000000100100 R11: dead000000100100 R12: ffff8801046e8000
Nov 30 15:34:43 cecil kernel: [18443.733077] R13: 000000000000001d R14: 0000000000000000 R15: ffff8801f11968c0
Nov 30 15:34:43 cecil kernel: [18443.733082] FS:  00007f56151387a0(0000) GS:ffff88021f400000(0000) knlGS:0000000000000000
Nov 30 15:34:43 cecil kernel: [18443.733086] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 30 15:34:43 cecil kernel: [18443.733089] CR2: 0000000000000008 CR3: 00000001f7440000 CR4: 00000000000406f0
Nov 30 15:34:43 cecil kernel: [18443.733093] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 30 15:34:43 cecil kernel: [18443.733096] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 30 15:34:43 cecil kernel: [18443.733101] Process udisks-daemon (pid: 21439, threadinfo ffff8801a6e04000, task ffff88020fddca30)
Nov 30 15:34:43 cecil kernel: [18443.733104] Stack:
Nov 30 15:34:43 cecil kernel: [18443.733107]  ffff880078fd5870 ffff8801046e8048 0000000000000000 ffff8801046e8000
Nov 30 15:34:43 cecil kernel: [18443.733114]  000000000000001d ffff8801f11968d8 ffff8801f11968c0 ffffffff810b9e7e
Nov 30 15:34:43 cecil kernel: [18443.733122]  ffff8801f11968c0 ffff8801046e8000 ffff8801a6e05b54 ffff8801f1196998
Nov 30 15:34:43 cecil kernel: [18443.733129] Call Trace:
Nov 30 15:34:43 cecil kernel: [18443.733138]  [<ffffffff810b9e7e>] ? get_super+0x9d/0xa5
Nov 30 15:34:43 cecil kernel: [18443.733144]  [<ffffffff810cb9f4>] ? iput+0x2e/0x1a0
Nov 30 15:34:43 cecil kernel: [18443.733150]  [<ffffffff811035a1>] ? rescan_partitions+0xac/0x43b
Nov 30 15:34:43 cecil kernel: [18443.733157]  [<ffffffff810de71e>] ? __blkdev_get+0x1a6/0x37e
Nov 30 15:34:43 cecil kernel: [18443.733167]  [<ffffffff810debb0>] ? blkdev_get+0x2ba/0x2ba
Nov 30 15:34:43 cecil kernel: [18443.733171]  [<ffffffff810deac6>] ? blkdev_get+0x1d0/0x2ba
Nov 30 15:34:43 cecil kernel: [18443.733176]  [<ffffffff810debb0>] ? blkdev_get+0x2ba/0x2ba
Nov 30 15:34:43 cecil kernel: [18443.733181]  [<ffffffff810b7048>] ? __dentry_open.isra.16+0x182/0x2ab
Nov 30 15:34:43 cecil kernel: [18443.733185]  [<ffffffff810c021d>] ? path_get+0x23/0x35
Nov 30 15:34:43 cecil kernel: [18443.733189]  [<ffffffff810c3b00>] ? do_last.isra.42+0x54f/0x67f
Nov 30 15:34:43 cecil kernel: [18443.733193]  [<ffffffff810c3dfc>] ? path_openat+0xce/0x35f
Nov 30 15:34:43 cecil kernel: [18443.733198]  [<ffffffff810c4156>] ? do_filp_open+0x2a/0x6e
Nov 30 15:34:43 cecil kernel: [18443.733202]  [<ffffffff810cd6a0>] ? alloc_fd+0x109/0x11b
Nov 30 15:34:43 cecil kernel: [18443.733206]  [<ffffffff810b7cf2>] ? do_sys_open+0xf7/0x185
Nov 30 15:34:43 cecil kernel: [18443.733211]  [<ffffffff812b0ebb>] ? system_call_fastpath+0x16/0x1b
Nov 30 15:34:43 cecil kernel: [18443.733214] Code: 5c 41 5d 41 5e 41 5f c3 41 57 41 56 41 55 41 54 55 53 48 83 ec 78 8b 05 cb 53 56 e1 48 8b af 48 02 00 00 48 89 7c 24 48 c1 e8 15 <4c> 8b 7d 08 83 e0 07 83 f8 03 76 43 48 8b 8d 98 01 00 00 49 8d
Nov 30 15:34:43 cecil kernel: [18443.733249] RIP  [<ffffffffa00a9974>] sd_revalidate_disk+0x23/0x1676 [sd_mod]
Nov 30 15:34:43 cecil kernel: [18443.733256]  RSP <ffff8801a6e05b08>
Nov 30 15:34:43 cecil kernel: [18443.733258] CR2: 0000000000000008
Nov 30 15:34:43 cecil kernel: [18443.733261] ---[ end trace 41773c9a47f571ed ]---
Nov 30 15:34:43 cecil kernel: [18443.734180] udisks-daemon[21436] trap int3 ip:7f5613c4e888 sp:7fff942361d0 error:0


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7WQKgACgkQUTlbRTxpHjcoAACggMvEuvLetqQof+9al2qCDuvy
xh8AnjI8L1WVgHC6//FJ4Hms6HzD6A3Z
=+cos
-----END PGP SIGNATURE-----
