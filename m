Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030602Ab2AFVN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:13:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12760 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2AFVN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:13:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 06 Jan 2012 13:13:44 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Jan 2012 13:13:08 -0800
Subject: RE: [PATCH v1 0/3] Tegra30 clockframework
Thread-Topic: [PATCH v1 0/3] Tegra30 clockframework
Thread-Index: AczJYcefELP5YqAwS0ipClByKP0MIADVc35w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE39F6B@HQMAIL01.nvidia.com>
References: <1325517486-22458-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1325517486-22458-1-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Monday, January 02, 2012 8:18 AM:
> This patchset introduces the tegra30 clockframework. Clocks which require
> voltage scaling are not included in this version. The implementation doesn't
> use the generic clock code yet. It's the intention to move to it, once the
> semantics are fully clarified.

I tried testing this, and the kernel crashes/hangs as shown below:

[    0.088340] CPU: Testing write buffer coherency: ok
[    0.093638] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.099573] Division by zero in kernel.
[    0.103643] [<c001396c>] (unwind_backtrace+0x0/0x11c) from [<c013c1cc>] (Ldiv0_64+0x8/0x18)
[    0.112332] [<c013c1cc>] (Ldiv0_64+0x8/0x18) from [<c0056754>] (clockevents_config.part.0+0x1c/0x64)
[    0.121810] [<c0056754>] (clockevents_config.part.0+0x1c/0x64) from [<c00569ac>] (clockevents_config_and_register+0x20/0x2c)
[    0.133433] [<c00569ac>] (clockevents_config_and_register+0x20/0x2c) from [<c0280fec>] (twd_timer_setup+0x144/0x190)
[    0.144335] [<c0280fec>] (twd_timer_setup+0x144/0x190) from [<c0281334>] (local_timer_setup+0x10/0x18)
[    0.153986] [<c0281334>] (local_timer_setup+0x10/0x18) from [<c0280c00>] (percpu_timer_setup+0x54/0xa8)
[    0.163727] [<c0280c00>] (percpu_timer_setup+0x54/0xa8) from [<c03904e0>] (smp_prepare_cpus+0x6c/0x90)
[    0.173391] [<c03904e0>] (smp_prepare_cpus+0x6c/0x90) from [<c038d844>] (kernel_init+0x48/0x12c)
[    0.182520] [<c038d844>] (kernel_init+0x48/0x12c) from [<c000ebf4>] (kernel_thread_exit+0x0/0x8)
[    0.191628] ------------[ cut here ]------------
[    0.196454] WARNING: at kernel/time/clockevents.c:46 clockevent_delta2ns+0x3c/0x84()
[    0.204490] Modules linked in:
[    0.207735] [<c001396c>] (unwind_backtrace+0x0/0x11c) from [<c0022284>] (warn_slowpath_common+0x4c/0x64)
[    0.217568] [<c0022284>] (warn_slowpath_common+0x4c/0x64) from [<c00222b4>] (warn_slowpath_null+0x18/0x1c)
[    0.227577] [<c00222b4>] (warn_slowpath_null+0x18/0x1c) from [<c005668c>] (clockevent_delta2ns+0x3c/0x84)
[    0.237497] [<c005668c>] (clockevent_delta2ns+0x3c/0x84) from [<c0056780>] (clockevents_config.part.0+0x48/0x64)
[    0.248040] [<c0056780>] (clockevents_config.part.0+0x48/0x64) from [<c00569ac>] (clockevents_config_and_register+0x20/0x2c)
[    0.259654] [<c00569ac>] (clockevents_config_and_register+0x20/0x2c) from [<c0280fec>] (twd_timer_setup+0x144/0x190)
[    0.270553] [<c0280fec>] (twd_timer_setup+0x144/0x190) from [<c0281334>] (local_timer_setup+0x10/0x18)
[    0.280202] [<c0281334>] (local_timer_setup+0x10/0x18) from [<c0280c00>] (percpu_timer_setup+0x54/0xa8)
[    0.289934] [<c0280c00>] (percpu_timer_setup+0x54/0xa8) from [<c03904e0>] (smp_prepare_cpus+0x6c/0x90)
[    0.299582] [<c03904e0>] (smp_prepare_cpus+0x6c/0x90) from [<c038d844>] (kernel_init+0x48/0x12c)
[    0.308699] [<c038d844>] (kernel_init+0x48/0x12c) from [<c000ebf4>] (kernel_thread_exit+0x0/0x8)
[    0.317830] ---[ end trace 1b75b31a2719ed1c ]---
[    0.322697] Setting up static identity map for 0x8028cf98 - 0x8028cff0
<<no more output>>

Without these patches, the same tree gets all the way to waiting for the
root filesystem:

[    0.088329] CPU: Testing write buffer coherency: ok
[    0.093631] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.099545] smp_twd: clock not found: -2
[    0.103667] Calibrating local timer... 500.06MHz.
[    0.161249] Setting up static identity map for 0x8028a918 - 0x8028a970
[    2.261492] CPU1: failed to come online
[    2.265684] Brought up 1 CPUs
[    2.268813] SMP: Total of 1 processors activated (1987.37 BogoMIPS).
...
[    2.704845] Registering SWP/SWPB emulation handler
[    2.710558] Waiting for root device /dev/mmcblk1p1...

I tested using commit e4421e71fa89bee67d2b67079041ca346ae49ea3 in my
per-user repo on nv-tegra.nvidia.com.

-- 
nvpublic

