Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1HVOmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:42:17 -0400
Received: from mail.microway.com ([206.173.81.22]:60401 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751147Ab1HVOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:42:13 -0400
Message-ID: <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>
In-Reply-To: <201108182343.57312.rjw@sisk.pl>
References: <201108171751.51648.rick@microway.com>
    <201108180947.15064.rjw@sisk.pl> <201108182343.57312.rjw@sisk.pl>
Date: Mon, 22 Aug 2011 10:42:10 -0400
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
From: rick@microway.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, "Richard Houghton" <rhoughton@microway.com>,
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

> On Thursday, August 18, 2011, Rafael J. Wysocki wrote:
>> Hi,
>>
>> It's better to report ACPI failues to linux-acpi.
>>
>> On Wednesday, August 17, 2011, Rick Warner wrote:
>> > Hi all,
>> >
>> > I am getting a kernel oops/panic on a dual xeon system that is the
>> master of a
>> > 60 node HPC cluster.  This is happening while stress testing the
>> system
>> > including significant network traffic.  The OS is openSuse 11.4.
>> >
>> > We are running a custom compiled 2.6.39.3 kernel on the systems due to
>> a bug
>> > in the stock kernel 11.4 provided (igb driver related).  After 1-3
>> days of
>> > heavy testing, the master node locks up with the caps lock and scroll
>> lock
>> > keys on the keyboard blinking with the following output captured via a
>> serial
>> > console:
>> >
>> > [381920.681113] BUG: unable to handle kernel NULL pointer dereference
>> at
>> > (null)
>> > [381920.689067] IP: [<ffffffff812a7510>] acpi_atomic_read+0xe3/0x120
>> > [381920.695187] PGD 30c27a067 PUD 16efe6067 PMD 0
>> > [381920.699782] Oops: 0000 [#1] PREEMPT SMP
>> > [381920.703866] last sysfs file:
>> > /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
>> > [381920.711868] CPU 6
>> > [381920.713800] Modules linked in: md5 ipmi_devintf ipmi_si
>> ipmi_msghandler
>> > nfsd lockd nfs_acl auth_rpcgss sunrpc ipt_MASQUERADE iptable_mangle
>> > iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
>> iptable_filter
>> > ip_tables x_tables af_packet edd cpufreq_conservative
>> cpufreq_userspace
>> > cpufreq_powersave acpi_cpufreq mperf xfs dm_mod ioatdma i7core_edac
>> edac_core
>> > sr_mod cdrom joydev igb i2c_i801 sg button ghes hed iTCO_wdt
>> > iTCO_vendor_support dca pcspkr ext4 jbd2 crc16 raid456
>> async_raid6_recov
>> > async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid1
>> raid0 fan
>> > processor thermal thermal_sys ata_generic pata_atiixp arcmsr
>> > [381920.771623]
>> > [381920.773210] Pid: 12701, comm: cluster Not tainted
>> 2.6.39.3-microwaycustom
>> > #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
>> > [381920.783292] RIP: 0010:[<ffffffff812a7510>]  [<ffffffff812a7510>]
>> > acpi_atomic_read+0xe3/0x120
>> > [381920.791853] RSP: 0000:ffff88063fc47d98  EFLAGS: 00010046
>> > [381920.797260] RAX: 0000000000000000 RBX: 00000000bf7b5ff0 RCX:
>> ffffffff81a3cdd0
>> > [381920.804486] RDX: 00000000bf7b6010 RSI: 00000000bf7b6000 RDI:
>> > ffff88062d4b95c0
>> > [381920.811712] RBP: ffff88063fc47dc8 R08: ffff88063fc47d98 R09:
>> 0000000000000002
>> > [381920.818940] R10: 0000000000000083 R11: 0000000000000010 R12:
>> > ffffc90003044c20
>> > [381920.826168] R13: ffff88063fc47de0 R14: 0000000000000000 R15:
>> > 0000000000000000
>> > [381920.833392] FS:  0000000000000000(0000) GS:ffff88063fc40000(0000)
>> > knlGS:0000000000000000
>> > [381920.841571] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>> > [381920.847409] CR2: 0000000000000000 CR3: 00000001d2d0f000 CR4:
>> > 00000000000006e0
>> > [381920.854635] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> > 0000000000000000
>> > [381920.861861] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> > [381920.869088] Process cluster (pid: 12701, threadinfo
>> ffff880028284000, task
>> > ffff880550184380)
>> > [381920.877608] Stack:
>> > [381920.879717]  ffffffff81a3cdd0 00000000bf7b5ff0 ffff88062b2cc140
>> ffffc90003044ca8
>> > [381920.887288]  ffff88062b2cc140 0000000000000001 ffff88063fc47e08
>> ffffffffa002b21f
>> > [381920.894862]  0000000000000000 0000000000000000 ffff88062b2cc140
>> > 0000000000000000
>> > [381920.902435] Call Trace:
>> > [381920.904969]  <NMI>
>> > [381920.907201]  [<ffffffffa002b21f>] ghes_read_estatus+0x2f/0x170
>> [ghes]
>> > [381920.913726]  [<ffffffffa002b618>] ghes_notify_nmi+0xd8/0x1b0
>> [ghes]
>> > [381920.920076]  [<ffffffff8151a14f>] notifier_call_chain+0x3f/0x80
>> > [381920.926080]  [<ffffffff8151a1d8>]
>> __atomic_notifier_call_chain+0x48/0x70
>> > [381920.932864]  [<ffffffff8151a211>]
>> atomic_notifier_call_chain+0x11/0x20
>> > [381920.939473]  [<ffffffff8151a24e>] notify_die+0x2e/0x30
>> > [381920.944691]  [<ffffffff81517bd2>] do_nmi+0xa2/0x270
>> > [381920.949649]  [<ffffffff81517550>] nmi+0x20/0x30
>> > [381920.954269]  [<ffffffff8102ae8a>] ? native_write_msr_safe+0xa/0x10
>> > [381920.960536]  <<EOE>>
>> > [381920.962725]  <IRQ>
>> > [381920.965132]  [<ffffffff8101131e>] intel_pmu_disable_all+0x3e/0x120
>> > [381920.971399]  [<ffffffff81010d5a>] x86_pmu_disable+0x4a/0x50
>> > [381920.977066]  [<ffffffff810e7f2b>] perf_pmu_disable+0x2b/0x40
>> > [381920.982817]  [<ffffffff810ee828>] perf_event_task_tick+0x218/0x270
>> > [381920.989082]  [<ffffffff81046f4d>] scheduler_tick+0xdd/0x2c0
>> > [381920.994740]  [<ffffffff81067097>] update_process_times+0x67/0x80
>> > [381921.000832]  [<ffffffff81089eef>] tick_sched_timer+0x5f/0xc0
>> > [381921.006578]  [<ffffffff81089e90>] ? tick_nohz_handler+0x100/0x100
>> > [381921.012758]  [<ffffffff8107db3d>] __run_hrtimer+0x12d/0x280
>> > [381921.018414]  [<ffffffff8107dea7>] hrtimer_interrupt+0xb7/0x1e0
>> > [381921.024343]  [<ffffffff810206d7>]
>> smp_apic_timer_interrupt+0x67/0xa0
>> > [381921.030793]  [<ffffffff8151e3f3>] apic_timer_interrupt+0x13/0x20
>> > [381921.036891]  <EOI>
>> > [381921.038913] Code: fc 10 74 1f 77 08 41 80 fc 08 75 48 eb 0e 41 80
>> fc 20 74
>> > 17 41 80 fc 40 75 3a eb 15 8a 00 0f b6 c0 eb 11 66 8b 00 0f b7 c0 eb
>> 09 <8b>
>> > 00 89 c0 eb 03 48 8b 00 49 89 45 00 e8 8e 2b e2 ff eb 1b 0f
>> > [381921.059462] RIP  [<ffffffff812a7510>] acpi_atomic_read+0xe3/0x120
>> > [381921.065669]  RSP <ffff88063fc47d98>
>> > [381921.069242] CR2: 0000000000000000
>> > [381921.072645] ---[ end trace 52697bfc73a34a90 ]---
>> > [381921.077343] Kernel panic - not syncing: Fatal exception in
>> interrupt
>> > [381921.083784] Pid: 12701, comm: cluster Tainted: G      D
>> 2.6.39.3-
>> > microwaycustom #1
>> > [381921.091788] Call Trace:
>> > [381921.094333]  <NMI>  [<ffffffff81513300>] panic+0x9f/0x1da
>> > [381921.099881]  [<ffffffff81517f8c>] oops_end+0xdc/0xf0
>> > [381921.104952]  [<ffffffff81032b91>] no_context+0xf1/0x260
>> > [381921.110277]  [<ffffffff81032e55>]
>> __bad_area_nosemaphore+0x155/0x200
>> > [381921.116739]  [<ffffffff81032f0e>] bad_area_nosemaphore+0xe/0x10
>> > [381921.122766]  [<ffffffff81519f46>] do_page_fault+0x366/0x530
>> > [381921.128440]  [<ffffffff810ee929>] ?
>> __perf_event_overflow+0xa9/0x220
>> > [381921.134896]  [<ffffffff810ef99b>] ?
>> perf_event_update_userpage+0x9b/0xe0
>> > [381921.141698]  [<ffffffff81012249>] ?
>> intel_pmu_enable_all+0xc9/0x1a0
>> > [381921.148061]  [<ffffffff810123ff>] ?
>> x86_perf_event_set_period+0xdf/0x170
>> > [381921.154852]  [<ffffffff81517295>] page_fault+0x25/0x30
>> > [381921.160081]  [<ffffffff812a7510>] ? acpi_atomic_read+0xe3/0x120
>> > [381921.166094]  [<ffffffff812a7486>] ? acpi_atomic_read+0x59/0x120
>> > [381921.172107]  [<ffffffffa002b21f>] ghes_read_estatus+0x2f/0x170
>> [ghes]
>> > [381921.178639]  [<ffffffffa002b618>] ghes_notify_nmi+0xd8/0x1b0
>> [ghes]
>> > [381921.185004]  [<ffffffff8151a14f>] notifier_call_chain+0x3f/0x80
>> > [381921.191003]  [<ffffffff8151a1d8>]
>> __atomic_notifier_call_chain+0x48/0x70
>> > [381921.197789]  [<ffffffff8151a211>]
>> atomic_notifier_call_chain+0x11/0x20
>> > [381921.204399]  [<ffffffff8151a24e>] notify_die+0x2e/0x30
>> > [381921.209624]  [<ffffffff81517bd2>] do_nmi+0xa2/0x270
>> > [381921.214584]  [<ffffffff81517550>] nmi+0x20/0x30
>> > [381921.219208]  [<ffffffff8102ae8a>] ? native_write_msr_safe+0xa/0x10
>> > [381921.225470]  <<EOE>>  <IRQ>  [<ffffffff8101131e>]
>> > intel_pmu_disable_all+0x3e/0x120
>> > [381921.233174]  [<ffffffff81010d5a>] x86_pmu_disable+0x4a/0x50
>> > [381921.238836]  [<ffffffff810e7f2b>] perf_pmu_disable+0x2b/0x40
>> > [381921.244582]  [<ffffffff810ee828>] perf_event_task_tick+0x218/0x270
>> > [381921.250855]  [<ffffffff81046f4d>] scheduler_tick+0xdd/0x2c0
>> > [381921.256520]  [<ffffffff81067097>] update_process_times+0x67/0x80
>> > [381921.262618]  [<ffffffff81089eef>] tick_sched_timer+0x5f/0xc0
>> > [381921.268363]  [<ffffffff81089e90>] ? tick_nohz_handler+0x100/0x100
>> > [381921.274540]  [<ffffffff8107db3d>] __run_hrtimer+0x12d/0x280
>> > [381921.280198]  [<ffffffff8107dea7>] hrtimer_interrupt+0xb7/0x1e0
>> > [381921.286125]  [<ffffffff810206d7>]
>> smp_apic_timer_interrupt+0x67/0xa0
>> > [381921.292578]  [<ffffffff8151e3f3>] apic_timer_interrupt+0x13/0x20
>> > [381921.298673]  <EOI>
>> >
>> >
>> > I recompiled the kernel again, disabling the tickless feature as I saw
>> "nohz"
>> > early in the call trace.  After that, it reproduced again but the call
>> trace
>> > only changed slightly having tick_init_highres in there instead of
>> > tick_nohz_handler.  I have that call trace if it is desired as well.
>> It is
>> > nearly identical though.
>> >
>> > I am currently trying a custom 2.6.36.4 on the system, but will need
>> up to 3
>> > days before I know if the problem exists there as well.
>> >
>> > Any ideas on this?
>>
>> It looks like a wrong address in ghes_read_estatus().  I'll have a look
>> at it
>> later today.
>
> Hmm.  Please apply the appended patch and see if the error is still
> reproducible (it's on top of the current mainline, so you may need to
> adjust it by hand).
>
> Thanks,
> Rafael
>
> ---
>  drivers/acpi/apei/ghes.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> Index: linux/drivers/acpi/apei/ghes.c
> ===================================================================
> --- linux.orig/drivers/acpi/apei/ghes.c
> +++ linux/drivers/acpi/apei/ghes.c
> @@ -398,6 +398,9 @@ static int ghes_read_estatus(struct ghes
>  	u32 len;
>  	int rc;
>
> +	if (!g)
> +		return -EINVAL;
> +
>  	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
>  	if (rc) {
>  		if (!silent && printk_ratelimit())
>

Thanks for the quick patch!  Unfortunately, the system crashed again with
the same call trace. I'll list it below in case there are any differences
I missed.  I have currently added a test for (!&g->error_status_address)
just like your test on (!g) to verify that isn't a null pointer either,
and will start tests back up with that change.  Please let me know if you
have any other suggestions or patches for me to try.

Thanks,
Rick

Call trace:

[59719.446761] BUG: unable to handle kernel NULL pointer dereference at   
       (null)
[59719.454633] IP: [<ffffffff812a211d>] acpi_atomic_read+0x8d/0xcb
[59719.460580] PGD 62c5c0067 PUD 6188ed067 PMD 0
[59719.465080] Oops: 0000 [#1] PREEMPT SMP
[59719.469050] last sysfs file:
/sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
[59719.476954] CPU 9
[59719.478794] Modules linked in: md5 nfsd lockd nfs_acl auth_rpcgss
sunrpc ipt_MASQUERADE iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables af_packet
edd cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
mperf xfs dm_mod igb sr_mod cdrom joydev ioatdma pcspkr ghes i2c_i801 sg
dca i7core_edac edac_core hed button iTCO_wdt iTCO_vendor_support ext4
jbd2 crc16 raid456 async_raid6_recov async_pq raid6_pq async_xor xor
async_memcpy async_tx raid10 raid1 raid0 fan processor thermal thermal_sys
ata_generic pata_atiixp arcmsr
[59719.533141]
[59719.534642] Pid: 26831, comm: cluster Not tainted
2.6.39.3-microwaycustom #2 Supermicro X8DTH-i/6/iF/6F/X8DTH
[59719.544616] RIP: 0010:[<ffffffff812a211d>]  [<ffffffff812a211d>]
acpi_atomic_read+0x8d/0xcb
[59719.552984] RSP: 0000:ffff88033fca7da8  EFLAGS: 00010046
[59719.558298] RAX: 0000000000000000 RBX: ffff88033fca7df0 RCX:
00000000bf7b6000
[59719.565430] RDX: 0000000000000000 RSI: 00000000bf7b6010 RDI:
00000000bf7b5ff0
[59719.572561] RBP: ffff88033fca7dd8 R08: 00000000bf7b7000 R09:
0000000000000002
[59719.579694] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffc90003044c20
[59719.586822] R13: 0000000000000000 R14: 00000000bf7b5ff0 R15:
0000000000000000
[59719.593954] FS:  0000000000000000(0000) GS:ffff88033fca0000(0000)
knlGS:0000000000000000
[59719.602037] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[59719.607783] CR2: 0000000000000000 CR3: 000000062bc1b000 CR4:
00000000000006e0
[59719.614913] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[59719.622045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[59719.629176] Process cluster (pid: 26831, threadinfo ffff88030c960000,
task ffff8803021460c0)
[59719.637601] Stack:
[59719.639616]  0000000000000000 00000000bf7b5ff0 00000000ffffffea
ffff88062c0aa2c0
[59719.647092]  0000000000000001 ffffc90003044ca8 ffff88033fca7e18
ffffffffa0278228
[59719.654579]  0000000000000000 0000000000000000 ffff88062c0aa2c0
0000000000000000
[59719.662063] Call Trace:
[59719.664514]  <NMI>
[59719.666655]  [<ffffffffa0278228>] ghes_read_estatus+0x38/0x180 [ghes]
[59719.673106]  [<ffffffffa027860c>] ghes_notify_nmi+0xbc/0x190 [ghes]
[59719.679383]  [<ffffffff8150ddfd>] notifier_call_chain+0x4d/0x70
[59719.685310]  [<ffffffff8150de63>] __atomic_notifier_call_chain+0x43/0x60
[59719.692015]  [<ffffffff8150de91>] atomic_notifier_call_chain+0x11/0x20
[59719.698548]  [<ffffffff8150dece>] notify_die+0x2e/0x30
[59719.703694]  [<ffffffff8150b4f2>] do_nmi+0xa2/0x260
[59719.708574]  [<ffffffff8150b150>] nmi+0x20/0x30
[59719.713112]  [<ffffffff81029f6a>] ? native_write_msr_safe+0xa/0x10
[59719.719285]  <<EOE>>
[59719.721387]  <IRQ>
[59719.723709]  [<ffffffff81011568>] intel_pmu_disable_all+0x38/0xb0
[59719.729806]  [<ffffffff81010efa>] x86_pmu_disable+0x4a/0x50
[59719.735388]  [<ffffffff810ea842>] perf_event_task_tick+0x1a2/0x2a0
[59719.741571]  [<ffffffff81050750>] scheduler_tick+0x1b0/0x290
[59719.747232]  [<ffffffff81066c29>] update_process_times+0x69/0x80
[59719.753238]  [<ffffffff81088098>] tick_sched_timer+0x58/0x150
[59719.758989]  [<ffffffff8107b7ef>] __run_hrtimer+0x6f/0x250
[59719.764481]  [<ffffffff81088040>] ? tick_init_highres+0x20/0x20
[59719.770409]  [<ffffffff8107bf7a>] hrtimer_interrupt+0xda/0x230
[59719.776248]  [<ffffffff8101f5c6>] smp_apic_timer_interrupt+0x66/0xa0
[59719.782599]  [<ffffffff815120f3>] apic_timer_interrupt+0x13/0x20
[59719.788600]  <EOI>
[59719.790529] Code: fc 10 74 1f 77 08 41 80 fc 08 75 49 eb 0e 41 80 fc 20
74 17 41 80 fc 40 75 3b eb 15 8a 00 0f b6 c0 eb 11 66 8b 00 0f b7 c0 eb 09
<8b> 00 89 c0 eb 03 48 8b 00 48 89 03 e8 62 55 e2 ff eb 1d 41 0f
[59719.810804] RIP  [<ffffffff812a211d>] acpi_atomic_read+0x8d/0xcb
[59719.816836]  RSP <ffff88033fca7da8>
[59719.820324] CR2: 0000000000000000
[59719.823641] ---[ end trace d2c1ec821cf1a607 ]---
[59719.828260] Kernel panic - not syncing: Fatal exception in interrupt
[59719.834614] Pid: 26831, comm: cluster Tainted: G      D    
2.6.39.3-microwaycustom #2
[59719.842520] Call Trace:
[59719.844968]  <NMI>  [<ffffffff815071ee>] panic+0x9b/0x1b0
[59719.850399]  [<ffffffff8150bb4a>] oops_end+0xea/0xf0
[59719.855374]  [<ffffffff81031dc3>] no_context+0xf3/0x260
[59719.860613]  [<ffffffff81032055>] __bad_area_nosemaphore+0x125/0x1e0
[59719.866970]  [<ffffffff8103211e>] bad_area_nosemaphore+0xe/0x10
[59719.872895]  [<ffffffff8150dd10>] do_page_fault+0x500/0x5a0
[59719.878483]  [<ffffffff810eb839>] ? __perf_event_overflow+0x99/0x210
[59719.884838]  [<ffffffff8150ae95>] page_fault+0x25/0x30
[59719.889996]  [<ffffffff812a211d>] ? acpi_atomic_read+0x8d/0xcb
[59719.895838]  [<ffffffff812a20f0>] ? acpi_atomic_read+0x60/0xcb
[59719.901684]  [<ffffffffa0278228>] ghes_read_estatus+0x38/0x180 [ghes]
[59719.908139]  [<ffffffffa027860c>] ghes_notify_nmi+0xbc/0x190 [ghes]
[59719.914417]  [<ffffffff8150ddfd>] notifier_call_chain+0x4d/0x70
[59719.920338]  [<ffffffff8150de63>] __atomic_notifier_call_chain+0x43/0x60
[59719.927047]  [<ffffffff8150de91>] atomic_notifier_call_chain+0x11/0x20
[59719.933575]  [<ffffffff8150dece>] notify_die+0x2e/0x30
[59719.938708]  [<ffffffff8150b4f2>] do_nmi+0xa2/0x260
[59719.943585]  [<ffffffff8150b150>] nmi+0x20/0x30
[59719.948127]  [<ffffffff81029f6a>] ? native_write_msr_safe+0xa/0x10
[59719.954303]  <<EOE>>  <IRQ>  [<ffffffff81011568>]
intel_pmu_disable_all+0x38/0xb0
[59719.961840]  [<ffffffff81010efa>] x86_pmu_disable+0x4a/0x50
[59719.967423]  [<ffffffff810ea842>] perf_event_task_tick+0x1a2/0x2a0
[59719.973609]  [<ffffffff81050750>] scheduler_tick+0x1b0/0x290
[59719.979273]  [<ffffffff81066c29>] update_process_times+0x69/0x80
[59719.985282]  [<ffffffff81088098>] tick_sched_timer+0x58/0x150
[59719.991039]  [<ffffffff8107b7ef>] __run_hrtimer+0x6f/0x250
[59719.996536]  [<ffffffff81088040>] ? tick_init_highres+0x20/0x20
[59720.002456]  [<ffffffff8107bf7a>] hrtimer_interrupt+0xda/0x230
[59720.008289]  [<ffffffff8101f5c6>] smp_apic_timer_interrupt+0x66/0xa0
[59720.014646]  [<ffffffff815120f3>] apic_timer_interrupt+0x13/0x20
[59720.020648]  <EOI>


