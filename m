Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0HTXb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0HTXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:31:24 -0400
Date: Fri, 20 Aug 2010 19:31:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100820233101.GJ4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:05:42AM -0400, Don Zickus wrote:
> I'll test tip later today to see if I can reproduce it.
> 
> Cheers,
> Don

Sad to say, that won't happen.  Both my amd box and nehalem box have to
many issues with your master branch.

The amd box BUGs in perf_event_nmi_handler on the new code trying to run
'perf top'

arch/x86/kernel/cpu/perf_event.c::perf_event_nmi_handler:1250

((__get_cpu_var(nmi).marked == this_nmi) &&

The BUG is attached below.  I can't figure out why

And my Nehalem box won't even boot with the that kernel, not even to
console for some reason.  Then bisecting revealed that in 2.6.35 something
with LVM changed such that the kernel can't mount my RHEL-6 lvm
partitions.  So even if I did get that kernel booting it won't mount
disks.

I'll take this as a sign to quit for now.. and try again on Monday. :-)

Cheers,
Don

-----



amd-ma78gm-01.rhts.eng.bos.redhat.com login: BUG: unable to handle kernel
paging request at ffff87ff838a5200
IP: [<ffffffff814a6370>] perf_event_nmi_handler+0xd0/0xe0
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/online
CPU 0 
Modules linked in: autofs4 sunrpc cpufreq_ondemand powernow_k8 freq_table
mperf ipv6 dm_mirror dm_region_hash dm_log ppdev parport_pc parport wmi
snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore
snd_page_alloc pcspkr serio_raw edac_core edac_mce_amd sg i2c_piix4 r8169
mii ahci libahci shpchp ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif
firewire_ohci firewire_core crc_itu_t ata_generic pata_acpi pata_atiixp
floppy radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core dm_mod
[last unloaded: scsi_wait_scan]

Pid: 1865, comm: perf Not tainted 2.6.36-rc1tipperf-tip+ #28
GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff814a6370>]  [<ffffffff814a6370>]
perf_event_nmi_handler+0xd0/0xe0
RSP: 0018:ffff880002407e88  EFLAGS: 00010046
RAX: 0000000000000001 RBX: 000000000000000c RCX: ffffffff814a5200
RDX: ffffffff814a5200 RSI: 0000000000000001 RDI: ffff880002400000
RBP: ffff880002407e98 R08: 0000000000000001 R09: ffff880002407d48
R10: 0000000000000002 R11: 0000000000000000 R12: ffff880002407ef8
R13: 00000000fffffffc R14: 0000000000000000 R15: ffffffff81c1df80
FS:  00007f0220ac9700(0000) GS:ffff880002400000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff87ff838a5200 CR3: 0000000222c31000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process perf (pid: 1865, threadinfo ffff880220a78000, task
ffff88021c64a100)
Stack:
 0000000000000000 ffff880002407ef8 ffff880002407ed8 ffffffff814a8505
<0> 0000000000000000 ffff880002407f58 000000000000003d 000000000000003d
<0> ffff88000240ccc0 0000000000000001 ffff880002407ee8 ffffffff814a856a
Call Trace:
 <NMI> 
 [<ffffffff814a8505>] notifier_call_chain+0x55/0x80
 [<ffffffff814a856a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff814a859e>] notify_die+0x2e/0x30
 [<ffffffff814a5963>] do_nmi+0x173/0x2b0
 [<ffffffff814a5220>] nmi+0x20/0x30
 [<ffffffff810340fa>] ? native_write_msr_safe+0xa/0x10
 <<EOE>> 
 [<ffffffff8101a4b0>] x86_pmu_enable_all+0x60/0x80
 [<ffffffff8101b72c>] hw_perf_enable+0xfc/0x230
 [<ffffffff810eb1dd>] perf_enable+0x2d/0x40
 [<ffffffff810ed76d>] __perf_install_in_context+0xcd/0x190
 [<ffffffff810ed6a0>] ? __perf_install_in_context+0x0/0x190
 [<ffffffff810953bc>] smp_call_function_single+0x8c/0x160
 [<ffffffff810f23a8>] ? find_get_context+0x98/0x2b0
 [<ffffffff810edbba>] perf_install_in_context+0x9a/0xa0
 [<ffffffff810f3141>] sys_perf_event_open+0x361/0x4f0
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
Code: 53 01 00 48 c7 c0 00 52 4a 81 65 48 8b 14 25 38 e3 00 00 3b 0c 02 0f
85 67 ff ff ff b8 01 80 00 00 c9 c3 0f 1f 84 00 00 00 00 00 <83> 3c 0f 01
74 a6 eb e9 00 00 00 00 00 00 00 00 55 48 89 e5 48 
RIP  [<ffffffff814a6370>] perf_event_nmi_handler+0xd0/0xe0
 RSP <ffff880002407e88>
CR2: ffff87ff838a5200
---[ end trace 3ddcb8e2da2c4430 ]---

> 
> 
> Ingo Molnar <mingo@elte.hu> wrote:
> 

> 
> it's not working so well, i'm getting:
> 
>  Uhhuh. NMI received for unknown reason 00 on CPU 9.
>  Do you have a strange power saving mode enabled?
>  Dazed and confused, but trying to continue
> 
> on a nehalem box, after a perf top and perf stat run.
> 
> Thanks,
> 
> 	Ingo

