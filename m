Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2EEHfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 03:35:05 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:60717 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab2EEHe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 03:34:56 -0400
Message-ID: <4FA4D81E.1010008@msgid.tls.msk.ru>
Date: Sat, 05 May 2012 11:34:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Len Brown <len.brown@intel.com>
Subject: cpuidle or cpufreq support for Intel CedarTrail Atom CPUs?
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Is there any support in recent kernels to enable
cpufreq (if it is supported to start with, I don't know)
and/or cpuidle for recent line of Intel CedarTrail Atom
processors, like D2500, D2700, N2800 etc?

When booting linux on one of these, cpufreq isn't available,
and kernel mentions cpuidle in dmesg this way:

$ dmesg | grep idle
[    0.001139] using mwait in idle threads.
[    0.767612] intel_idle: MWAIT substates: 0x10
[    0.767617] intel_idle: does not run on family 6 model 54
[    1.231131] cpuidle: using governor ladder
[    1.231173] cpuidle: using governor menu

Should I be concerned somehow that intel_idle does not
run on this CPU?

In kernel source, drivers/idle/intel_idle.c, I see a
table, intel_idle_ids[], which mentions atom cpu with
model = 0x1c and also "lincroft" cpu (model = 0x26).
Should 0x36 (54) be in this table too?

Here's the cpuinfo (for just one core, for another it
is, obviously, identical):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 54
model name	: Intel(R) Atom(TM) CPU D2500   @ 1.86GHz
stepping	: 1
cpu MHz		: 1866.588
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm arat dts
bogomips	: 3734.72
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

Thanks,

/mjt
