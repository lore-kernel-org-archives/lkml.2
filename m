Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0FAMoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:44:23 -0400
Received: from 00544.static.corbina.ru ([85.21.143.29]:34379 "EHLO
	void-ptr.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab0FAMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:44:21 -0400
X-Greylist: delayed 1270 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 08:44:21 EDT
From: Petr Ovtchenkov <ptr@void-ptr.info>
To: linux-kernel@vger.kernel.org
Subject: constant half-byte from /proc/sys/kernel/random/uuid
Date: Tue, 1 Jun 2010 16:22:58 +0400
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006011622.58834.ptr@void-ptr.info>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lack of randomness during generating uuid.

Sample:

for i in 1 2 3 4 5 6 7 8 9; do cat /proc/sys/kernel/random/uuid ; done

3faf5c7e-5e1b-4b3c-a318-979653d85404
a929d2d3-e229-42ca-9f33-9c09801f41fb
c2a96cb6-0dba-401c-a9c6-dabe1dec89d6
df341de3-eb97-4327-bb63-46afd8dbfaa8
9d84d61c-0c55-4914-8bd6-7f1601110908
6d82e69b-418e-4189-b5a4-0661b6e24dcf
eb38de66-4e0b-4bd0-827b-e75ba273e85a
5585c367-754f-4bbf-81f6-8a728380860d
c074480b-ad5c-4e10-81d2-82225c449b91


See on 7th high half-byte: it '4' in
all cases---4b, 42, 40, 43, 49, 41,
4b, 4b, 4e. Checked three comps, with
similar results. All Linux-generated UUID (boot_id)
that I see in internet has '4' in this
half-byte.


cat /proc/version
Linux version 2.6.27.15 (yeti@peak) (gcc version 4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)) #1 SMP Thu Feb 12 17:28:11 MSK 2009

or

Linux version 2.6.27.21 (ptr@localhost) (gcc version 4.2.4) #6 SMP Sat Apr 25 00:29:08 MSD 2009

or

Linux version 2.6.33-ARCH (thomas@evey) (gcc version 4.5.0 (GCC) ) #1 SMP PREEMPT Thu May 13 12:06:25 CEST 2010

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2400.000
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4799.97
clflush size    : 64
power management:
...

or

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping        : 2
cpu MHz         : 2204.555
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 4409.11
clflush size    : 64
power management: ts fid vid ttp tm stc

...

or
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping        : 6
cpu MHz         : 1995.264
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 3992.80
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

