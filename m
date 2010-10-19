Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab0JSGz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:55:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62605 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab0JSGz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HMDYM8N5G1uOX9x5Ez+1xlxj1L/wbFq2d4tTKemUhobGNuS63TGa77aqfiTVrmvZcF
         HiQO89UJi9xl0sk0SQHo0cIvO5AQtIRJuTOGF43HoLyxcWGzXjMN83E43EeWqbDGZxKm
         zzOmrSEoyFfAV9pyQxr4eAlw5yDmyJ5gGkMWY=
MIME-Version: 1.0
In-Reply-To: <4CBD099D.2060500@zytor.com>
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
	<AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com>
	<4CBD099D.2060500@zytor.com>
Date: Tue, 19 Oct 2010 14:55:24 +0800
Message-ID: <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com>
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

On Tue, Oct 19, 2010 at 10:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/18/2010 06:19 PM, Dave Young wrote:
>> On Tue, Oct 19, 2010 at 2:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 10/18/2010 07:06 AM, Avi Kivity wrote:
>>>>   On 10/18/2010 03:58 PM, Dave Young wrote:
>>>>>>
>>>>>>  Please patch hardware_setup() to show the value of
>>>>>>  boot_cpu_has(X86_FEATURE_NX).
>>>>>
>>>>> It's 0
>>>>
>>>> Well, that's ridiculous.  Looking back at your /proc/cpuinfo:
>>>>
>>>>> processor    : 0
>>>>> flags                : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
>>>>>
>>>>> processor    : 1
>>>>> flags                : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
>>>>
>>>> processor 0 doesn't have nx.
>>>>
>>>> Ingo, Peter, any ideas?  Where did the missing feature go?
>>>>
>>>
>>> I don't see the original report -- in particular I can't see the kernel
>>> version -- but I suspect this *might* be an instance of the same bug
>>> fixed in mainline by checkin d900329e20f4476db6461752accebcf7935a8055
>>> (for backporting 1dedefd1a066a795a87afca9c0236e1a94de9bf6 is also
>>> needed; these both should be in -stable or on the way there.)
>>
>> The kernel is git version after 2.6.36-rc8, so I think the commits
>> don't fix this problem.
>
> OK.  Please install msr-tools on your system, and give us the outputs of:
>
> rdmsr -p 0 -xc 0x1a0
0x1764952489

> rdmsr -p 1 -xc 0x1a0
0x1364952489

-- 
Regards
dave
