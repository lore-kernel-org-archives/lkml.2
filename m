Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1KWGrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:47:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41615 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1KWGrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:47:41 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20111122210018.GF9581@n2100.arm.linux.org.uk>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<1321960128-15191-3-git-send-email-gilad@benyossef.com>
	<20111122210018.GF9581@n2100.arm.linux.org.uk>
Date: Wed, 23 Nov 2011 08:47:40 +0200
Message-ID: <CAOtvUMcus07UY1keOor2=k=iDocKA0GoqYeOQ5r5p6vQ7efwCA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] arm: Move arm over to generic on_each_cpu_mask
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 22, 2011 at 11:00 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 22, 2011 at 01:08:45PM +0200, Gilad Ben-Yossef wrote:
>> -static void on_each_cpu_mask(void (*func)(void *), void *info, int wait,
>> -     const struct cpumask *mask)
>> -{
>> -     preempt_disable();
>> -
>> -     smp_call_function_many(mask, func, info, wait);
>> -     if (cpumask_test_cpu(smp_processor_id(), mask))
>> -             func(info);
>> -
>> -     preempt_enable();
>> -}
>
> What hasn't been said in the descriptions (I couldn't find it) is that
> there's a semantic change between the new generic version and this version -
> that is, we run the function with IRQs disabled on the local CPU, whereas
> the version above runs it with IRQs potentially enabled.
>
> Luckily, for TLB flushing this is probably not a problem, but it's
> something that should've been pointed out in the patch description.

Thank you for the review!

You are very right that I should have mentioned it in the description.
My apologies for missing that bit.

My reasoning for why the change is OK is that the function passed is
ready to run with interrupt disabled because this is how it will be
called on all the other CPUs through the IPI handler so it is safe.
This is also how the generic  on_each_cpu() handles it.

Have I missed something? if not will you like me to update the patch
description and re-send?

Thanks,
Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
