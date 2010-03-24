Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0CXFra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:47:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58620 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0CXFr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <20100323111612.GB1189@elte.hu>
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> 
	<4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> 
	<20100322092809.GA20607@elte.hu> <1269290862.8599.77.camel@pasglop> 
	<20100322205703.GA25254@elte.hu> <1269294857.8599.90.camel@pasglop> 
	<20100323111612.GB1189@elte.hu>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 24 Mar 2010 01:47:07 -0400
Message-ID: <f73f7ab81003232247t2bf36cfdubbb8dd65db8f5691@mail.gmail.com>
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c 
	to fw_memmap.c
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 07:16, Ingo Molnar <mingo@elte.hu> wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>> I disagree with that being a relevant argument in the technical discussion
>> on the relative merits of two implementations of a given facility. I also
>> disagree with your numbers, if you talk about deployement, I would be very
>> very surprised if ARM wasn't close to on-par with x86.
>
> As an upstream maintainer i mainly care about upstream kernel contributions.
> These contributions have three main forms:
>
>  - patches i get against latest upstream
>
>  - on-lkml review/analysis that is done on those patches
>
>  - test/bug/regression reports i get against latest upstream (either directly
>    on lkml or via kerneloops.org or bugzilla.kernel.org)
>
> So i weigh the architectures based on that input.
>
> Since you mentioned ARM - here's the Git contribution stats. In the last 5
> years since we have kernel Git history, there's been 1080 commits to
> kernel/sched.c. Amongst those 1080 commits i could find only a _single commit_
> (a minor fix) being related to or contributed by anyone doing ARM development!

Ingo,

I'd like to assume that you _accidentally_ picked the *worst* possible
example file in the entire repository (with the exception of anything
in arch/x86...).  You should keep in mind that basically nobody doing
ARM development cares one hoot about the scheduler as long as it
"basically works"... most such systems could get away with just
SCHED_FIFO and static priorities.  When you're porting the kernel to a
platform with a 250MHz in-order CPU that's going to have a load
average of zero for 99.5% of the time and a load average of 1.0 for
the other 0.5% of the time that's pretty much the *LAST* thing you
care about.

In fact, I would guess that all the excellent work that has been done
with regards to optimized SMP and UP scheduling on much busier systems
with pathological loads has meant that the scheduler is probably one
of the most reliable pieces of code for the ARM developers.  If you
want some excellent examples that go the other way, I suggest looking
at gpiolib for some great examples of code that don't matter for beans
on 99.95% of X86 boxes yet are essential for any kind of real embedded
development.

So while it's possible that you could make a reasonable point about
developer time by looking at GIT commit logs... You should refrain
from making such insulting and sweeping over-generalizations by
looking at single files, particularly ones which are largely
irrelevant or immaterial for the specific subset of developers.

Cheers,
Kyle Moffett
