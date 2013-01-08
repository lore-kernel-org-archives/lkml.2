Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3AHAOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:14:55 -0500
Received: from plane.gmane.org ([80.91.229.3]:58485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955Ab3AHAOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:14:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Subject: 3.2.35 problem with M5A97 PRO ram: bad_page free_pages_prepare mem_init
Date: Tue, 08 Jan 2013 01:13:03 +0100
Organization: tigusoft.pl
Message-ID: <kcfoae$91e$1@ger.gmane.org>
Reply-To: lkml@tigusoft.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: herngaard.torservers.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux kernel
3.2.0-0.bpo.4-rt-amd64 #1 SMP PREEMPT RT Debian 3.2.35-2~bpo60+1 x86_64
GNU/Linux
running on mainboard M5A97 PRO (Version: "0813" Date: "10/24/2011")
with 16 GB RAM (ECC not used)
with AMD Bulldozer CPU,
reports problems same on each boot:

[    0.000000] Pid: 0, comm: swapper Not tainted 3.2.0-0.bpo.4-rt-amd64
#1 Debian 3.2.35-2~bpo60+1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810cb43e>] ? bad_page+0xe8/0xfa
[    0.000000]  [<ffffffff810cb83f>] ? free_pages_prepare+0x9a/0xd3
[    0.000000]  [<ffffffff810cc200>] ? __free_pages_ok+0x1b/0x102
[    0.000000]  [<ffffffff8172185e>] ? free_all_memory_core_early+0xe1/0x144
[    0.000000]  [<ffffffff81716664>] ? numa_free_all_bootmem+0x71/0x7a
[    0.000000]  [<ffffffff81385ae2>] ? bad_to_user+0x65c/0x65c
[    0.000000]  [<ffffffff81714d2d>] ? mem_init+0x19/0xe4
[    0.000000]  [<ffffffff81701a8e>] ? start_kernel+0x1c2/0x3c2
[    0.000000]  [<ffffffff817013c8>] ? x86_64_start_kernel+0x102/0x10f

despite this errors machine runs ok and rather stable.

Is this problem already known?
What can be done to debug it so we can fix it?



cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8120 Eight-Core Processor
stepping	: 2
microcode	: 0x6000613
cpu MHz		: 1400.000
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 16
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes
xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr
topoext perfctr_core arat cpb hw_pstate npt lbrv svm_lock nrip_save
tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 6221.04
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]





wider log:



[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-3.2.0-0.bpo.4-rt-amd64 root=/dev/mapper/md0_crypt ro
quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ f8000000 size 64 MB
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.2.0-0.bpo.4-rt-amd64
#1 Debian 3.2.35-2~bpo60+1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810cb43e>] ? bad_page+0xe8/0xfa
[    0.000000]  [<ffffffff810cb83f>] ? free_pages_prepare+0x9a/0xd3
[    0.000000]  [<ffffffff810cc200>] ? __free_pages_ok+0x1b/0x102
[    0.000000]  [<ffffffff8172185e>] ? free_all_memory_core_early+0xe1/0x144
[    0.000000]  [<ffffffff81716664>] ? numa_free_all_bootmem+0x71/0x7a
[    0.000000]  [<ffffffff81385ae2>] ? bad_to_user+0x65c/0x65c
[    0.000000]  [<ffffffff81714d2d>] ? mem_init+0x19/0xe4
[    0.000000]  [<ffffffff81701a8e>] ? start_kernel+0x1c2/0x3c2
[    0.000000]  [<ffffffff817013c8>] ? x86_64_start_kernel+0x102/0x10f
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Tainted: G    B
3.2.0-0.bpo.4-rt-amd64 #1 Debian 3.2.35-2~bpo60+1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810cb43e>] ? bad_page+0xe8/0xfa
[    0.000000]  [<ffffffff810cb83f>] ? free_pages_prepare+0x9a/0xd3
[    0.000000]  [<ffffffff810cc200>] ? __free_pages_ok+0x1b/0x102
[    0.000000]  [<ffffffff8172185e>] ? free_all_memory_core_early+0xe1/0x144
[    0.000000]  [<ffffffff81716664>] ? numa_free_all_bootmem+0x71/0x7a
[    0.000000]  [<ffffffff81385ae2>] ? bad_to_user+0x65c/0x65c
[    0.000000]  [<ffffffff81714d2d>] ? mem_init+0x19/0xe4
[    0.000000]  [<ffffffff81701a8e>] ? start_kernel+0x1c2/0x3c2
[    0.000000]  [<ffffffff817013c8>] ? x86_64_start_kernel+0x102/0x10f
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Tainted: G    B
3.2.0-0.bpo.4-rt-amd64 #1 Debian 3.2.35-2~bpo60+1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810cb43e>] ? bad_page+0xe8/0xfa
[    0.000000]  [<ffffffff810cb83f>] ? free_pages_prepare+0x9a/0xd3
[    0.000000]  [<ffffffff810cc200>] ? __free_pages_ok+0x1b/0x102
[    0.000000]  [<ffffffff8172185e>] ? free_all_memory_core_early+0xe1/0x144
[    0.000000]  [<ffffffff81716664>] ? numa_free_all_bootmem+0x71/0x7a
[    0.000000]  [<ffffffff81385ae2>] ? bad_to_user+0x65c/0x65c
[    0.000000]  [<ffffffff81714d2d>] ? mem_init+0x19/0xe4
[    0.000000]  [<ffffffff81701a8e>] ? start_kernel+0x1c2/0x3c2
[    0.000000]  [<ffffffff817013c8>] ? x86_64_start_kernel+0x102/0x10f

(repeats around 20 times)

[    0.000000] Memory: 16402260k/17809408k available (3606k kernel code,
1085996k absent, 319616k reserved, 3163k data, 928k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:1288 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled





form hwinfo

  system.board.product = 'M5A97 PRO'
       str1: "ASUSTeK COMPUTER INC."
       str2: "M5A97 PRO"
       str3: "Rev 1.xx"



01: None 00.0: 10105 BIOS
  [Created at bios.190]
  Unique ID: ........................ removed
  Hardware Class: bios
  BIOS Keyboard LED Status:
    Scroll Lock: off
    Num Lock: on
    Caps Lock: off
  Base Memory: 635 kB
  PnP BIOS: @@@0000
  SMBIOS Version: 2.7
  BIOS Info: #0
    Vendor: "American Megatrends Inc."
    Version: "0813"
    Date: "10/24/2011"
    Start Address: 0xf0000
    ROM Size: 4096 kB
    Features: 0x0d03000000053f8b9880



