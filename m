Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1LOQj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:39:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55822 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1LOQj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:39:57 -0500
MIME-Version: 1.0
In-Reply-To: <4EEA1DA8.6040705@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
 <1323876538-20406-4-git-send-email-robherring2@gmail.com> <20111215052512.GB21815@S2101-09.ap.freescale.net>
 <20111215055501.GC21815@S2101-09.ap.freescale.net> <4EE9F899.7010402@gmail.com>
 <4EE9FC99.6030905@gmail.com> <CACxGe6t=ngbzNLkX+df8gP0aoMmgnsVqn2V2eRHpGi5FoFci_w@mail.gmail.com>
 <4EEA1DA8.6040705@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 15 Dec 2011 09:39:34 -0700
X-Google-Sender-Auth: xvmJZDQS1IUTtdCBsmWl6JCwLxk
Message-ID: <CACxGe6t+t_4fAXiLq085LaBS32oaSe3k8tAgiUtuZ7Pu3xawZA@mail.gmail.com>
Subject: Re: [PATCH 3/9] irq: convert generic-chip to use irq_domain
To: Rob Herring <robherring2@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Kevin Hilman <khilman@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 9:17 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 12/15/2011 09:55 AM, Grant Likely wrote:
>> On Thu, Dec 15, 2011 at 6:56 AM, Rob Herring <robherring2@gmail.com> wrote:
>>> Shawn,
>>>
>>> On 12/15/2011 07:39 AM, Rob Herring wrote:
>>>> On 12/14/2011 11:55 PM, Shawn Guo wrote:
>>>>> On Thu, Dec 15, 2011 at 01:25:20PM +0800, Shawn Guo wrote:
>>>>>> On Wed, Dec 14, 2011 at 09:28:52AM -0600, Rob Herring wrote:
>>>>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>>>>
>>>>>>> Add irq domain support to irq generic-chip. This enables users of
>>>>>>> generic-chip to support dynamic irq assignment needed for DT interrupt
>>>>>>> binding. Users must be converted to use irq_data.hwirq for determining
>>>>>>> local interrupt numbers rather than using the Linux irq number.
>>>>>>>
>>>>>>> irq_base is kept for now as there are a few users of it. Once they
>>>>>>> are converted to use the irq domain, it can be removed.
>>>>>>>
>>>>>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>>> ---
>>>>>>
>>>>>> Tested-by: Shawn Guo <shawn.guo@linaro.org>
>>>>>>
>>>>> Sorry, I have to take that tag back after I correct my test setup.
>>>>> It does not work for imx5 TZIC case, because the following change
>>>>> I suggested before is missed.
>>>>>
>>>>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>>>>> index eb763f7..2a2aac1 100644
>>>>> --- a/kernel/irq/irqdomain.c
>>>>> +++ b/kernel/irq/irqdomain.c
>>>>> @@ -39,7 +39,7 @@ void irq_domain_add(struct irq_domain *domain)
>>>>>                         return;
>>>>>                 }
>>>>>                 d->domain = domain;
>>>>> -               d->hwirq = hwirq;
>>>>> +               d->hwirq = hwirq - domain->hwirq_base;
>>>>
>>>> This is a problem. It entirely defeats the point of hwirq_base and it
>>>> would break the GIC. We need to fix this in the generic irq chip.
>>>>
>>>
>>> I think I found a fix. Can you try 's/d->hwirq/(d->hwirq % 32)/' in
>>> generic-chip.c.
>>
>> Ugh, but that hard codes an assumption that a domain cannot have more
>> that 32 irqs.
>>
>> /me goes to dig into irq_domain code...
>
> No, it hard codes that generic irq chip is 32 interrupts at most which
> is already the case. That's why the TZIC uses 5 generic irq chip instances.

Oops, you're right.  I wasn't paying close enough attention. Sorry for
the noise.

g.
