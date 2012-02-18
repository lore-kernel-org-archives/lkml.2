Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2BRRoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 12:44:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39391 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2BRRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 12:44:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of segooon@gmail.com designates 10.204.151.11 as permitted sender) smtp.mail=segooon@gmail.com; dkim=pass header.i=segooon@gmail.com
Date: Sat, 18 Feb 2012 21:39:50 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: =?utf-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] task->nsproxy was unexpectedly NULL (caught in exit_shm)
Message-ID: <20120218173950.GA12595@albatros>
References: <CAN8=baycwqAkTJxNpNzaO9G=TbEXeiEYCvWxiwvS+NpLRZi3xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN8=baycwqAkTJxNpNzaO9G=TbEXeiEYCvWxiwvS+NpLRZi3xw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemysław,

Thank you for the report!

(CC'ed Andrew and Oleg, overquoting for them the whole email)

On Sat, Feb 18, 2012 at 17:57 +0100, Przemysław Pawełczyk wrote:
> Hello.
> 
> Below bug hit me today when I closed one of many tabs in Chrome.
> The kernel is from debian wheezy current kernel package:
> linux-image-3.2.0-1-amd64 (v3.2.4).
> 
> 
> Feb 18 11:28:38 debian kernel: [ 3392.815292] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000010
> Feb 18 11:28:38 debian kernel: [ 3392.815309] IP: [<ffffffff811581c3>]
> exit_shm+0xa/0x54
> Feb 18 11:28:38 debian kernel: [ 3392.815325] PGD 0
> Feb 18 11:28:38 debian kernel: [ 3392.815331] Oops: 0000 [#1] SMP
> Feb 18 11:28:38 debian kernel: [ 3392.815340] CPU 0
> Feb 18 11:28:38 debian kernel: [ 3392.815343] Modules linked in:
> pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) powernow_k8
> mperf cpufreq_stats cpufreq_conservative cpufreq_userspace
> cpufreq_powersave parport_pc ppdev lp parport binfmt_misc nfsd nfs
> lockd fscache auth_rpcgss nfs_acl sunrpc kvm_amd kvm fuse ext2 loop
> snd_hda_codec_hdmi nvidia(P) snd_hda_intel snd_hda_codec snd_intel8x0
> snd_hwdep snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
> snd_seq_device snd k8temp pcspkr edac_core edac_mce_amd soundcore
> evdev snd_page_alloc i2c_nforce2 i2c_core processor button ext3 jbd
> mbcache btrfs zlib_deflate crc32c libcrc32c dm_mirror dm_region_hash
> dm_log dm_mod usbhid hid sr_mod cdrom sd_mod crc_t10dif ohci_hcd
> ata_generic ahci pata_amd libahci pata_jmicron sata_nv thermal fan
> thermal_sys floppy ehci_hcd libata usbcore scsi_mod forcedeth
> usb_common [last unloaded: scs i_wait_scan]
> Feb 18 11:28:38 debian kernel: [ 3392.815476]
> Feb 18 11:28:38 debian kernel: [ 3392.815483] Pid: 3806, comm: chrome
> Tainted: P           O 3.2.0-1-amd64 #1 Unknow Unknow/KN9
> Series(NF-CK804)
> Feb 18 11:28:38 debian kernel: [ 3392.815493] RIP:
> 0010:[<ffffffff811581c3>]  [<ffffffff811581c3>] exit_shm+0xa/0x54
> Feb 18 11:28:38 debian kernel: [ 3392.815504] RSP:
> 0018:ffff88012de61ce8  EFLAGS: 00010292
> Feb 18 11:28:38 debian kernel: [ 3392.815509] RAX: 0000000000000000
> RBX: ffff880130264300 RCX: 0000000000000008
> Feb 18 11:28:38 debian kernel: [ 3392.815515] RDX: ffff88012e3b28c0
> RSI: ffff88010ef96480 RDI: ffff880130264300
> Feb 18 11:28:38 debian kernel: [ 3392.815520] RBP: 000000000000000f
> R08: ffff88012c4a3818 R09: ffff88012c4a38c8
> Feb 18 11:28:38 debian kernel: [ 3392.815526] R10: ffff88012c4a3a28
> R11: ffff88010ef96480 R12: ffff88010ef96480
> Feb 18 11:28:38 debian kernel: [ 3392.815531] R13: ffff88012fc56600
> R14: 0000000000000001 R15: 000000000000413c
> Feb 18 11:28:38 debian kernel: [ 3392.815538] FS:
> 00007f7610f2f700(0000) GS:ffff880137c00000(0000)
> knlGS:0000000000000000
> Feb 18 11:28:38 debian kernel: [ 3392.815544] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Feb 18 11:28:38 debian kernel: [ 3392.815549] CR2: 0000000000000010
> CR3: 000000012e479000 CR4: 00000000000006f0
> Feb 18 11:28:38 debian kernel: [ 3392.815556] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Feb 18 11:28:38 debian kernel: [ 3392.815561] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Feb 18 11:28:38 debian kernel: [ 3392.815568] Process chrome (pid:
> 3806, threadinfo ffff88012de60000, task ffff880131264300)
> Feb 18 11:28:38 debian kernel: [ 3392.815572] Stack:
> Feb 18 11:28:38 debian kernel: [ 3392.815576]  0000000000000000
> ffff880130264300 000000000000000f ffffffff81049af5
> Feb 18 11:28:38 debian kernel: [ 3392.815585]  000000000000192a
> ffff88012de61d08 ffff880131264300 ffffffff817a8508
> Feb 18 11:28:38 debian kernel: [ 3392.815594]  00007f7610f2e000
> ffff88010ef96480 0000000000000944 000000000000000f
> Feb 18 11:28:38 debian kernel: [ 3392.815604] Call Trace:
> Feb 18 11:28:38 debian kernel: [ 3392.815616]  [<ffffffff81049af5>] ?
> do_exit+0x28b/0x732
> Feb 18 11:28:38 debian kernel: [ 3392.815626]  [<ffffffff8104a21c>] ?
> do_group_exit+0x74/0x9e
> Feb 18 11:28:38 debian kernel: [ 3392.815635]  [<ffffffff81055b5b>] ?
> get_signal_to_deliver+0x46d/0x48f
> Feb 18 11:28:38 debian kernel: [ 3392.815644]  [<ffffffff810cff30>] ?
> handle_pte_fault+0x739/0x79f
> Feb 18 11:28:38 debian kernel: [ 3392.815655]  [<ffffffff8100ddd3>] ?
> do_signal+0x38/0x610
> Feb 18 11:28:38 debian kernel: [ 3392.815663]  [<ffffffff81037e98>] ?
> set_next_entity+0x32/0x55
> Feb 18 11:28:38 debian kernel: [ 3392.815672]  [<ffffffff8100d01d>] ?
> paravirt_write_msr+0xb/0xe
> Feb 18 11:28:38 debian kernel: [ 3392.815679]  [<ffffffff8100d694>] ?
> __switch_to+0x138/0x20e
> Feb 18 11:28:38 debian kernel: [ 3392.815690]  [<ffffffff8106f2dc>] ?
> sys_futex+0x138/0x148
> Feb 18 11:28:38 debian kernel: [ 3392.815698]  [<ffffffff8100e3e1>] ?
> do_notify_resume+0x25/0x68
> Feb 18 11:28:38 debian kernel: [ 3392.815707]  [<ffffffff813459e0>] ?
> int_signal+0x12/0x17
> Feb 18 11:28:38 debian kernel: [ 3392.815713] Code: 48 8d bd c0 00 00
> 00 48 89 ea 48 c7 c6 b8 7e 15 81 e8 e9 f6 04 00 48 89 df 5b 5b 5d e9
> e9 a7 f0 ff 55 53 50 48 8b 87 78 04 00 00 <48> 8b 68 10 83 bd 98 00 00
> 00 00 74 39 48 8d 9d a0 00 00 00 48
> Feb 18 11:28:38 debian kernel: [ 3392.815783] RIP
> [<ffffffff811581c3>] exit_shm+0xa/0x54
> Feb 18 11:28:38 debian kernel: [ 3392.815792]  RSP <ffff88012de61ce8>
> Feb 18 11:28:38 debian kernel: [ 3392.815795] CR2: 0000000000000010
> Feb 18 11:28:38 debian kernel: [ 3392.815801] ---[ end trace
> 1bd7e5ff0e6f1b66 ]---
> Feb 18 11:28:38 debian kernel: [ 3392.815807] Fixing recursive fault
> but reboot is needed!
> 
> 
> Relevant code:
> 
> 
>         void exit_shm(struct task_struct *task)
> 
> 311     {
>    0xffffffff811581b9 <+0>:     55                      push   %rbp
>    0xffffffff811581ba <+1>:     53                      push   %rbx
>    0xffffffff811581bb <+2>:     50                      push   %rax
> 
> 312             struct ipc_namespace *ns = task->nsproxy->ipc_ns;
>    0xffffffff811581bc <+3>:     48 8b 87 78 04 00 00    mov
> 0x478(%rdi),%rax  /* task->nsproxy */
>    0xffffffff811581c3 <+10>:    48 8b 68 10             mov
> 0x10(%rax),%rbp   /*     ->ipc_ns  */
> 
> 313
> 314             if (shm_ids(ns).in_use == 0)
>    0xffffffff811581c7 <+14>:    83 bd 98 00 00 00 00    cmpl   $0x0,0x98(%rbp)
>    0xffffffff811581ce <+21>:    74 39                   je
> 0xffffffff81158209 <exit_shm+80>
> 
> 315                     return;
> 316
> 317             /* Destroy all already created segments, but not mapped yet */
> 318             down_write(&shm_ids(ns).rw_mutex);
>    0xffffffff811581d0 <+23>:    48 8d 9d a0 00 00 00    lea    0xa0(%rbp),%rbx
>    0xffffffff811581d7 <+30>:    48 89 df                mov    %rbx,%rdi
>    0xffffffff811581da <+33>:    e8 08 7e 1e 00          callq
> 0xffffffff8133ffe7 <down_write>
> ...
> 
> 
> So task->nsproxy was unexpectedly NULL atm.
> The bug happened only once so far.

I'm confused.  How ->nsproxy can be NULL in do_exit()?  AFAIU, it is not a
special process (i.e. init or udev), but a common chrome process.

Could it be missing get_nsproxy() somewhere?  And as a result, freed
current->nsproxy while still having active users.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
