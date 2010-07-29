Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0G2CzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 22:55:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0G2CzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 22:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e+hr6h0nF9lwTsJJNNnZNxaLreR9fOBpKbXBMDqFcNQ1IZMC5CdVgwOiAgs1/jRW5M
         6IR7jc2BVRD4B+ncYbo3IQu0EWc22l0fp8BpQDl0Mr2mZoGGv1TkNZxjzD6wSVGjv5G+
         4ys6KCU0P0Pga9G5ho/ylNJL+YYFuKyK7ow8s=
Date: Thu, 29 Jul 2010 04:55:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: DDD <dongdong.deng@windriver.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [GIT PULL] kgdb regression fixes for
	2.6.35-rc5
Message-ID: <20100729025509.GE13088@nowhere>
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com> <20100728211725.GF5394@nowhere> <AANLkTikXGm0WK+N=YMWJc+hBgVAyLc0adu4K1iX5UMW=@mail.gmail.com> <4C50C7F2.8020305@windriver.com> <20100729010607.GB13088@nowhere> <4C50EC4E.6090004@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C50EC4E.6090004@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 10:49:50AM +0800, DDD wrote:
> Frederic Weisbecker wrote:
>> On Wed, Jul 28, 2010 at 07:14:42PM -0500, Jason Wessel wrote:
>>> On 07/28/2010 04:26 PM, Linus Torvalds wrote:
>>>> On Wed, Jul 28, 2010 at 2:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>>> I'm sorry I spot it a bit late.
>>>>> There is a little issue in this patch, irqs won't
>>>>> be restored:
>>>>>
>>>>> @@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
>>>>>        if (!kgdb_io_module_registered)
>>>>>                return NOTIFY_DONE;
>>>>>
>>>>> +       local_irq_save(flags);
>>>>>        return __kgdb_notify(&args, cmd);
>>>>> +       local_irq_restore(flags);
>>>>>  }
>>>> Yeah, that's obviously crap. I also wonder why __kgdb_notify messes up
>>>> the flags to begin with.
>>>>
>>> This should not be needed as the irqs should already be off while in the overflow handler.
>>
>>
>>
>> Interrupts are not disabled in the debug exception handler.
>
> Hi Frederic,
>
> The debug was initialized as an intr gate, thus the interrupts have been  
> disabled in the debug exception handler. :-)



Ah ok. Thanks for the correction :)




> arch/x86/kernel/traps.c:
> 820 /* Set of traps needed for early debugging. */
> 821 void __init early_trap_init(void)
> 822 {
> 823     set_intr_gate_ist(1, &debug, DEBUG_STACK);
> 824     /* int3 can be called from all */
> 825     set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
> 826     set_intr_gate(14, &page_fault);
> 827     load_idt(&idt_descr);
> 828 }
>
> Thanks,
> Dongdong

