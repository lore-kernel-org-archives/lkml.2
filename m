Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1B1RQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:16:07 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:39551 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1B1RQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:16:05 -0500
Date: Mon, 28 Feb 2011 18:15:50 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110228171550.GA2173@nik-comp.lan>
References: <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BC5CA.8060004@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4671745 records (last update: 20110228)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend, sorry for the mess)
> cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		  : 30
model name	  : Intel(R) Xeon(R) CPU           X3440  @ 2.53GHz
stepping	  : 5
cpu MHz		    : 2533.185
cache size	    : 8192 KB
physical id	    : 0
siblings : 8
core id	   : 0
cpu cores  : 4
apicid	     : 0
initial apicid : 0
fpu	       : yes
fpu_exception  : yes
cpuid level    : 11
wp    	       : yes
flags	       	 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca c=
mov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rd=
tscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_=
tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pd=
cm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vp=
id
bogomips	 : 5066.37
clflush size	 : 64
cache_alignment	 : 64
address sizes	 : 36 bits physical, 48 bits virtual
power management:
.
.
.
.
processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		  : 30
model name	  : Intel(R) Xeon(R) CPU           X3440  @ 2.53GHz
stepping	  : 5
cpu MHz		    : 2533.185
cache size	    : 8192 KB
physical id	    : 0
siblings : 8
core id	   : 3
cpu cores  : 4
apicid	     : 7
initial apicid : 7
fpu	       : yes
fpu_exception  : yes
cpuid level    : 11
wp    	       : yes
flags	       	 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca c=
mov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rd=
tscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_=
tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pd=
cm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vp=
id
bogomips	 : 5066.35
clflush size	 : 64
cache_alignment	 : 64
address sizes	 : 36 bits physical, 48 bits virtual
power management:


> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
[root@vbox5 ~]# cat /sys/devices/system/clocksource/clocksource0/current_cl=
ocksource
tsc


>
> and grep -i dmesg for these keywords: TSC, clock, hpet, stable, khz, kvm
[root@vbox5 ~]# dmesg | grep -i "tsc\|clock\|hpet\|stable\|stable\|khz\|kvm"
[    0.000000] ACPI: HPET 00000000bf7aa5f0 00038 (v01 052710 OEMHPET  20100=
527 MSFT 00000097)
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    1.148829] HPET: 8 timers in total, 5 timers will be used for per-cpu t=
imer
[    1.148934] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    1.149331] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.151831] hpet: hpet2 irq 40 for MSI
[    1.151962] hpet: hpet3 irq 41 for MSI
[    1.155930] hpet: hpet4 irq 42 for MSI
[    1.159937] hpet: hpet5 irq 43 for MSI
[    1.163943] hpet: hpet6 irq 44 for MSI
[    1.175955] Switching to clocksource tsc
[    1.260015] CE: hpet3 increased min_delta_ns to 7500 nsec
[    1.260117] CE: hpet3 increased min_delta_ns to 11250 nsec
[    1.294150] Real Time Clock Driver v1.12b
[    7.564355] CE: hpet4 increased min_delta_ns to 7500 nsec
[    7.564367] CE: hpet4 increased min_delta_ns to 11250 nsec
[  299.307242] CE: hpet2 increased min_delta_ns to 7500 nsec
[  299.307251] CE: hpet2 increased min_delta_ns to 11250 nsec
[ 1414.616685] CE: hpet5 increased min_delta_ns to 7500 nsec
[ 1414.616694] CE: hpet5 increased min_delta_ns to 11250 nsec
[ 5241.474310] CE: hpet6 increased min_delta_ns to 7500 nsec
[ 5241.474321] CE: hpet6 increased min_delta_ns to 11250 nsec


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
