Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2JEKUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:20:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46474 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2JEKUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121005093232.GA7333@liondog.tnic>
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
	<CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
	<20121005093232.GA7333@liondog.tnic>
Date: Fri, 5 Oct 2012 11:20:20 +0100
Message-ID: <CA+bLfK7+xpbbJp+1sJBOtjoT2auGpbKsVKoDMgRk95o-Fwm9RQ@mail.gmail.com>
Subject: Re: interrupt context
From: Iain Fraser <iainkfraser@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Iain Fraser <iainkfraser@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the response. But it appears your example illustrates why its bad
to sleep while you have a lock. Which I understand, what I wanted to know is
why in interrupt context under no circumstances are you allowed to sleep?

Btw I have no intention of doing this, I'm just curious. After
thinking about it further
I'm starting to think its a "design" decision as opposed to a side effect of the
kernel implementation.

If you could answer:

"How can the system timer ( obviously in interrupt context ) call
schedule when it is impossible to sleep/schedule in interrupt context?"

That would help me greatly.

Thanks again
iain

On Fri, Oct 5, 2012 at 10:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Oct 05, 2012 at 09:51:55AM +0100, Iain Fraser wrote:
>> Hello,
>>
>> I understand the interrupts and softirq's run in interrupt context (
>> as opposed to process context ). But what I
>> don't understand is why you cannot sleep in interrupt context?
>>
>> What I have read it states that it doesn't have a process to schedule
>> out. But interrupts use the interrupted processes
>> kernel stack just like a syscall. So surely it is possible to sleep
>> using that stack. Understandably It would be unfair on the process
>> that blocked through no fault of its own.
>>
>> Also if you are not allowed to sleep / schedule during interrupt
>> context. Then how does the system timer pre-empt processes by
>> calling schedule?
>>
>> I understand there are many reasons why you shouldn't: irq lines being
>> disabled, quick completion, etc. But I don't understand
>> why you cannot.
>
> Let's imagine for a second we could sleep in IRQ context and we had some
> dummy process entity we can schedule out from.
>
> So, we schedule out and run another process which enters the kernel and
> grabs a lock L.
>
> At that exact moment, another IRQ on the same line is raised, we execute
> the same IRQ handler which purely coincidentally starts busy-waiting on
> the same lock L.
>
> How long do you think we'll be busy waiting in IRQ context on that lock?
>
> :-)
>
> HTH.
>
> --
> Regards/Gruss,
>     Boris.
