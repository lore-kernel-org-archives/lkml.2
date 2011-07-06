Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1GFVYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:24:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48535 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab1GFVX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:23:59 -0400
Date: Wed, 6 Jul 2011 14:23:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110706212348.GO6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:10:16PM +0100, julie Sullivan wrote:
> None of my kernels after 3.0-rc3 will boot on my Dell XPS-M1730
> (x86-64 2-core) test box running
> Ubuntu (Kubuntu) 11.04 (i.e. the first unbootable one was -rc4).
> The machine freezes immediately after selecting the kernel from the
> bootloader menu, leaving
> me with a blank blue screen so I can't give you any log messages.
> 
> It bisects to the following commit:
> 
> commit a46e0899eec7a3069bcadd45dfba7bf67c6ed016
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Wed Jun 15 15:47:09 2011 -0700
> 
>     rcu: use softirq instead of kthreads except when RCU_BOOST=y
> 
>     This patch #ifdefs RCU kthreads out of the kernel unless RCU_BOOST=y,
>     thus eliminating context-switch overhead if RCU priority boosting has
>     not been configured.
> 
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I've tried cherry-picking onto good/reverting from bad but I don't
> know what to do with the merge
> conflicts, somebody who knows the code/design needs to look really.
> There are more changes than a
> couple of simple #ifdefs.

Hello, Julie,

One approach would be to cherry-pick the following commits:

f8b7fc6b514f34a51875dd48dff70d4d17a54f38 rcu: Move RCU_BOOST #ifdefs to header f
a46e0899eec7a3069bcadd45dfba7bf67c6ed016 rcu: use softirq instead of kthreads ex
09223371deac67d08ca0b70bd18787920284c967 rcu: Use softirq to address performance
9a432736904d386cda28b987b38ba14dae960ecc rcu: Simplify curing of load woes

Another approach would be to move ahead to v3.0-rc4 or later.

							Thanx, Paul

> Let me know if you need any further info.
> 
> The config of the bad kernel will follow in next email, while you're
> waiting here's some nice
> environment info from a good kernel bisected nearest to the offending
> commit for you to enjoy
> looking at :-)
> 
> ----------
> ver_linux:
> Linux julie-MXG071 3.0.0-rc2-bisect-8+ #11 SMP Tue Jul 5 20:50:02 BST
> 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> Gnu C                  4.5.2
> Gnu make               3.81
> binutils               2.21.0.20110327
> util-linux             2.17.2
> mount                  support
> module-init-tools      3.12
> e2fsprogs              1.41.14
> pcmciautils            015
> Linux C Library        2.13
> Dynamic linker (ldd)   2.13
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.15
> Sh-utils               8.5
> wireless-tools         30
> Modules Loaded         nouveau uvcvideo r852 sm_common videodev
> iwl4965 nand nand_ids dell_wmi sdhci_pci sdhci nand_ecc firewire_ohci
> mtd dell_laptop v4l2_compat_ioctl32 mmc_core firewire_core ttm
> iwl_legacy drm_kms_helper mxm_wmi intel_agp intel_gtt
> 
> ------------------
> cat /proc/cpuinfo:
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz
> stepping        : 6
> cpu MHz         : 2401.000
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
> aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
> sse4_1 lahf_lm ida dts tpr_shadow vnmi flexpriority
> bogomips        : 4787.29
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz
> stepping        : 6
> cpu MHz         : 800.000
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> apicid          : 1
> initial apicid  : 1
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
> aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
> sse4_1 lahf_lm ida dts tpr_shadow vnmi flexpriority
> bogomips        : 4787.46
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> ------------------
> cat /proc/modules:
> nouveau 555654 2 - Live 0xffffffffa0124000
> uvcvideo 56906 0 - Live 0xffffffffa0115000
> r852 10128 0 - Live 0xffffffffa0058000
> sm_common 7684 1 r852, Live 0xffffffffa002e000
> videodev 73451 1 uvcvideo, Live 0xffffffffa0102000
> iwl4965 155443 0 - Live 0xffffffffa00db000
> nand 41249 2 r852,sm_common, Live 0xffffffffa006d000
> nand_ids 5858 1 nand, Live 0xffffffffa0017000
> dell_wmi 1625 0 - Live 0xffffffffa0010000
> sdhci_pci 8832 0 - Live 0xffffffffa002a000
> sdhci 22896 1 sdhci_pci, Live 0xffffffffa0023000
> nand_ecc 3888 1 nand, Live 0xffffffffa0009000
> firewire_ohci 26259 0 - Live 0xffffffffa00d3000
> mtd 28256 2 sm_common,nand, Live 0xffffffffa00c7000
> dell_laptop 8899 0 - Live 0xffffffffa00c0000
> v4l2_compat_ioctl32 7213 1 videodev, Live 0xffffffffa00bb000
> mmc_core 76861 1 sdhci, Live 0xffffffffa009f000
> firewire_core 51699 1 firewire_ohci, Live 0xffffffffa008b000
> ttm 58297 1 nouveau, Live 0xffffffffa005d000
> iwl_legacy 122602 1 iwl4965, Live 0xffffffffa0033000
> drm_kms_helper 26926 1 nouveau, Live 0xffffffffa001b000
> mxm_wmi 1695 1 nouveau, Live 0xffffffffa0013000
> intel_agp 11475 0 - Live 0xffffffffa000c000
> intel_gtt 14036 1 intel_agp, Live 0xffffffffa0004000
