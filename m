Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1DOCGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:06:36 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:39339
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab1DOCGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:06:34 -0400
Date: Fri, 15 Apr 2011 04:06:25 +0200
From: Michael Guntsche <mike@it-loops.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: 2.6.39 Block layer regression was [Bug] Boot hangs with
 2.6.39-rc[123]]
Message-ID: <20110415035451@it-loops.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning again,

> Hi list,
> 
> Apparently all the 2.6.39-rc kernels up to current git HEAD hang on my setup
> here during boot. They survive the initramfs step, but after or during the root
> file system mount it just hangs.
> This is a software RAID-5->LVM setup. The machine itself boots without
> any problems with a 2.6.38 kernel.
> 
> The hardware:
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 1
> model name	: Intel(R) Pentium(R) 4 CPU 1.70GHz
> stepping	: 2
> cpu MHz		: 1699.523
> cache size	: 256 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 2
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts
> bogomips	: 3399.04
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 36 bits physical, 32 bits virtual
> power management:
> 
<boot messages removed>

> md0: detected capacity change from 0 to 57475072
>  md0:
> md: md1 stopped.
> md: bind<sdd2>
> md: bind<sde2>
> md: bind<sdf2>
> md: bind<sda2>
> md: bind<sdc2>
> md/raid:md1: device sdc2 operational as raid disk 0
> md/raid:md1: device sda2 operational as raid disk 4
> md/raid:md1: device sdf2 operational as raid disk 3
> md/raid:md1: device sde2 operational as raid disk 2
> md/raid:md1: device sdd2 operational as raid disk 1
> md/raid:md1: allocated 5258kB
> md/raid:md1: raid level 5 active with 5 out of 5 devices, algorithm 2
> created bitmap (4 pages) for device md1
> md1: bitmap initialized from disk: read 1/1 pages, set 0 bits
> md1: detected capacity change from 0 to 2000189128704
>  md1: unknown partition table
> device fsid d64bac2f4cf259ba-326da6041632dd9c devid 1 transid 557 /dev/sdb1
> end_request: I/O error, dev fd0, sector 0
> EXT3-fs: barriers not enabled
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (dm-0): mounted filesystem with writeback data mode
> udev[1333]: starting version 167
> input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> ACPI: Power Button [PWRB]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> ACPI: Power Button [PWRF]
> parport_pc 00:08: reported by Plug and Play ACPI
> parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
> intel_rng: FWH not detected
> Linux agpgart interface v0.103
> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> agpgart-intel 0000:00:00.0: Intel 865 Chipset
> agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
> Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> intel8x0: white list rate for 1043:80f3 is 48000
> 
> Here the mount hangs. Apparently after root was mounted successfully.
> 
> SysRq : Show Blocked State
>   task                PC stack   pid father
> mount           D f4cfde00     0  1765   1745 0x00000000
>  f4c23dd0 00000086 f44aa800 f4cfde00 f44aa500 0000004d f4c23d74 c11a35f9
>  f4c23d80 f4c23dd0 f4431760 8416416f 00000004 f4431760 00000041 ffffffff
>  00000001 00000008 00100800 f4431760 00000008 00000000 e8da47f8 00000000
> Call Trace:
>  [<c11a35f9>] ? dm_request+0x8a/0xf6
>  [<c105c63b>] ? mempool_alloc_slab+0xe/0x10
>  [<c12197b9>] io_schedule+0x2b/0x42
>  [<c109cbad>] sleep_on_buffer+0x8/0xc
>  [<c1219ad3>] __wait_on_bit+0x43/0x60
>  [<c109cba5>] ? __wait_on_buffer+0x27/0x27
>  [<c1219b46>] out_of_line_wait_on_bit+0x56/0x5e
>  [<c109cba5>] ? __wait_on_buffer+0x27/0x27
>  [<c1038e76>] ? autoremove_wake_function+0x36/0x36
>  [<c109cba3>] __wait_on_buffer+0x25/0x27
>  [<c109d367>] __sync_dirty_buffer+0x6b/0x8b
>  [<c109d394>] sync_dirty_buffer+0xd/0xf
>  [<fa8d7d80>] ext3_commit_super.clone.24+0x4b/0xb0 [ext3]
>  [<c10ed9c7>] ? match_token+0xfd/0x1a2
>  [<fa8d8585>] ext3_setup_super+0xb4/0x20d [ext3]
>  [<fa8d776d>] ? parse_options+0x32/0x4b0 [ext3]
>  [<c121a2e0>] ? __mutex_lock_slowpath+0x124/0x1b2
>  [<c121a379>] ? mutex_lock+0xb/0x22
>  [<fa8da100>] ext3_remount+0x1df/0x27e [ext3]
>  [<fa8d9f21>] ? ext3_fill_super+0x1843/0x1843 [ext3]
>  [<c10811d9>] do_remount_sb+0x7d/0xf6
>  [<c1094379>] do_mount+0x44f/0x633
>  [<c1093e9e>] ? copy_mount_options+0x8d/0xee
>  [<c10947bf>] sys_mount+0x66/0x9b
>  [<c121af1d>] syscall_call+0x7/0xb
> Sched Debug Version: v0.10, 2.6.39-rc3+ #2
> ktime                                   : 37933.056186
> sched_clk                               : 38008.731563
> cpu_clk                                 : 37806.036844
> jiffies                                 : 4294901746
> sched_clock_stable                      : 0
> 
> sysctl_sched
>   .sysctl_sched_latency                    : 6.000000
>   .sysctl_sched_min_granularity            : 0.750000
>   .sysctl_sched_wakeup_granularity         : 1.000000
>   .sysctl_sched_child_runs_first           : 0
>   .sysctl_sched_features                   : 7279
>   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> 
> cpu#0, 1699.419 MHz
>   .nr_running                    : 0
>   .load                          : 0
>   .nr_switches                   : 19596
>   .nr_load_updates               : 3167
>   .nr_uninterruptible            : 1
>   .next_balance                  : 0.000000
>   .curr->pid                     : 0
>   .clock                         : 37680.038704
>   .cpu_load[0]                   : 0
>   .cpu_load[1]                   : 0
>   .cpu_load[2]                   : 0
>   .cpu_load[3]                   : 4
>   .cpu_load[4]                   : 17
>   .yld_count                     : 3
>   .sched_switch                  : 0
>   .sched_count                   : 19620
>   .sched_goidle                  : 1555
>   .ttwu_count                    : 1
>   .ttwu_local                    : 1
>   .bkl_count                     : 0
> 
> cfs_rq[0]:
>   .exec_clock                    : 6548.484099
>   .MIN_vruntime                  : 0.000001
>   .min_vruntime                  : 6269.914000
>   .max_vruntime                  : 0.000001
>   .spread                        : 0.000000
>   .spread0                       : 0.000000
>   .nr_spread_over                : 0
>   .nr_running                    : 0
>   .load                          : 0
> 
> rt_rq[0]:
>   .rt_nr_running                 : 0
>   .rt_throttled                  : 0
>   .rt_time                       : 200.624789
>   .rt_runtime                    : 950.000000
> 
> runnable tasks:
>             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------

After talking to Dave Chinner I looked at the block layer merges. I ended
up on

6c510389005 Merge branch 'for-2.6.39/core' of git://git.kernel.dk/linux-2.6-block

Starting with this merge I see the problems. For testing I compiled the
previous merge

3dab04e6978 Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-mn1030

And apart from a futex error that gets fixed later on I was able to
mount all partitions and could boot. 
As I said initially this happens with current HEAD as well so has not
been fixed yet. Since not everyone is seeing this I wonder if it is
related to my setup here SATA->Raid5->LVM?

Kind regards,
Michael Guntsche
