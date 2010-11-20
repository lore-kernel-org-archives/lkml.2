Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0KTCRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:17:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab0KTCRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:17:07 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
 <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com> <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 18:15:54 -0800
Message-ID: <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 6:04 PM, huang ying
<huang.ying.caritas@gmail.com> wrote:
>
> We thought about 'printk' for hardware errors before, but it has some
> issues too.
>
> 1) It mixes software errors and hardware errors. When Andi Kleen
> maintained the Machine Check code, he found many users report the
> hardware errors as software bug to software vendor instead of as
> hardware error to hardware vendor. Having explicit hardware error
> reporting interface may help these users.

Bah. Many machine checks _were_ software errors. They were things like
the BIOS not clearing some old pending state etc.

The confusion came not from printk, but simply from ambiguous errors.
When is a machine check hardware-related? It's not at all always
obvious.

Sometimes machine checks are from uninitialized hardware state, where
_software_ hasn't initialized it. Is it a hardware bug? No.

> 2) Hardware error reporting may flush other information in printk
> buffer. Considering one pin of your ECC DIMM is broken, tons of 1 bit
> corrected memory error will be reported. Although we can enforce some
> kind of throttling, your printk buffer may be full of the hardware
> error reporting eventually.

Sure. That doesn't change the fact that finding the data is your
/var/log/messages and your regular logging tools is still a lot more
useful than having some random tool that is specialized and that most
IT people won't know about. And that won't be good at doing network
reporting etc etc.

The thing is, hardware errors aren't that special. Sure, hardware
people always think so. But to anybody else, a hardware error is "just
another source of issues".

Anybody who thinks that hardware errors are special and needs a
special interface is missing that point totally.

And I really do understand why people inside Intel would miss that
point. To YOU guys the hardware errors you report are magical and
special. But that's always true. To _everybody_, the errors _they_
report is special. Like snowflakes, we're all unique. And we're all
the same.

> 3) We need some kind of user space hardware error daemon, which is
> used to enforce some policy. For example, if the number of corrected
> memory errors reported on one page exceeds the threshold, we can
> offline the page to prevent some fatal error to occur in the future,
> because fatal error may begin with corrected errors in reality. printk
> is good for administrator, and may be not good enough for the hardware
> error daemon.

And by "we", who do you mean exactly? The fact is, "we" covers a lot
of ground, and I don't think your statement is in the least true.

Yes, IT people want to know. When they start seeing hardware errors,
they'll start replacing the machine as soon as they can. Whether that
replacement is then "in five minutes" or "four months from now" is up
to their management, their replacement policy, and based on how
critical that machine is.

IT HAS NOTHING WHAT-SO-EVER TO DO WITH HOW OFTEN THE ERRORS HAPPEN.

And yes, Intel can do guidelines, but when you say there should be
some "enforced policy" by some tool, you're simply just wrong.

                  Linus
