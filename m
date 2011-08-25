Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1HYPrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:47:45 -0400
Received: from mail.microway.com ([206.173.81.22]:34123 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752326Ab1HYPrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:47:41 -0400
Message-ID: <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>
In-Reply-To: <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>
References: <201108171751.51648.rick@microway.com>
    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>
    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>
    <20110823171432.GA10794@redhat.com>
    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>
    <4E547B0F.6000001@intel.com>
    <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>
Date: Thu, 25 Aug 2011 11:47:39 -0400
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
From: rick@microway.com
To: "Huang Ying" <ying.huang@intel.com>
Cc: "Don Zickus" <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Houghton" <rhoughton@microway.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>
User-Agent: SquirrelMail/1.4.21
X-Priority: 3 (Normal)
Importance: Normal
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

My new setup reproduced the panic. However I do not have any gar accessed
messages on it.  The gar mapped messages are in my previous email.  Here
is the latest call trace.  There is no GHES output prior to it:

[30348.824329] BUG: unable to handle kernel NULL pointer dereference at   
       (null)
[30348.832197] IP: [<ffffffff812a211d>] acpi_atomic_read+0x8d/0xcb
[30348.838144] PGD 605984067 PUD 6059de067 PMD 0
[30348.842654] Oops: 0000 [#1] PREEMPT SMP
[30348.846640] last sysfs file:
/sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
[30348.854555] CPU 13
[30348.856487] Modules linked in: md5 ipmi_devintf ipmi_si ipmi_msghandler
nfsd lockd nfs_acl auth_rpcgss sunrpc ipt_MASQUERADE iptable_mangle
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
iptable_filter ip_tables x_tables af_packet edd cpufreq_conservative
cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf xfs dm_mod igb
joydev ioatdma dca iTCO_wdt iTCO_vendor_support i7core_edac i2c_i801
edac_core ghes button hed sg pcspkr serio_raw ext4 jbd2 crc16 fan
processor thermal thermal_sys ata_generic pata_atiixp arcmsr
[30348.904982]
[30348.906481] Pid: 27462, comm: cluster Not tainted
2.6.39.3-microwaycustom #8 Supermicro X8DTH-i/6/iF/6F/X8DTH
[30348.916458] RIP: 0010:[<ffffffff812a211d>]  [<ffffffff812a211d>]
acpi_atomic_read+0x8d/0xcb
[30348.924825] RSP: 0000:ffff88063fca7da8  EFLAGS: 00010046
[30348.930129] RAX: 0000000000000000 RBX: ffff88063fca7df0 RCX:
00000000bf7b6000
[30348.937251] RDX: 0000000000000000 RSI: 00000000bf7b6010 RDI:
00000000bf7b5ff0
[30348.944374] RBP: ffff88063fca7dd8 R08: 00000000bf7b7000 R09:
0000000000000000
[30348.951497] R10: 000000000000000a R11: 000000000000000b R12:
ffffc90003044c20
[30348.958627] R13: 0000000000000000 R14: 00000000bf7b5ff0 R15:
0000000000000000
[30348.965758] FS:  0000000000000000(0000) GS:ffff88063fca0000(0000)
knlGS:0000000000000000
[30348.973841] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[30348.979586] CR2: 0000000000000000 CR3: 00000006059db000 CR4:
00000000000006e0
[30348.986708] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[30348.993838] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[30349.000961] Process cluster (pid: 27462, threadinfo ffff880605a02000,
task ffff88061e8f8440)
[30349.009387] Stack:
[30349.011403]  0000000000000000 00000000bf7b5ff0 ffff88032ac0a940
ffff88032ac0a940
[30349.018879]  0000000000000001 ffffc90003044ca8 ffff88063fca7e18
ffffffffa0136235
[30349.026366]  0000000000000000 0000000000000000 ffff88032ac0a940
0000000000000000
[30349.033850] Call Trace:
[30349.036300]  <NMI>
[30349.038442]  [<ffffffffa0136235>] ghes_read_estatus+0x45/0x180 [ghes]
[30349.044882]  [<ffffffffa013660c>] ghes_notify_nmi+0xbc/0x190 [ghes]
[30349.051148]  [<ffffffff8150ddfd>] notifier_call_chain+0x4d/0x70
[30349.057065]  [<ffffffff8150de63>] __atomic_notifier_call_chain+0x43/0x60
[30349.063762]  [<ffffffff8150de91>] atomic_notifier_call_chain+0x11/0x20
[30349.070286]  [<ffffffff8150dece>] notify_die+0x2e/0x30
[30349.075415]  [<ffffffff8150b4f2>] do_nmi+0xa2/0x260
[30349.080287]  [<ffffffff8150b150>] nmi+0x20/0x30
[30349.084819]  [<ffffffff81029f6a>] ? native_write_msr_safe+0xa/0x10
[30349.090991]  <<EOE>>
[30349.093094]  <IRQ>
[30349.095424]  [<ffffffff81011568>] intel_pmu_disable_all+0x38/0xb0
[30349.101516]  [<ffffffff81010efa>] x86_pmu_disable+0x4a/0x50
[30349.107093]  [<ffffffff810ea842>] perf_event_task_tick+0x1a2/0x2a0
[30349.113269]  [<ffffffff81050750>] scheduler_tick+0x1b0/0x290
[30349.118932]  [<ffffffff81066c29>] update_process_times+0x69/0x80
[30349.124936]  [<ffffffff81088098>] tick_sched_timer+0x58/0x150
[30349.130680]  [<ffffffff8107b7ef>] __run_hrtimer+0x6f/0x250
[30349.136166]  [<ffffffff81088040>] ? tick_init_highres+0x20/0x20
[30349.142087]  [<ffffffff8107bf7a>] hrtimer_interrupt+0xda/0x230
[30349.147921]  [<ffffffff8101f5c6>] smp_apic_timer_interrupt+0x66/0xa0
[30349.154272]  [<ffffffff815120f3>] apic_timer_interrupt+0x13/0x20
[30349.160272]  <EOI>
[30349.162200] Code: fc 10 74 1f 77 08 41 80 fc 08 75 49 eb 0e 41 80 fc 20
74 17 41 80 fc 40 75 3b eb 15 8a 00 0f b6 c0 eb 11 66 8b 00 0f b7 c0 eb 09
<8b> 00 89 c0 eb 03 48 8b 00 48 89 03 e8 62 55 e2 ff eb 1d 41 0f
[30349.182456] RIP  [<ffffffff812a211d>] acpi_atomic_read+0x8d/0xcb
[30349.188490]  RSP <ffff88063fca7da8>
[30349.191977] CR2: 0000000000000000
[30349.195293] ---[ end trace 316c5d7ea544957e ]---
[30349.199904] Kernel panic - not syncing: Fatal exception in interrupt
[30349.206249] Pid: 27462, comm: cluster Tainted: G      D    
2.6.39.3-microwaycustom #8
[30349.214156] Call Trace:
[30349.216605]  <NMI>  [<ffffffff815071ee>] panic+0x9b/0x1b0
[30349.222034]  [<ffffffff8150bb4a>] oops_end+0xea/0xf0
[30349.226997]  [<ffffffff81031dc3>] no_context+0xf3/0x260
[30349.232220]  [<ffffffff812569de>] ? number+0x31e/0x350
[30349.237360]  [<ffffffff81032055>] __bad_area_nosemaphore+0x125/0x1e0
[30349.243712]  [<ffffffff8103211e>] bad_area_nosemaphore+0xe/0x10
[30349.249633]  [<ffffffff8150dd10>] do_page_fault+0x500/0x5a0
[30349.255205]  [<ffffffff81258e0e>] ? vsnprintf+0x33e/0x5d0
[30349.260605]  [<ffffffff8107cd3a>] ? up+0x2a/0x50
[30349.265228]  [<ffffffff81056da9>] ? console_unlock+0x189/0x1e0
[30349.271057]  [<ffffffff8150ae95>] page_fault+0x25/0x30
[30349.276201]  [<ffffffff812a211d>] ? acpi_atomic_read+0x8d/0xcb
[30349.282029]  [<ffffffff812a20f0>] ? acpi_atomic_read+0x60/0xcb
[30349.287869]  [<ffffffffa0136235>] ghes_read_estatus+0x45/0x180 [ghes]
[30349.294311]  [<ffffffffa013660c>] ghes_notify_nmi+0xbc/0x190 [ghes]
[30349.300575]  [<ffffffff8150ddfd>] notifier_call_chain+0x4d/0x70
[30349.306494]  [<ffffffff8150de63>] __atomic_notifier_call_chain+0x43/0x60
[30349.313192]  [<ffffffff8150de91>] atomic_notifier_call_chain+0x11/0x20
[30349.319715]  [<ffffffff8150dece>] notify_die+0x2e/0x30
[30349.324853]  [<ffffffff8150b4f2>] do_nmi+0xa2/0x260
[30349.329727]  [<ffffffff8150b150>] nmi+0x20/0x30
[30349.334264]  [<ffffffff81029f6a>] ? native_write_msr_safe+0xa/0x10
[30349.340438]  <<EOE>>  <IRQ>  [<ffffffff81011568>]
intel_pmu_disable_all+0x38/0xb0
[30349.347959]  [<ffffffff81010efa>] x86_pmu_disable+0x4a/0x50
[30349.353527]  [<ffffffff810ea842>] perf_event_task_tick+0x1a2/0x2a0
[30349.359705]  [<ffffffff81050750>] scheduler_tick+0x1b0/0x290
[30349.365366]  [<ffffffff81066c29>] update_process_times+0x69/0x80
[30349.371370]  [<ffffffff81088098>] tick_sched_timer+0x58/0x150
[30349.377114]  [<ffffffff8107b7ef>] __run_hrtimer+0x6f/0x250
[30349.382604]  [<ffffffff81088040>] ? tick_init_highres+0x20/0x20
[30349.388518]  [<ffffffff8107bf7a>] hrtimer_interrupt+0xda/0x230
[30349.394355]  [<ffffffff8101f5c6>] smp_apic_timer_interrupt+0x66/0xa0
[30349.400708]  [<ffffffff815120f3>] apic_timer_interrupt+0x13/0x20
[30349.406705]  <EOI>

Thanks,
Rick

> Hi Huang,
>
> The original system needs to ship to our customer ASAP.  Disabling ghes is
> sufficient for the time being for that.  As such, I have set up an
> identical system as a temporary master for another cluster to continue
> this testing.
>
> I have applied your patch.  Here is the output of dmesg | grep GHES so
> far:
>
>
> [    9.272198] GHES: gar mapped: 0, 0xbf7b5ff0
> [    9.280782] GHES: gar mapped: 0, 0xbf7b6200
> [    9.285102] [Firmware Warn]: GHES: Poll interval is 0 for generic
> hardware error source: 1, disabled.
>
> I have the serial console activated and stress tests started back up.
> I'll reply with the output once I get another panic.
>
> Thanks!
> Rick
>
>> Hi, Rick,
>>
>> It appears that panic occurs in acpi_atomic_read.  I think the most
>> likely cause is that the acpi_generic_address is not pre-mapped.  Can
>> you try the patch attached?
>>
>> It will print registers mapped and accessed.  To use it, run the
>> following command line before workload.
>>
>> dmesg | grep GHES
>>
>> Then try to find something like
>>
>> GHES: gar accessed: x, xxxx
>>
>> in kernel log when panic occurs.
>>
>> Best Regards,
>> Huang Ying
>>
>>
>
>


