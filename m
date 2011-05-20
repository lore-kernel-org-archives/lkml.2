Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab1ETNNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1ETNNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:13:47 -0400
Message-ID: <4DD6690A.4020704@redhat.com>
Date: Fri, 20 May 2011 15:13:46 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc16 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: mhiramat@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/trace/ftrace.c:1007
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've recompiled today 2.6.39 kernel - and this warning now appears in the
dmesg.log:

I'm using T61, C2D, 4G,  x86-64 kernel with ftrace support compiled in.

[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.744 MHz processor.
[    0.006670] Calibrating delay loop (skipped), value calculated using timer
frequency.. 4391.38 BogoMIPS (lpj=7315
813)
[    0.013340] pid_max: default: 32768 minimum: 301
[    0.016751] Security Framework initialized
[    0.020013] SELinux:  Disabled at boot.
[    0.023364] Mount-cache hash table entries: 256
[    0.030572] Initializing cgroup subsys ns
[    0.033341] ns_cgroup deprecated: consider using the 'clone_children' flag
without the ns_cgroup.
[    0.036673] Initializing cgroup subsys cpuacct
[    0.040015] Initializing cgroup subsys devices
[    0.043337] Initializing cgroup subsys freezer
[    0.046733] CPU: Physical Processor ID: 0
[    0.050005] CPU: Processor Core ID: 0
[    0.053338] mce: CPU supports 6 MCE banks
[    0.056676] CPU0: Thermal monitoring enabled (TM2)
[    0.060006] using mwait in idle threads.
[    0.063408] ACPI: Core revision 20110316
[    0.100021] ftrace: allocating 16635 entries in 66 pages
[    0.106426] ------------[ cut here ]------------
[    0.106660] WARNING: at kernel/trace/ftrace.c:1007 ftrace_bug+0x26c/0x2c0()
[    0.106660] Hardware name: 6464CTO
[    0.106660] Modules linked in:
[    0.106660] Pid: 0, comm: swapper Not tainted 2.6.39-00006-g10d1a81 #16
[    0.106660] Call Trace:
[    0.106660]  [<ffffffff8105033f>] warn_slowpath_common+0x7f/0xc0
[    0.106660]  [<ffffffff81294bd3>] ? inat_get_avx_attribute+0x3/0x50
[    0.106660]  [<ffffffff81294bd3>] ? inat_get_avx_attribute+0x3/0x50
[    0.106660]  [<ffffffff8105039a>] warn_slowpath_null+0x1a/0x20
[    0.106660]  [<ffffffff810cf5dc>] ftrace_bug+0x26c/0x2c0
[    0.106660]  [<ffffffff81294bd3>] ? inat_get_avx_attribute+0x3/0x50
[    0.106660]  [<ffffffff810cf92a>] ftrace_process_locs+0x1da/0x2f0
[    0.106660]  [<ffffffff81a84fe9>] ftrace_init+0x18e/0x1b2
[    0.106660]  [<ffffffff81306d47>] ? acpi_enable_subsystem+0x68/0x143
[    0.106660]  [<ffffffff81a6eb89>] start_kernel+0x38d/0x39d
[    0.106660]  [<ffffffff81a6e322>] x86_64_start_reservations+0x132/0x136
[    0.106660]  [<ffffffff81a6e416>] x86_64_start_kernel+0xf0/0xf7
[    0.106660] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.106660] ftrace failed to modify [<ffffffff81294bd3>]
inat_get_avx_attribute+0x3/0x50
[    0.106660]  actual: e5:e8:a7:9f:20
[    0.106834] Setting APIC routing to flat
[    0.110523] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.149646] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
[    0.159990] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.163327] PEBS disabled due to CPU errata.


Zdenek

