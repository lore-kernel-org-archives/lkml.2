Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0JRGpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:45:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:26736 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab0JRGpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:45:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,345,1283756400"; 
   d="scan'208";a="337218913"
From: "Ma, Ling" <ling.ma@intel.com>
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 14:43:32 +0800
Subject: RE: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
Thread-Topic: [PATCH V2 -tip] lib,x86_64: improve the performance of
 memcpy() for unaligned copy
Thread-Index: ActujorqAceOv940QymHLFv/9SlJ9wAAAdBA
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F15D777221E@shsmsx502.ccr.corp.intel.com>
References: <4CAEC81C.1070108@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com>
 <4CAEDE0D.2040009@cn.fujitsu.com> <4CB62543.7000605@zytor.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15CC203E71@shsmsx502.ccr.corp.intel.com>
 <4CBBE7FB.2060303@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15D77721FD@shsmsx502.ccr.corp.intel.com>
 <4CBBEA7F.7010604@cn.fujitsu.com>
In-Reply-To: <4CBBEA7F.7010604@cn.fujitsu.com>
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

"wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm"

rep_good will cause memcpy jump to memcpy_c, so not run this patch, 
we may continue to do further optimization on it later.

BTW the improvement is only from core2 shift register optimization,
but for most previous cpus shift register is very sensitive because of decode stage.
I have test Atom, Opteron, and Nocona, new patch is still better.

Thanks
Ling

-----Original Message-----
From: Miao Xie [mailto:miaox@cn.fujitsu.com] 
Sent: Monday, October 18, 2010 2:35 PM
To: Ma, Ling
Cc: H. Peter Anvin; Ingo Molnar; Andi Kleen; Thomas Gleixner; Zhao, Yakui; Linux Kernel
Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy() for unaligned copy

On Mon, 18 Oct 2010 14:27:40 +0800, Ma, Ling wrote:
> Could please send out cpu info for this cpu model.

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E7300  @ 2.66GHz
stepping	: 6
cpu MHz		: 1603.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips	: 5319.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

Thanks
Miao

>
> Thanks
> Ling
>
> -----Original Message-----
> From: Miao Xie [mailto:miaox@cn.fujitsu.com]
> Sent: Monday, October 18, 2010 2:24 PM
> To: Ma, Ling
> Cc: H. Peter Anvin; Ingo Molnar; Andi Kleen; Thomas Gleixner; Zhao, Yakui; Linux Kernel
> Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy() for unaligned copy
>
> On Fri, 15 Oct 2010 03:43:53 +0800, Ma, Ling wrote:
>> Attachment includes memcpy-kernel.c(cc -O2 memcpy-kernel.c -o
>> memcpy-kernel), and unaligned test cases on Atom.
>
> I have tested on my Core2 Duo machine with your benchmark tool. Attachment is the test result. But the result is different with yours on Atom, It seems the performance is better with this patch.
>
> According to these two different result, maybe we need optimize memcpy() by CPU model.
>
> Thanks
> Miao
>
>>
>> Thanks
>> Ling
>>
>> -----Original Message-----
>> From: Ma, Ling
>> Sent: Thursday, October 14, 2010 9:14 AM
>> To: 'H. Peter Anvin'; miaox@cn.fujitsu.com
>> Cc: Ingo Molnar; Andi Kleen; Thomas Gleixner; Zhao, Yakui; Linux
>> Kernel
>> Subject: RE: [PATCH V2 -tip] lib,x86_64: improve the performance of
>> memcpy() for unaligned copy
>>
>> Sure, I will post benchmark tool and benchmark on Atom 64bit soon.
>>
>> Thanks
>> Ling
>>
>> -----Original Message-----
>> From: H. Peter Anvin [mailto:hpa@zytor.com]
>> Sent: Thursday, October 14, 2010 5:32 AM
>> To: miaox@cn.fujitsu.com
>> Cc: Ma, Ling; Ingo Molnar; Andi Kleen; Thomas Gleixner; Zhao, Yakui;
>> Linux Kernel
>> Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of
>> memcpy() for unaligned copy
>>
>> On 10/08/2010 02:02 AM, Miao Xie wrote:
>>> On Fri, 8 Oct 2010 15:42:45 +0800, Ma, Ling wrote:
>>>> Could you please give us full address for each comparison result,we will do some tests on my machine.
>>>> For unaligned cases older cpus will crossing cache line and slow down caused by load and store, but for nhm, no necessary to care about it.
>>>> By the way in kernel 64bit mode, our access mode should be around 8byte aligned.
>>>
>>> Would you need my benchmark tool? I think it is helpful for your test.
>>>
>>
>> If you could post the benchmark tool that would be great.
>>
>> 	-hpa
>
>
>

