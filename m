Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1LCUnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 15:43:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61868 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1LCUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 15:43:33 -0500
Message-ID: <4EDA89F2.9070107@lwfinger.net>
Date: Sat, 03 Dec 2011 14:43:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
References: <4ED5B70F.606@lwfinger.net> <4ED5C640.8030102@linux.vnet.ibm.com> <4ED5D6C5.5050704@lwfinger.net>
In-Reply-To: <4ED5D6C5.5050704@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 01:09 AM, Larry Finger wrote:
> On 11/29/2011 11:59 PM, Srivatsa S. Bhat wrote:
>> On 11/30/2011 10:24 AM, Larry Finger wrote:
>>
>>> I have an ancient laptop with an AMD-K6 CPU that freezes on boot with
>>> 3.2-rc2. The problem was bisected to commit bcb80e53877c2.
>>>
>>> The cpuinfo for this box is:
>>>
>>>>> cpu.1: cpuinfo
>>> ----- /proc/cpuinfo -----
>>> processor : 0
>>> vendor_id : AuthenticAMD
>>> cpu family : 5
>>> model : 8
>>> model name : AMD-K6(tm) 3D processor
>>> stepping : 12
>>> cpu MHz : 428.804
>>> cache size : 64 KB
>>> fdiv_bug : no
>>> hlt_bug : no
>>> f00f_bug : no
>>> coma_bug : no
>>> fpu : yes
>>> fpu_exception : yes
>>> cpuid level : 1
>>> wp : yes
>>> flags : fpu vme de pse tsc msr cx8 pge mmx syscall 3dnow
>>> k6_mtrr up
>>> bogomips : 857.60
>>> clflush size : 32
>>> cache_alignment : 32
>>> address sizes : 32 bits physical, 32 bits virtual
>>> power management:
>>>
>>> ----- /proc/cpuinfo end -----
>>>
>>> This patch is quite simple, thus it appears that rdmsr() is OK, but that
>>> rdmsr_safe() is not.
>>>
>>> I am happy to provide any other info regarding this box.
>>>
>>
>>
>> Hi Larry,
>>
>> Can you please try out the patch posted in
>> https://lkml.org/lkml/2011/11/28/178 ?
>>
>> This patch will be available in mainline kernel from -rc4.
>> https://lkml.org/lkml/2011/11/28/457
>
> Srivatsa,
>
> Thanks for the reference. That patch does fix my problem. Too bad that the bad
> commit was not in the subject of that other thread so that I could have found it
> with Google.

Borislav,

I just updated mainline to 3.2-rc4, and that patch is not included. Please check 
with Ingo to see why it was not available. It is a real show stopper for old AMD 
CPUs.

Thanks,

Larry

