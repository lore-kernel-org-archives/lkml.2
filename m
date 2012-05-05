Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2EED1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab2EED1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:27:13 -0400
Date: Fri, 4 May 2012 23:26:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Peter Zijlstra <peterz@infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
cc: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: 5fbd036b552f633abb394a319f7c62a5c86a9cd7 breaks PA-RISC boot
Message-ID: <Pine.LNX.4.64.1205042305250.18896@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Your patch 5fbd036b552f633abb394a319f7c62a5c86a9cd7 breaks PA-RISC boot. I 
have a dual-core PA-8800. With the patch applied, the kernel crashes with 
these messages. The timer structures are apparently corrupted, as the 
timer sees a negative amount of delayed cycles:

Command line for kernel: 'root=/dev/sda5 console=ttyB0 HOME=/ 
palo_kernel=2/vmlinux-3.4.0-rc5'
Selected kernel: /vmlinux-3.4.0-rc5 from partition 2
ELF64 executable
Entry 00100000 first 00100000 n 2
Segment 0 load 00100000 size 4960256 mediaptr 0x1000
Segment 1 load 007dd320 size 597536 mediaptr 0x4bc320
Branching to kernel entry point 0x00100000.  If this is the last
message you see, you may need to switch your console.  This is
a common symptom -- search the FAQ and mailing list at parisc-linux.org

[    0.000000] Linux version 3.4.0-rc5 (root@phoebe) (gcc version 4.6.3 
(GCC) ) #226 SMP PREEMPT Sat May 5 00:34:33 CEST 2012
[    0.000000] unwind_init: start = 0x404ef000, end = 0x4051bfb0, entries 
= 11515
[    0.000000] FP[0] enabled: Rev 1 Model 20
[    0.000000] The 64-bit Kernel has started...
[    0.000000] bootconsole [ttyB0] enabled
[    0.000000] Initialized PDC Console for debugging.
[    0.000000] Determining PDC firmware type: 64 bit PAT.
[    0.000000] model 00008920 00000491 00000000 00000002 56bbf1abce93405d 
100000f0 00000008 000000b2 000000b2
[    0.000000] vers  00000302
[    0.000000] CPUID vers 20 rev 5 (0x00000285)
[    0.000000] capabilities 0x35
[    0.000000] model 9000/785/C8000
[    0.000000] parisc_cache_init: Only equivalent aliasing supported!
[    0.000000] Memory Ranges:
[    0.000000]  0) Start 0x0000000000000000 End 0x000000003fffffff Size   
1024 MB
[    0.000000]  1) Start 0x0000004040000000 End 0x00000040bfdfffff Size   
2046 MB
[    0.000000] Total Memory: 3070 MB
[    0.000000] PERCPU: Embedded 10 pages/cpu @0000000041baa000 s8512 r8192 
d24256 u40960
[    0.000000] SMP: bootstrap CPU ID is 0
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  
Total pages: 775175
[    0.000000] Kernel command line: root=/dev/sda5 console=ttyB0 HOME=/ 
palo_kernel=2/vmlinux-3.4.0-rc5
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes) [    0.000000] Memory: 3080464k/3143680k available (3351k kernel 
code, 63216k reserved, 1442k data, 160k init)
[    0.000000] virtual kernel memory layout:
[    0.000000]     vmalloc : 0x0000000000008000 - 0x000000003f000000   
(1007 MB)[    0.000000]     memory  : 0x0000000040000000 - 
0x00000040ffe00000   (265214 MB)
[    0.000000]       .init : 0x0000000040848000 - 0x0000000040870000   ( 
160 kB)[    0.000000]       .data : 0x0000000040445c28 - 
0x00000000405ae5d0   (1442 kB)[    0.000000]       .text : 
0x0000000040100000 - 0x0000000040445c28   (3351 kB)[    0.000000] 
Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:80
[    0.000000] Console: colour dummy device 160x64
[    0.060000] Calibrating delay loop... 1797.32 BogoMIPS (lpj=8986624)
[    0.190000] pid_max: default: 32768 minimum: 301
[    0.250000] Mount-cache hash table entries: 256
[    0.340000] Brought up 1 CPUs
[    0.380000] NET: Registered protocol family 16
[    0.440000] Searching for devices...
[    0.590000] Found devices:
[    0.620000] 1. Unknown machine at 0xfffffffffe780000 [128] { 0, 0x0, 
0x892, 0x00004 }
[    0.730000] 2. Unknown machine at 0xfffffffffe781000 [129] { 0, 0x0, 
0x892, 0x00004 }
[    0.830000] 3. Memory at 0xfffffffffed08000 [8] { 1, 0x0, 0x0b6, 
0x00009 }
[    0.920000] 4. Pluto BC McKinley Port at 0xfffffffffed00000 [0] { 12, 
0x0, 0x880, 0x0000c }
[    1.040000] 5. Mercury PCI Bridge at 0xfffffffffed20000 [0/0] { 13, 
0x0, 0x783, 0x0000a }
[    1.140000] 6. Mercury PCI Bridge at 0xfffffffffed24000 [0/2] { 13, 
0x0, 0x783, 0x0000a }
[    1.250000] 7. Mercury PCI Bridge at 0xfffffffffed26000 [0/3] { 13, 
0x0, 0x783, 0x0000a }
[    1.360000] 8. Quicksilver AGP Bridge at 0xfffffffffed28000 [0/4] { 13, 
0x0, 0x784, 0x0000a }
[    1.480000] 9. BMC IPMI Mgmt Ctlr at 0xfffffff0f05b0000 [16] { 15, 0x0, 
0x004, 0x000c0 }
[    1.580000] 10. unknown device at 0xfffffff0f05e0000 [17] { 10, 0x0, 
0x076, 0x000ad }
[    1.690000] 11. unknown device at 0xfffffff0f05e2000 [18] { 10, 0x0, 
0x076, 0x000ad }
[    1.790000] Enabling PDC_PAT chassis codes support v0.05
[    2.390000] Releasing cpu 1 now, hpa=fffffffffe781000
[    2.500000] FP[1] enabled: Rev 1 Model 20
[    2.500000] CPU(s): 2 x PA8900 (Shortfin) at 900.000000 MHz
[    2.630000] Setting cache flush threshold to c0000 (2 CPUs online)
[    2.840000] SBA found Pluto 2.3 at 0xfffffffffed00000
[    2.920000] Mercury version TR3.2 (0x32) found at 0xfffffffffed20000
[    3.010000] LBA 0:0: PCI host bridge to bus 0000:00
[    3.080000] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    3.160000] pci_bus 0000:00: root bus resource [mem 
0xffffffff80000000-0xffffffff8fffffff] (bus address 
[0x80000000-0x8fffffff])
[    3.320000] pci_bus 0000:00: root bus resource [mem 
0xffffff0000000000-0xffffff0fffffffff]
[    3.430000] Mercury version TR3.2 (0x32) found at 0xfffffffffed24000
[    3.520000] LBA 0:2: PCI host bridge to bus 0000:40
[    3.590000] pci_bus 0000:40: root bus resource [io  0x10000-0x1ffff] 
(bus address [0x0000-0xffff])
[    3.710000] pci_bus 0000:40: root bus resource [mem 
0xffffffffa0000000-0xffffffffafffffff] (bus address 
[0xa0000000-0xafffffff])
[    3.860000] pci_bus 0000:40: root bus resource [mem 
0xffffff2000000000-0xffffff2fffffffff]
[    3.970000] Mercury version TR3.2 (0x32) found at 0xfffffffffed26000
[    4.070000] LBA 0:3: PCI host bridge to bus 0000:60
[    4.140000] pci_bus 0000:60: root bus resource [io  0x20000-0x2ffff] 
(bus address [0x0000-0xffff])
[    4.260000] pci_bus 0000:60: root bus resource [mem 
0xffffffffb0000000-0xffffffffbfffffff] (bus address 
[0xb0000000-0xbfffffff])
[    4.410000] pci_bus 0000:60: root bus resource [mem 
0xffffff3000000000-0xffffff3fffffffff]
[    4.530000] Quicksilver version TR1.0 (0x10) found at 
0xfffffffffed28000
[    4.630000] LBA 0:4: PCI host bridge to bus 0000:80
[    4.690000] pci_bus 0000:80: root bus resource [io  0x30000-0x3ffff] 
(bus address [0x0000-0xffff])
[    4.810000] pci_bus 0000:80: root bus resource [mem 
0xffffffffc0000000-0xffffffffcfffffff] (bus address 
[0xc0000000-0xcfffffff])
[    4.970000] pci_bus 0000:80: root bus resource [mem 
0xffffff4000000000-0xffffff4fffffffff]
[    5.150000] powersw: Soft power switch at 0xfffffff0f042e278 enabled.
[    5.240000] bio: create slab <bio-0> at 0
[    5.290000] vgaarb: device added: 
PCI:0000:80:00.0,decodes=io+mem,owns=io+mem,locks=none
[    5.400000] vgaarb: loaded
[    5.440000] vgaarb: bridge control possible 0000:80:00.0
[    5.510000] SCSI subsystem initialized
[    5.560000] usbcore: registered new interface driver usbfs
[    5.630000] usbcore: registered new interface driver hub
[    5.700000] usbcore: registered new device driver usb
[    5.780000] NET: Registered protocol family 2
[    5.840000] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    5.940000] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    6.040000] TCP bind hash table entries: 65536 (order: 8, 1048576 
bytes)
[    6.130000] TCP: Hash tables configured (established 262144 bind 65536)
[    6.220000] TCP: reno registered
[    6.260000] UDP hash table entries: 2048 (order: 5, 131072 bytes)
[    6.350000] UDP-Lite hash table entries: 2048 (order: 5, 131072 bytes)
[    6.470000] timer_interrupt(CPU 0): delayed! cycles FFFFFFFFFFA7F011 
rem 4062EF  next/now 1C9500D655/1C94C07366
[2049638236.880448] timer_interrupt(CPU 0): delayed! cycles 1CB712F9E rem 
49DAA2
  next/now 1E60BBE095/1E607205F3
[2049638236.880448] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} 
(detected by 0, t=2049638230796 jiffies)
[2049638236.880448] INFO: Stall ended before state dump start
[2049638245.450448] timer_interrupt(CPU 0): delayed! cycles 2EEDB3A63 rem 
29839D
  next/now 214FC09E95/214F971AF8


When I put debug messages to smp_cpu_init and smp_callin in 
arch/parisc/kernel/smp.c, it crashes differently, this time it tries to 
run some corrupted task on the second core and it crashes in 
kthread_should_stop:

Command line for kernel: 'root=/dev/sda5 console=ttyB0 HOME=/ 
palo_kernel=2/vmlinux-3.4.0-rc5'
Selected kernel: /vmlinux-3.4.0-rc5 from partition 2
ELF64 executable
Entry 00100000 first 00100000 n 2
Segment 0 load 00100000 size 4960256 mediaptr 0x1000
Segment 1 load 007dd320 size 597536 mediaptr 0x4bc320
Branching to kernel entry point 0x00100000.  If this is the last
message you see, you may need to switch your console.  This is
a common symptom -- search the FAQ and mailing list at parisc-linux.org

[    0.000000] Linux version 3.4.0-rc5 (root@phoebe) (gcc version 4.6.3 
(GCC) ) #272 SMP PREEMPT Sat May 5 04:39:10 CEST 2012
[    0.000000] unwind_init: start = 0x404ef000, end = 0x4051bfb0, entries 
= 11515
[    0.000000] FP[0] enabled: Rev 1 Model 20
[    0.000000] The 64-bit Kernel has started...
[    0.000000] bootconsole [ttyB0] enabled
[    0.000000] Initialized PDC Console for debugging.
[    0.000000] Determining PDC firmware type: 64 bit PAT.
[    0.000000] model 00008920 00000491 00000000 00000002 56bbf1abce93405d 
100000f0 00000008 000000b2 000000b2
[    0.000000] vers  00000302
[    0.000000] CPUID vers 20 rev 5 (0x00000285)
[    0.000000] capabilities 0x35
[    0.000000] model 9000/785/C8000
[    0.000000] parisc_cache_init: Only equivalent aliasing supported!
[    0.000000] Memory Ranges:
[    0.000000]  0) Start 0x0000000000000000 End 0x000000003fffffff Size   
1024 MB
[    0.000000]  1) Start 0x0000004040000000 End 0x00000040bfdfffff Size   
2046 MB
[    0.000000] Total Memory: 3070 MB
[    0.000000] PERCPU: Embedded 10 pages/cpu @0000000041baa000 s8512 r8192 
d24256 u40960
[    0.000000] SMP: bootstrap CPU ID is 0
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  
Total pages: 775175
[    0.000000] Kernel command line: root=/dev/sda5 console=ttyB0 HOME=/ 
palo_kernel=2/vmlinux-3.4.0-rc5
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes) [    0.000000] Memory: 3080464k/3143680k available (3351k kernel 
code, 63216k reserved, 1442k data, 160k init)
[    0.000000] virtual kernel memory layout:
[    0.000000]     vmalloc : 0x0000000000008000 - 0x000000003f000000   
(1007 MB)[    0.000000]     memory  : 0x0000000040000000 - 
0x00000040ffe00000   (265214 MB)
[    0.000000]       .init : 0x0000000040848000 - 0x0000000040870000   ( 
160 kB)[    0.000000]       .data : 0x0000000040445c28 - 
0x00000000405ae5d0   (1442 kB)[    0.000000]       .text : 
0x0000000040100000 - 0x0000000040445c28   (3351 kB)[    0.000000] 
Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:80
[    0.000000] Console: colour dummy device 160x64
[    0.060000] Calibrating delay loop... 1797.32 BogoMIPS (lpj=8986624)
[    0.190000] pid_max: default: 32768 minimum: 301
[    0.250000] Mount-cache hash table entries: 256
[    0.340000] Brought up 1 CPUs
[    0.380000] NET: Registered protocol family 16
[    0.440000] Searching for devices...
[    0.590000] Found devices:
[    0.620000] 1. Unknown machine at 0xfffffffffe780000 [128] { 0, 0x0, 
0x892, 0x00004 }
[    0.730000] 2. Unknown machine at 0xfffffffffe781000 [129] { 0, 0x0, 
0x892, 0x00004 }
[    0.830000] 3. Memory at 0xfffffffffed08000 [8] { 1, 0x0, 0x0b6, 
0x00009 }
[    0.920000] 4. Pluto BC McKinley Port at 0xfffffffffed00000 [0] { 12, 
0x0, 0x880, 0x0000c }
[    1.040000] 5. Mercury PCI Bridge at 0xfffffffffed20000 [0/0] { 13, 
0x0, 0x783, 0x0000a }
[    1.140000] 6. Mercury PCI Bridge at 0xfffffffffed24000 [0/2] { 13, 
0x0, 0x783, 0x0000a }
[    1.250000] 7. Mercury PCI Bridge at 0xfffffffffed26000 [0/3] { 13, 
0x0, 0x783, 0x0000a }
[    1.360000] 8. Quicksilver AGP Bridge at 0xfffffffffed28000 [0/4] { 13, 
0x0, 0x784, 0x0000a }
[    1.480000] 9. BMC IPMI Mgmt Ctlr at 0xfffffff0f05b0000 [16] { 15, 0x0, 
0x004, 0x000c0 }
[    1.580000] 10. unknown device at 0xfffffff0f05e0000 [17] { 10, 0x0, 
0x076, 0x000ad }
[    1.690000] 11. unknown device at 0xfffffff0f05e2000 [18] { 10, 0x0, 
0x076, 0x000ad }
[    1.790000] Enabling PDC_PAT chassis codes support v0.05
[    2.390000] Releasing cpu 1 now, hpa=fffffffffe781000
[    2.500000] FP[1] enabled: Rev 1 Model 20
[    2.500000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    2.500000] CPU(s): 2 x PA8900 (Shortfin) at 900.000000 MHz
[    2.740000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    2.850000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    2.960000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.070000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.180000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.290000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.400000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.510000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.620000] 
blablablablablablablablablablablablablablablablablablablablablablablablablabla
[    3.730000] test1
[    3.750000] test2
[    3.780000] test3
[    3.810000] test4
[    3.830000] test5
[    3.860000] test6
[    3.880000] test7
[    3.910000] test8
[    3.930000] test9
[    3.990000] Backtrace:
[    4.020000]  [<00000000401973a4>] cpu_stopper_thread+0x7c/0x248
[    4.100000]  [<0000000040167a18>] kthread+0xd8/0xe8
[    4.160000]  [<000000004010407c>] ret_from_kernel_thread+0x24/0x40
[    4.240000]
[    4.260000]
[    4.280000] Bad Address (null pointer deref?): Code=15 
regs=000000007fcd0330 (Addr=000007fffffffff0)
[    4.400000]
[    4.420000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[    4.490000] PSW: 00001000000001001111111100001111 Not tainted
[    4.560000] r00-03  000000ff0804ff0f 0000000040846360 00000000401973a4 
000000007fcd0300
[    4.670000] r04-07  0000000040828b60 0000000041bb49b0 0000000041bb49c0 
000000004086e6c0
[    4.780000] r08-11  0000000000000001 0000000041bb49c0 0000000000000001 
0000000000000001
[    4.880000] r12-15  0000000040846b60 0000000040837b60 0000000040837b60 
000000004086e6c0
[    4.990000] r16-19  0000000040846360 000000007fc5ea10 0000000000000000 
000000000800000f
[    5.100000] r20-23  0000000000000001 000000000800000e 000000000800000e 
0000000000000000
[    5.200000] r24-27  0000000000000001 000000007fcb47d8 0000000041bab6c0 
0000000040828b60
[    5.310000] r28-31  0000000000000000 000000007fcd0300 000000007fcd0330 
0000000000000001
[    5.420000] sr00-03  0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[    5.530000] sr04-07  0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[    5.630000]
[    5.650000] IASQ: 0000000000000000 0000000000000000 IAOQ: 
000000004016742c 0000000040167430
[    5.760000]  IIR: 0f81109c    ISR: 000000003ffff800  IOR: 
000007fffffffff0
[    5.860000]  CPU:        0   CR30: 000000007fc64000 CR31: 
ffffffffffffffff
[    5.950000]  ORIG_R28: 000000004011bd5c
[    6.000000]  IAOQ[0]: kthread_should_stop+0xc/0x18
[    6.060000]  IAOQ[1]: kthread_should_stop+0x10/0x18
[    6.130000]  RP(r2): cpu_stopper_thread+0x7c/0x248
[    6.190000] Backtrace:
[    6.220000]  [<00000000401973a4>] cpu_stopper_thread+0x7c/0x248
[    6.300000]  [<0000000040167a18>] kthread+0xd8/0xe8
[    6.370000]  [<000000004010407c>] ret_from_kernel_thread+0x24/0x40
[    6.450000]
[    6.610000] Kernel panic - not syncing: Bad Address (null pointer 
deref?)


I tried to put set_cpu_active(cpunum, true) in the startup functions for 
the secondary processor (smp_callin, smp_cpu_init) to see if the processor 
cannot start if it not active. I actually discovered that it is timing 
dependent (if I put set_cpu_active just after set_cpu_online in 
smp_cpu_init, it works, if I put set_cpu_active to be executed SOME TIME 
after set_cpu_online, it crashes). So the secondary CPU doesn't have 
problem with not being marked active, it is actually the main CPU that 
causes the crash if the secondary CPU is online and inactive.

I couldn't find out what code executing on the main CPU has problems with 
online/inactive secondary CPU. Do you have any ideas?

When I revert your patch, the machine boots and works correctly:

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b1ccce8..9554512 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5410,7 +5410,7 @@ static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
+	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;

Mikulas
