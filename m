Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2CFQIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:08:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab2CFQIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:08:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com>
	<CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 06 Mar 2012 11:08:43 -0500
In-Reply-To: <CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com>
	(Sasha Levin's message of "Tue, 6 Mar 2012 17:17:55 +0200")
Message-ID: <x49r4x5hfuc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On Tue, Mar 6, 2012 at 4:59 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> When booting my machine with maxcpus=1, it seems to be ignored with
>> 3.3.0-rc3.  I know that 3.1.0-rc3 works fine, but I haven't had time to
>> track it down any further than that.  I've attached the dmesg from my
>> machine.  Let me know if there is any other information that would help
>> in solving this.
>
> [snip]
>
>> Brought up 1 CPUs
>> Total of 1 processors activated (4256.06 BogoMIPS).
>
> Looks like it indeed brings up only one CPU, what's the problem there?

Sorry, here's (what I perceive to be) the problem:

[root@metallica ~]# uname -r
3.3.0-rc3+
[root@metallica ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model             : 15
model name        : Intel(R) Xeon(R) CPU           X3210  @ 2.13GHz
stepping          : 11
microcode         : 0xb3
cpu MHz             : 1600.002
cache size          : 4096 KB
physical id         : 0
siblings : 4
core id    : 0
cpu cores  : 4
apicid       : 0
initial apicid : 0
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags            : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
lahf_lm dts tpr_shadow vnmi flexpriority
bogomips    : 4256.06
clflush size  : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model             : 15
model name        : Intel(R) Xeon(R) CPU           X3210  @ 2.13GHz
stepping          : 11
microcode         : 0xb3
cpu MHz             : 1600.002
cache size          : 4096 KB
physical id         : 0
siblings : 4
core id    : 2
cpu cores  : 4
apicid       : 2
initial apicid : 2
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags            : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
lahf_lm dts tpr_shadow vnmi flexpriority
bogomips    : 4256.06
clflush size  : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model             : 15
model name        : Intel(R) Xeon(R) CPU           X3210  @ 2.13GHz
stepping          : 11
microcode         : 0xb3
cpu MHz             : 1600.002
cache size          : 4096 KB
physical id         : 0
siblings : 4
core id    : 1
cpu cores  : 4
apicid       : 1
initial apicid : 1
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags            : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
lahf_lm dts tpr_shadow vnmi flexpriority
bogomips    : 4256.06
clflush size  : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model             : 15
model name        : Intel(R) Xeon(R) CPU           X3210  @ 2.13GHz
stepping          : 11
microcode         : 0xb3
cpu MHz             : 1600.002
cache size          : 4096 KB
physical id         : 0
siblings : 4
core id    : 3
cpu cores  : 4
apicid       : 3
initial apicid : 3
fpu            : yes
fpu_exception  : yes
cpuid level    : 10
wp             : yes
flags            : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
lahf_lm dts tpr_shadow vnmi flexpriority
bogomips    : 4256.06
clflush size  : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

Cheers,
Jeff
