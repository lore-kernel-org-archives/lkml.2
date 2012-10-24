Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422810Ab2JXWr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:47:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46159 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238Ab2JXWr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:47:26 -0400
Message-ID: <50886FFB.8070802@gmail.com>
Date: Wed, 24 Oct 2012 15:47:23 -0700
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/16] math128, x86_64: Implement {mul,add}_u128 in 64bit
 asm
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com> <1351115634-8420-3-git-send-email-juri.lelli@gmail.com> <50886B43.3080001@zytor.com>
In-Reply-To: <50886B43.3080001@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 03:27 PM, H. Peter Anvin wrote:
> On 10/24/2012 02:53 PM, Juri Lelli wrote:
>> diff --git a/arch/x86/include/asm/math128.h b/arch/x86/include/asm/math128.h
>> new file mode 100644
>> index 0000000..c0e2a6c
>> --- /dev/null
>> +++ b/arch/x86/include/asm/math128.h
>> @@ -0,0 +1,39 @@
>> +#ifndef _ASM_MATH128_H
>> +#define _ASM_MATH128_H
>> +
>> +#ifdef CONFIG_X86_64
>> +
>> +#ifdef __SIZEOF_INT128__
>> +#define ARCH_HAS_INT128
>> +#endif
>> +
>> +#ifndef ARCH_HAS_INT128
>> +
>> +static inline u128 mul_u64_u64(u64 a, u64 b)
>> +{
>> +       u128 res;
>> +
>> +       asm("mulq %2"
>> +               : "=a" (res.lo), "=d" (res.hi)
>> +               :  "rm" (b), "0" (a));
>> +
>> +       return res;
>> +}
>> +#define mul_u64_u64 mul_u64_u64
>> +
>> +static inline u128 add_u128(u128 a, u128 b)
>> +{
>> +       u128 res;
>> +
>> +       asm("addq %2,%0;\n"
>> +           "adcq %3,%1;\n"
>> +               : "=rm" (res.lo), "=rm" (res.hi)
>> +               : "r" (b.lo), "r" (b.hi), "0" (a.lo), "1" (a.hi));
>> +
>> +       return res;
>> +}
>> +#define add_u128 add_u128
>> +
>
> How could this work since u128 presumably has not yet been defined as a
> structure?  After all, isn't it the absence of ARCH_HAS_INT128 which
> makes that happen?

Sorry, you were not in the Cc list of the previous patch in the patchset,
so you probably missed that. I should have triple checked git send-email
Cc list. Sorry about that.

I'll add you there.

Thanks and Regards,

- Juri
