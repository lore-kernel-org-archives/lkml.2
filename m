Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0JSDAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:00:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45466 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0JSDAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:00:00 -0400
Message-ID: <4CBD099D.2060500@zytor.com>
Date: Mon, 18 Oct 2010 19:59:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>	<4CBAE8E2.1060704@redhat.com>	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>	<4CBBF3C8.9070104@web.de>	<4CBC1047.6010501@redhat.com>	<20101018125803.GA2497@darkstar>	<4CBC4B06.3030300@redhat.com>	<20101018134508.GA11885@darkstar>	<4CBC4FA9.90406@redhat.com>	<4CBC5097.1020105@redhat.com>	<20101018135813.GA20316@darkstar>	<4CBC547A.8080700@redhat.com>	<4CBC964B.6000605@zytor.com> <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com>
In-Reply-To: <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 06:19 PM, Dave Young wrote:
> On Tue, Oct 19, 2010 at 2:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 10/18/2010 07:06 AM, Avi Kivity wrote:
>>>   On 10/18/2010 03:58 PM, Dave Young wrote:
>>>>>
>>>>>  Please patch hardware_setup() to show the value of
>>>>>  boot_cpu_has(X86_FEATURE_NX).
>>>>
>>>> It's 0
>>>
>>> Well, that's ridiculous.  Looking back at your /proc/cpuinfo:
>>>
>>>> processor    : 0
>>>> flags                : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
>>>>
>>>> processor    : 1
>>>> flags                : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
>>>
>>> processor 0 doesn't have nx.
>>>
>>> Ingo, Peter, any ideas?  Where did the missing feature go?
>>>
>>
>> I don't see the original report -- in particular I can't see the kernel
>> version -- but I suspect this *might* be an instance of the same bug
>> fixed in mainline by checkin d900329e20f4476db6461752accebcf7935a8055
>> (for backporting 1dedefd1a066a795a87afca9c0236e1a94de9bf6 is also
>> needed; these both should be in -stable or on the way there.)
> 
> The kernel is git version after 2.6.36-rc8, so I think the commits
> don't fix this problem.

OK.  Please install msr-tools on your system, and give us the outputs of:

rdmsr -p 0 -xc 0x1a0
rdmsr -p 1 -xc 0x1a0

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

