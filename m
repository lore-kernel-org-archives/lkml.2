Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0IEPxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 11:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab0IEPxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:53:21 -0400
Message-ID: <4C83BCED.6020905@redhat.com>
Date: Sun, 05 Sep 2010 18:53:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: Fix misnamed AMD CPUID feature bit
References: <1283506069-1096-1-git-send-email-andre.przywara@amd.com> <1283506069-1096-2-git-send-email-andre.przywara@amd.com> <4C834FCA.4020207@redhat.com> <4C83B939.60005@amd.com>
In-Reply-To: <4C83B939.60005@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/05/2010 06:37 PM, Andre Przywara wrote:
>>> diff --git a/arch/x86/include/asm/cpufeature.h 
>>> b/arch/x86/include/asm/cpufeature.h
>>> index 781a50b..c9c73d8 100644
>>> --- a/arch/x86/include/asm/cpufeature.h
>>> +++ b/arch/x86/include/asm/cpufeature.h
>>> @@ -152,7 +152,7 @@
>>>   #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch 
>>> instructions */
>>>   #define X86_FEATURE_OSVW    (6*32+ 9) /* OS Visible Workaround */
>>>   #define X86_FEATURE_IBS        (6*32+10) /* Instruction Based 
>>> Sampling */
>>> -#define X86_FEATURE_SSE5    (6*32+11) /* SSE-5 */
>>> +#define X86_FEATURE_XOP        (6*32+11) /* extended AVX 
>>> instructions */
>>>   #define X86_FEATURE_SKINIT    (6*32+12) /* SKINIT/STGI 
>>> instructions */
>>>   #define X86_FEATURE_WDT        (6*32+13) /* Watchdog timer */
>>>   #define X86_FEATURE_NODEID_MSR    (6*32+19) /* NodeId MSR */
>>
>> Even with the -stable update, there may be distributions which have 
>> kernels with the old name.  That means userspace would need to look 
>> for both names if it wants to be sure.
>
> CPUs having XOP will not be available before next year, and since XOP 
> is using the same register set as AVX, it cannot be used without 
> proper XSAVE/XRESTORE support. I am not sure when exactly XSAVE was 
> introduced in the kernel, but I think this limits the usability of 
> older kernels for XOP.
> I see that there is a faint possibility of causing trouble, but I 
> don't see any real alternative.

Perhaps it reduces trouble, since userspace can't conclude anything from 
seeing the sse5 or xop flag.  It needs to use a cpuid osxsave; xgetbv; 
cpuid xop to be sure it can actually use the instructions.

All that remains is user confusion, but I see no real alternative either.

-- 
error compiling committee.c: too many arguments to function

