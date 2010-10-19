Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0JSBTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:19:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52672 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0JSBTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fUsVzb2/bY2Gh7fCJS7p9Cr3cCU2EvcHGQitjv+RjH2YliQve35mggS1uYBpJpx9AF
         TVR/m2k1iFrXD9tgz//lY9M8z2Ye6R9lsP4FDQooh0R5GnXtyo7BuigoS/83VW2Oj9XT
         mQaaOyU3AZq0f3ITs2k2sVzRyrinPCpef7mco=
MIME-Version: 1.0
In-Reply-To: <4CBC964B.6000605@zytor.com>
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
	<4CBAE8E2.1060704@redhat.com>
	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
	<4CBBF3C8.9070104@web.de>
	<4CBC1047.6010501@redhat.com>
	<20101018125803.GA2497@darkstar>
	<4CBC4B06.3030300@redhat.com>
	<20101018134508.GA11885@darkstar>
	<4CBC4FA9.90406@redhat.com>
	<4CBC5097.1020105@redhat.com>
	<20101018135813.GA20316@darkstar>
	<4CBC547A.8080700@redhat.com>
	<4CBC964B.6000605@zytor.com>
Date: Tue, 19 Oct 2010 09:19:40 +0800
Message-ID: <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com>
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Dave Young <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 2:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/18/2010 07:06 AM, Avi Kivity wrote:
>>   On 10/18/2010 03:58 PM, Dave Young wrote:
>>>>
>>>>  Please patch hardware_setup() to show the value of
>>>>  boot_cpu_has(X86_FEATURE_NX).
>>>
>>> It's 0
>>
>> Well, that's ridiculous.  Looking back at your /proc/cpuinfo:
>>
>>> processor    : 0
>>> flags                : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
>>>
>>> processor    : 1
>>> flags                : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
>>
>> processor 0 doesn't have nx.
>>
>> Ingo, Peter, any ideas?  Where did the missing feature go?
>>
>
> I don't see the original report -- in particular I can't see the kernel
> version -- but I suspect this *might* be an instance of the same bug
> fixed in mainline by checkin d900329e20f4476db6461752accebcf7935a8055
> (for backporting 1dedefd1a066a795a87afca9c0236e1a94de9bf6 is also
> needed; these both should be in -stable or on the way there.)

The kernel is git version after 2.6.36-rc8, so I think the commits
don't fix this problem.
-- 
Regards
dave
