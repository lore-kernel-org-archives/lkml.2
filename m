Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0FGBDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:03:06 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37989 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0FGBDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DwDZhMLez81O+MDnwOoV0H7zc3NDn/bU/wMw+bpCqwgyGD/Djzgay4a2ExGYO8w4Ln
         uiiNjyppp6jz2eTyaU2QhUSocS5zWKdirSXmle8QrcnXhRfldtjwONkGOp/SEpCTOPyD
         h/eAVxkFsT3gpl0jKrCUuAd9rdRHN0wt/M6wc=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
	<AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
Date: Mon, 7 Jun 2010 03:03:00 +0200
Message-ID: <AANLkTimKd7uartwGVr1L1UN_FvC0TONmwXJlwXa4Ee7T@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 6:25 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Sun, Jun 6, 2010 at 5:52 PM, Tejun Heo <htejun@gmail.com> wrote:
>> On 06/06/2010 05:48 PM, Tejun Heo wrote:
>>> Can you please try w/o KMS just in case?
>
> 2 out of 2 attempts without KMS worked without any OOPS.
> Sorry to have bother you with this, it now really looks KMS related.
>
>> Also, does it always crash the same way?
>
> It seemed so, both attempts with KMS crashed the same way.
>
> Could you suggest a KConfig option, that might catch the culprit?
> DEBUG_PAGEALLOC or DEBUG_OBJECTS?
>
> Torsten
>
> Just for reference, here is the other crash with KMS:
> [   82.500052] general protection fault: 0000 [#1] SMP
> [   82.505057] last sysfs file: /sys/devices/virtual/block/md3/uevent
> [   82.510007] CPU 0
> [   82.510007] Modules linked in: sg
> [   82.510007]
> [   82.510007] Pid: 335, comm: kblockd/0 Not tainted 2.6.35-rc2 #1
> KFN5-D SLI/KFN5-D SLI
> [   82.510007] RIP: 0010:[<ffffffff8135aa64>]  [<ffffffff8135aa64>]
> ata_find_dev+0x24/0x90
> [   82.510007] RSP: 0018:ffff88007f40bda0  EFLAGS: 00010082
> [   82.510007] RAX: 0720072007200720 RBX: ffff88011f307c00 RCX: 0720072007202558
> [   82.510007] RDX: ffff8800070d1e38 RSI: 0000000000000000 RDI: ffff8800070d0000
> [   82.510007] RBP: ffff880006c1c300 R08: 0000000000000001 R09: 0000000000000010
> [   82.510007] R10: 0000000000000000 R11: ffff880007246c68 R12: ffff88011f30c000
> [   82.510007] R13: ffff8800070d0000 R14: ffffffff81340f80 R15: ffff88011f307d38
> [   82.510007] FS:  00007f97bcf66700(0000) GS:ffff880001c00000(0000)
> knlGS:0000000000000000
> [   82.510007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   82.510007] CR2: 00007f97bbe18900 CR3: 0000000001a05000 CR4: 00000000000006f0
> [   82.510007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   82.510007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   82.510007] Process kblockd/0 (pid: 335, threadinfo
> ffff88007f40a000, task ffff88007ff9a7d0)
> [   82.510007] Stack:
> [   82.510007]  ffffffff8135ab25 ffffffff8135e7cb ffff880006c1c300
> ffff88011f30c000
> [   82.510007] <0> ffff880007246b88 0000000000000287 ffff88011f307c48
> ffffffff81341c49
> [   82.510007] <0> ffff880007246b88 ffff88011f307c00 ffff88011f3a0888
> ffff880007246b88
> [   82.510007] Call Trace:
> [   82.510007]  [<ffffffff8135ab25>] ? ata_scsi_find_dev+0x5/0x30
> [   82.510007]  [<ffffffff8135e7cb>] ? ata_scsi_queuecmd+0x4b/0x2c0
> [   82.510007]  [<ffffffff81341c49>] ? scsi_dispatch_cmd+0xd9/0x210
> [   82.510007]  [<ffffffff81348530>] ? scsi_request_fn+0x300/0x3e0
> [   82.510007]  [<ffffffff811e31e0>] ? blk_unplug_work+0x0/0x20
> [   82.510007]  [<ffffffff811e4624>] ? generic_unplug_device+0x24/0x30
> [   82.510007]  [<ffffffff8104ca6b>] ? worker_thread+0xeb/0x180
> [   82.510007]  [<ffffffff81050690>] ? autoremove_wake_function+0x0/0x30
> [   82.510007]  [<ffffffff8104c980>] ? worker_thread+0x0/0x180
> [   82.510007]  [<ffffffff810501fe>] ? kthread+0x8e/0xa0
> [   82.510007]  [<ffffffff81003194>] ? kernel_thread_helper+0x4/0x10
> [   82.510007]  [<ffffffff81050170>] ? kthread+0x0/0xa0
> [   82.510007]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
> [   82.510007] Code: 1f 84 00 00 00 00 00 8b 87 00 29 00 00 85 c0 75 46 48
> 8b 87 38 1e 00 00 48 8d 97 38 1e 00 00 48 8d 88 38 1e 00 00 48 39 ca 74 4c
> <48> 3b 90 f8 28 00 00 74 43 ba 01 00 00 00 39 d6 7d 47 48 63 f6
> [   82.510007] RIP  [<ffffffff8135aa64>] ata_find_dev+0x24/0x90
> [   82.510007]  RSP <ffff88007f40bda0>
> [   82.510007] ---[ end trace 63f75d1cde008d47 ]---

With -rc2 on F13, x86_64, Dell E6400 I had X not showing
 on "startx" at the first attempt (totally blank screen), with
 the oops pasted below found after Alt-Fn'ing into another
 console tty and logging in.

startx worked on 2nd attempt, and I was able to work for
 a while (at least 15 minutes), then on exiting the Gnome
 session the laptop locked up hard (CapsLock did not
 change LED upon press), and I could only keep power
 button pressed to turn the computer off.

[root@duff linux-2.6.35-rc2]# grep KMS .config
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_I915_KMS=y

-rc1-git2 and earlier have had no such issue.

The "taint" P flag is due to the broadcom-sta driver that
 I compiled for my BCM4322 wireless chip (and have for
 the last several dozens of kernels).

Jun  6 23:53:50 duff ntpd[2870]: Listen normally on 5 eth1 192.168.1.8 UDP 123
Jun  6 23:53:53 duff kernel: general protection fault: 0000 [#1] SMP
Jun  6 23:53:53 duff kernel: last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/voltage_now
Jun  6 23:53:53 duff kernel: CPU 0
Jun  6 23:53:53 duff kernel: Modules linked in: lib80211_crypt_tkip
wl(P) cfg80211 lib80211 tun rfcomm sco bridge stp llc bnep l2cap
sunrpc cpufreq_ondemand iptable_filter ip_tables ip6table_filter
ip6_tables ipv6 snd_hda_codec_intelhdmi snd_hda_codec_idt btusb
bluetooth snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
snd_pcm snd_timer snd soundcore snd_page_alloc dell_laptop sdhci_pci
rfkill sdhci mmc_core microcode pcspkr i2c_i801 dcdbas ac battery
joydev ext4 jbd2 crc16 firewire_ohci firewire_core crc_itu_t i915
drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
scsi_wait_scan]
Jun  6 23:53:53 duff kernel:
Jun  6 23:53:53 duff kernel: Pid: 3618, comm: gnome-session Tainted: P
           2.6.35-rc2 #1 0HT027/Latitude E6400
Jun  6 23:53:53 duff kernel: RIP: 0010:[<ffffffff8136b4a5>]
[<ffffffff8136b4a5>] _raw_spin_lock_irqsave+0x18/0x2f
Jun  6 23:53:53 duff kernel: RSP: 0018:ffff88011f665a98  EFLAGS: 00010046
Jun  6 23:53:53 duff kernel: RAX: 0000000000000019 RBX:
0e200e200e200e20 RCX: ffff88011e1c2090
Jun  6 23:53:53 duff kernel: RDX: 0000000000000100 RSI:
ffff88011e1c2060 RDI: 0e200e200e200e20
Jun  6 23:53:53 duff kernel: RBP: ffff88011f665aa8 R08:
0000000000000002 R09: dead000000100100
Jun  6 23:53:53 duff kernel: R10: 000000000000013e R11:
000000000000fa6a R12: 0000000000000246
Jun  6 23:53:53 duff kernel: R13: ffff88011f665b88 R14:
ffff88011e1c2000 R15: ffff88011f665e54
Jun  6 23:53:53 duff kernel: FS:  00007fbf83c03920(0000)
GS:ffff880001800000(0000) knlGS:0000000000000000
Jun  6 23:53:53 duff kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun  6 23:53:53 duff kernel: CR2: 00007fff387d6f98 CR3:
000000011f641000 CR4: 00000000000006f0
Jun  6 23:53:53 duff kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jun  6 23:53:53 duff kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jun  6 23:53:53 duff kernel: Process gnome-session (pid: 3618,
threadinfo ffff88011f664000, task ffff88011e55db40)
Jun  6 23:53:53 duff kernel: Stack:
Jun  6 23:53:53 duff kernel: 0e200e200e200e20 ffff88011e1c2060
ffff88011f665ac8 ffffffff8105405f
Jun  6 23:53:53 duff kernel: <0> ffff88011a157300 0e200e200e200e20
ffff88011f665af8 ffffffff810e2619
Jun  6 23:53:53 duff kernel: <0> ffff88011d251b00 0000000001d0e5c0
ffff88011f665df8 0000000000000000
Jun  6 23:53:53 duff kernel: Call Trace:
Jun  6 23:53:53 duff kernel: [<ffffffff8105405f>] add_wait_queue+0x15/0x46
Jun  6 23:53:53 duff kernel: [<ffffffff810e2619>] __pollwait+0xbe/0xc7
Jun  6 23:53:53 duff kernel: [<ffffffff81349d1b>] sock_poll_wait+0x13/0x18
Jun  6 23:53:53 duff kernel: [<ffffffff81349d39>] unix_poll+0x19/0x95
Jun  6 23:53:53 duff kernel: [<ffffffff812d53c4>] sock_poll+0x15/0x17
Jun  6 23:53:53 duff kernel: [<ffffffff810e2eb8>] do_sys_poll+0x244/0x3e5
Jun  6 23:53:53 duff kernel: [<ffffffff810e255b>] ? __pollwait+0x0/0xc7
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff810e2622>] ? pollwake+0x0/0x4f
Jun  6 23:53:53 duff kernel: [<ffffffff8115d380>] ?
selinux_file_permission+0xa2/0xad
Jun  6 23:53:53 duff kernel: [<ffffffff8105aa48>] ? ktime_get_ts+0xad/0xba
Jun  6 23:53:53 duff kernel: [<ffffffff810e1f26>] ?
poll_select_set_timeout+0x61/0x7c
Jun  6 23:53:53 duff kernel: [<ffffffff810e31ed>] sys_poll+0x50/0xba
Jun  6 23:53:53 duff kernel: [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
Jun  6 23:53:53 duff kernel: Code: f0 66 0f c1 03 38 e0 74 06 f3 90 8a
03 eb f6 58 5b c9 c3 55 48 89 e5 41 54 53 48 89 fb 9c 41 5c fa e8 cb
90 d2 ff ba 00 01 00 00 <f0> 66 0f c1 13 38 f2 74 06 f3 90 8a 13 eb f6
4c 89 e0 5b 41 5c
Jun  6 23:53:53 duff kernel: RIP  [<ffffffff8136b4a5>]
_raw_spin_lock_irqsave+0x18/0x2f
Jun  6 23:53:53 duff kernel: RSP <ffff88011f665a98>
Jun  6 23:53:53 duff kernel: ---[ end trace be9e13ece4e5abe7 ]---

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
