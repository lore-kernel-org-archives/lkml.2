Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2JEJci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:32:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38605 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2JEJcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:32:36 -0400
Date: Fri, 5 Oct 2012 11:32:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Iain Fraser <iainkfraser@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: interrupt context
Message-ID: <20121005093232.GA7333@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Iain Fraser <iainkfraser@gmail.com>, linux-kernel@vger.kernel.org
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
 <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 09:51:55AM +0100, Iain Fraser wrote:
> Hello,
> 
> I understand the interrupts and softirq's run in interrupt context (
> as opposed to process context ). But what I
> don't understand is why you cannot sleep in interrupt context?
> 
> What I have read it states that it doesn't have a process to schedule
> out. But interrupts use the interrupted processes
> kernel stack just like a syscall. So surely it is possible to sleep
> using that stack. Understandably It would be unfair on the process
> that blocked through no fault of its own.
> 
> Also if you are not allowed to sleep / schedule during interrupt
> context. Then how does the system timer pre-empt processes by
> calling schedule?
> 
> I understand there are many reasons why you shouldn't: irq lines being
> disabled, quick completion, etc. But I don't understand
> why you cannot.

Let's imagine for a second we could sleep in IRQ context and we had some
dummy process entity we can schedule out from.

So, we schedule out and run another process which enters the kernel and
grabs a lock L.

At that exact moment, another IRQ on the same line is raised, we execute
the same IRQ handler which purely coincidentally starts busy-waiting on
the same lock L.

How long do you think we'll be busy waiting in IRQ context on that lock?

:-)

HTH.

-- 
Regards/Gruss,
    Boris.
