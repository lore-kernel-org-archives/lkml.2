Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0JKRTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:19:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355Ab0JKRTI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:19:08 -0400
MIME-Version: 1.0
In-Reply-To: <20101009235141.GB15564@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
 <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com> <20101009235141.GB15564@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Oct 2010 10:18:34 -0700
Message-ID: <AANLkTikBGsO9wy3z-z6_pTKq0vrYme0fEhE8KcXj_Si3@mail.gmail.com>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken on
 SGI UV
To: Greg KH <greg@kroah.com>
Cc: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 4:51 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, Oct 09, 2010 at 04:24:59PM -0700, Linus Torvalds wrote:
>>
>> I know that's a non-empty set. Too many developers think that the
>> thing they fix is so important that it needs to be backported. And it
>> doesn't help that Greg is sometimes over-eager to take things without
>> them being even in my tree long enough to get much testing.
>
> That's a tough thing to judge as I usually batch up stable
> patches/releases every other week or so.  This can cause some patches to
> be in your tree longer than others.
>
> Should I just have a general "wait a week/release" type rule here before
> adding them to a stable tree for most patches that aren't "obvious"?

I dunno. It's a judgement call, and not an easy one. We've had lots of
problems even with patches that are totally "obvious", simply because
there's some unintended interaction. So even when the patch looks
obviously correct on a small scale (especially just the 3-line
context), it may not be obviously correct after all. In fact, when
people find a bug, the bug it introduced may well be totally obvious
after-the-fact.

So I think it might be a good idea to have some automated "don't send
patches to 'stable' immediately when merged into the tree - wait a
week". At the same time, I don't really think it will work. Some
patches you're probably better off taking immediately (_despite_ the
risk - however low it is - that the thing has some subtle
interaction).

And I suspect that from a social standpoint, if we delay the stable
queue auto-patch-sending, it will just lead to people trying to bypass
that delay by sending things directly to stable rather than depending
on the "stable@kernel.org" tag on the commit itself. Or if the delay
is implemented on the stable email address itself, then people would
try to just send it directly to you instead.

It doesn't help that the number of patches in a stable release is much
bigger than at least I personally envisioned. Yes, many of them are
things like adding device ID's etc, but I do suspect that it just then
makes it much harder to try to delay things by a week or something.
Plus some problems probably wouldn't even be noticed in a week in the
development kernel, and they'd _still_ be found only once it hits
stable just because lots of people will obviously never test the
development kernel.

So I have no solution to it. I just don't think stable has been quite
as stable as people would wish for.

                     Linus
