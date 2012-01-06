Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030646Ab2AFVVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:21:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573Ab2AFVVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:21:12 -0500
Date: Fri, 6 Jan 2012 13:20:54 -0800
From: Greg KH <gregkh@suse.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: NeilBrown <neilb@suse.de>, Brian Swetland <swetland@google.com>,
        "david@lang.hm" <david@lang.hm>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@osdl.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: android logger feedback request
Message-ID: <20120106212054.GA19509@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown>
 <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
 <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
 <20111222180517.20bce47d@notabene.brown>
 <4F075FFB.4090703@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F075FFB.4090703@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 12:56:27PM -0800, Tim Bird wrote:
> Now, having said all that, let me go off into some philosophical weeds...

Ah, this should be fun :)

> This code is only about 700 lines long, and specializes the kernel for
> an extremely popular (by usage) user space stack.  Code of
> lower quality which specializes the kernel for much less-used hardware
> has been admitted into the kernel with significantly less fuss than
> this code has received.  That's not an argument to accept the code
> as is, it's just an observation about the relative hurdle that this
> code faces compared to lots of other code that goes into the kernel.
> (And please don't interpret this as dissatisfaction with the feedback
> received.)
> 
> If this code were a character driver for an obscure serial port
> on a lesser-known chip architecture, I don't think it would get
> any attention at all.  As it is, it's looking like at least a few
> man months of work will be required, as well as some relatively
> unneeded changes to Android user space, to get this feature into
> a permanently acceptable state.  I wouldn't be surprised to see
> this stretch into a few calendar years.
> 
> Code that specializes the kernel in weird ways is accepted into
> the kernel all the time, and I've tried to figure out why this
> particular bit of code is treated differently.  Especially since
> this code is self-contained, configurable, and imposes no
> perceivable long-term maintenance burden.  (That's not true of
> all Android patches, but I believe it's true of this one).
> 
> I have a few theories:
> 1) this is not tied to hardware, and as such represents a general
> feature (but people are not at all required to treat it as such,
> just as they are not required to use other people's weird drivers).

That is exactly true.

> 2) people want to avoid duplication with other similar features
> (again, since it's self-contained and configurable, I don't know
> why it would bother people if this existed in tandem with other
> solutions - especially since it's so small)

Again, very true in the duplication sense.

It is general code, not tied to hardware, so it better justify itself
somehow.

> 3) there is really no maintainer for this feature category, so
> discussions get bogged down as varying requirements and solutions
> are suggested, which can not easily be compared against each other
> (especially for non-existent implementations)  In particular, it's
> unclear who I have to get the approval of for this code or some
> derivative of it to be accepted.  That makes the development task
> a very open-ended one.

No, I don't think this is a problem, you have bigger ones to deal with
:)

> 4) this is for a popular use case, as opposed to some minor
> outlying thing, and so people perceive the need to get it
> exactly right.  In this sense, the code would be a victim of
> it's own success.

It's not the code's "success" here, it's the "this solves a general
problem in a very specific way" issue, that just happens to be a use
case a lot of different people want to see addressed.  And since it is
only solving it in a narrow way, that's a problem for all of those other
people.

> 5) blocking this is perceived to be a way to accomplish a
> larger, related goal (if this is true then it has lots of
> interesting implications for the economics of open source
> work)

No, I don't think that's the issue here.

> In general, there is a tension between the normal nature of adapting
> the kernel to the most general use cases, and the specialization
> that is performed in developing an embedded product.  Often
> times, solutions to embedded requirements are very finely tuned
> to a particular field of use or situation, and don't lend themselves
> easily to the type of generalization that mainlining usually requires.

Why do people get hung up on the "embedded is special" case here.  Fact,
it's not.  Do you somehow think that the work done for the HUGE
multiprocessor machines 10 years ago would have gotten away with hacks
saying, "this is a special case, only we care about this", when they
were dealing with 4 and 8 way machines?  No, they didn't, and as such,
there's nothing special with embedded here either.  Matter of fact, your
machines are now more powerful than those old 10 year old machines, and
are really general purpose computers, just used in a single/limited
manner, again, just like those original big SMP machines were.

So, I've said it many times before, and I'll say it again:

  Yes, you are special and unique, just like everyone else.

The next person who says the "embedded is different" phrase again, owes
me a beer of my choice.

> Which brings me to my last point and a question.
> Is it inconceivable for there to be a category of code in the
> Linux kernel which supports ONLY Android user space, and no
> other?  That is, must every Android patch be generalized in
> some manner to a broader use case?

No, that's fine, I have no problem with a drivers/android/ directory for
android only stuff, because:

> I suspect some of them (particularly binder) will not lend
> themselves easily to this type of generalization.

Exactly, that is where the binder code should eventually end up, and
probably a few other minor bits.  But for almost everything else (and
really, there isn't all that much android-only code we are talking about
here:
$ wc drivers/staging/android/* drivers/staging/android/switch/* -l | tail -n 1
   8429 total

And the switch code is already being worked on to be generalized by
others, so that means we only have:
$ wc drivers/staging/android/*  -l | tail -n 1
   8015 total
to worry about here.

thanks,

greg k-h
