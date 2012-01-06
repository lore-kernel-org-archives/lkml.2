Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2AFXgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:36:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322Ab2AFXfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:35:42 -0500
Date: Fri, 6 Jan 2012 15:35:20 -0800
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
Message-ID: <20120106233520.GB24043@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown>
 <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
 <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
 <20111222180517.20bce47d@notabene.brown>
 <4F075FFB.4090703@am.sony.com>
 <20120106212054.GA19509@suse.de>
 <4F0778B0.3050104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0778B0.3050104@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 02:41:52PM -0800, Tim Bird wrote:
> On 01/06/2012 01:20 PM, Greg KH wrote:
> > On Fri, Jan 06, 2012 at 12:56:27PM -0800, Tim Bird wrote:
> >> 4) this is for a popular use case, as opposed to some minor
> >> outlying thing, and so people perceive the need to get it
> >> exactly right.  In this sense, the code would be a victim of
> >> it's own success.
> > 
> > It's not the code's "success" here, it's the "this solves a general
> > problem in a very specific way" issue, that just happens to be a use
> > case a lot of different people want to see addressed.  And since it is
> > only solving it in a narrow way, that's a problem for all of those other
> > people.
> 
> It's only a problem in the sense that those different people
> don't get something for free.  The presence of an isolated,
> configurable driver somewhere in the kernel source, that
> addresses one group's issues and not another's doesn't impose
> any measurable burden on that other group.

That's been proven incorrect over the long-run as we all must now
maintain that user/kernel API for forever.

You could say the same thing for adding new ioctls for individual
drivers instead of creating a new syscall.  Sometimes, in rare cases, it
does make sense to create a new ioctl.  But that decision has to be
taken very carefully, as again, it needs to be standardized with all
other drivers of that time, and maintained for forever.

> It's more of an opportunity cost thing.  The opportunity
> to develop something more general can be reduced when a narrow
> solution is accepted.  But this is exactly related to
> encouraging people to develop more general solutions, when
> narrow ones accomplish what they need (see point 5).

When people work together on their narrow goals, they end up creating
something that works for way more than just themselves, and in fact, it
turns out it works better for people who originally wasn't even aware of
the issues involved.

Again, this has been proven over time with the Linux kernel development
process.  I wrote a whole chapter on this very topic in the book,
"Beautiful Code", if you want to hear more about it.

In fact, I would argue, that is one of the top reasons why Linux has
succeeded so well.  Again, you really aren't unique, others will have
the same issues/problems that you do, and if you solve them in a case
that works for more than one, it makes everything better.

> I understand that the whole model is built on people contributing
> code that not only addresses their own needs, but the needs of
> others.  But of course there should be balance.  For example
> I have concerns about integrating this into the printk code path,
> because I think that code path is complex enough as it is,
> and that combining this functionality with that is likely to
> create more maintenance problems rather than less in the
> long run.  (But I'll still plan to look at this option ...)

Complex code paths are tough, I will grant you that.  But if it was
easy, then, you wouldn't be the person for the job :)

> Sometimes, features should just remain separate.

When they do different things, of course.  When they do the same thing,
of course not.

> > Why do people get hung up on the "embedded is special" case here.  Fact,
> > it's not.  Do you somehow think that the work done for the HUGE
> > multiprocessor machines 10 years ago would have gotten away with hacks
> > saying, "this is a special case, only we care about this", when they
> > were dealing with 4 and 8 way machines?  No, they didn't, and as such,
> > there's nothing special with embedded here either.  Matter of fact, your
> > machines are now more powerful than those old 10 year old machines, and
> > are really general purpose computers, just used in a single/limited
> > manner, again, just like those original big SMP machines were.
> > 
> > So, I've said it many times before, and I'll say it again:
> > 
> >   Yes, you are special and unique, just like everyone else.
> > 
> > The next person who says the "embedded is different" phrase again, owes
> > me a beer of my choice.
> 
> Consider this your free beer token... :-)

Oooh, nice, I'll take you up on that at ELC in a few weeks :)

> I believe "embedded is different" because we throw away so much code,
> that I just don't think desktop and enterprise do.  The number of
> non-mainlined BSPs that have gone straight from product release to
> bit bucket is truly staggering.

Yes, and that's sad.  And maybe, if embedded feels that they are so
special, and that contributing to mainline doesn't help or matter, then
they shouldn't.

Yes, I mean it, why push stuff upstream if you aren't going to maintain
it and no one will ever build on top of it.

Oh wait, you will end up building on it with your next iteration, so if
you throw it away, oops, you just wasted time and money.

And again, this mirrors the super computer case EXACTLY!  In fact, I
would argue that there are less machines shipped for those types of
systems, than embedded, and do you see those developers saying that they
should just keep their code out of mainline?  Or do they actually
realize that it is cheaper, in time and money to mainline stuff.

Remember, Intel and IBM has said publically, numerous times, that it
makes business and money sense to do this.  Are the people at these
companies somehow wrong?  Do they not also support the "embedded"
markets?

> You're only looking at the Android case, where the machines are as
> powerful as they were 10 years ago.  Broad swaths of embedded
> are not on that kind of hardware.  It's different (there it is again,
> is that two beers?) being at the bottom side of the scalability
> spectrum rather than at the top.  Everyone expected that eventually
> there would be more SMP machines in the world.  This is not true of
> all embedded processors.  We're used to developing code that we'll
> throw away after a single release.

Again, same goes for super computers.

And again, if it really is going to be thrown away, then by all means,
throw it away.  But I will bet you the beer you owe me, odds are you
want that code again in the future to build on top of.

Unless it's an obsolete architecture like Voyager or something, then
just throw that away, no one would ever build on top of that :)

Oh wait, again, look at the benifits Linux overall has achieved from
supporting something "odd" and "obsolete" in the mainline kernel, to
help abstract core functionality to make things more flexable and
workable for {gasp} even the embedded folks.

Sorry, again, I don't buy your argument one bit.

> But I think this is beside the point for this particular code.

I agree.

thanks,

greg "beer's on Tim!" k-h
