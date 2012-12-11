Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2LKVD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:03:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50882 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2LKVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:03:56 -0500
Date: Tue, 11 Dec 2012 19:03:51 -0200
From: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier 
	<fredlwm@fredlwm.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup with 3.7.0 but not 3.6.10
Message-ID: <20121211210351.GB19943@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 20:16:47, Borislav Petkov wrote:
> What family is that? Can you give /proc/cpuinfo?

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4000+
stepping	: 1
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch lbrv
bogomips	: 2004.56
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4000+
stepping	: 1
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch lbrv
bogomips	: 2004.56
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

>> Dec 11 16:02:15 pervalidus kernel: [11260.096015] BUG: soft lockup - 
>> CPU#1 stuck for 22s! [cc1:20906]
>
> Hmm, this says that gcc gets stuck at some point. Is this always 
> reproducible on 3.7?

It always happens when I compile MPlayer. It was always cc1, but yasm 
once.

>> What about using another version of gcc, can you repro it then too?
>>
>> It would be interesting to know where all those cc1 processes get 
>> stuck.
>> Can you break into them with gdb and dump the code around RIP 
>> everytime those tasks gets stuck? Try doing a couple of them to see 
>> whether it is repeatable.

I'll see what I can do. I'm compiling with -j3, so it's hard to see 
before the kernel reports it.
