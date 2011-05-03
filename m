Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1ECWDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:03:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40864 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1ECWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:03:00 -0400
Message-ID: <4DC07B4F.4040509@zytor.com>
Date: Tue, 03 May 2011 15:01:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, werner <w.landgraf@ru.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <4DC06386.8090206@zytor.com> <20110503205051.GA28647@elte.hu> <BANLkTin0QqwmOw2xYic0MVgvm4Rk13-yHQ@mail.gmail.com>
In-Reply-To: <BANLkTin0QqwmOw2xYic0MVgvm4Rk13-yHQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 02:45 PM, Linus Torvalds wrote:
> On Tue, May 3, 2011 at 1:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> the ELAN .config option influences the following details:
>>
>>  - sets X86_L1_CACHE_SHIFT to 4 (16 bytes) instead of the typical 6 (64 bytes)
>>  - sets X86_ALIGNMENT_16
>>  - sets the -march=i486 compiler flag
> 
> It also does this to the config diff:
> 
>   306,307c328,332
>   < CONFIG_X86_ALIGNMENT_16=y
>   < CONFIG_X86_MINIMUM_CPU_FAMILY=4
>   ---
>   > CONFIG_X86_USE_PPRO_CHECKSUM=y
>   > CONFIG_X86_TSC=y
>   > CONFIG_X86_CMPXCHG64=y
>   > CONFIG_X86_CMOV=y
>   > CONFIG_X86_MINIMUM_CPU_FAMILY=5
> 
> because of all the indirect changes it causes.
> 
> Now, Werner is actually _running_ on an AMD Opteron (or whatever
> family 15 is), I think. And his kernel is SMP-enabled. And that whole
> thin looks really really iffy.
> 
> How/why do we even allow that combination of SMP and (for example)
> arch/x86/lib/atomic64_386_32.S to be picked?
> 
> I don't think he actually runs SMP, but the fact that we even allow
> that combination looks really odd/iffy. Am I missing something?
> 

We would end up in those paths before alternatives are run, but
alternatives should be run before we start the second processor.

	-hpa
