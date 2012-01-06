Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab2AFWms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 17:42:48 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14134
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab2AFWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 17:42:46 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dI9371I1432N1418M98dKzz1202hzzz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F0778B0.3050104@am.sony.com>
Date: Fri, 6 Jan 2012 14:41:52 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: NeilBrown <neilb@suse.de>, Brian Swetland <swetland@google.com>,
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
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <4EF27B85.9080801@am.sony.com> <20111222122026.3a0fae36@notabene.brown> <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm> <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com> <20111222180517.20bce47d@notabene.brown> <4F075FFB.4090703@am.sony.com> <20120106212054.GA19509@suse.de>
In-Reply-To: <20120106212054.GA19509@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 01:20 PM, Greg KH wrote:
> On Fri, Jan 06, 2012 at 12:56:27PM -0800, Tim Bird wrote:
>> 4) this is for a popular use case, as opposed to some minor
>> outlying thing, and so people perceive the need to get it
>> exactly right.  In this sense, the code would be a victim of
>> it's own success.
> 
> It's not the code's "success" here, it's the "this solves a general
> problem in a very specific way" issue, that just happens to be a use
> case a lot of different people want to see addressed.  And since it is
> only solving it in a narrow way, that's a problem for all of those other
> people.

It's only a problem in the sense that those different people
don't get something for free.  The presence of an isolated,
configurable driver somewhere in the kernel source, that
addresses one group's issues and not another's doesn't impose
any measurable burden on that other group.

It's more of an opportunity cost thing.  The opportunity
to develop something more general can be reduced when a narrow
solution is accepted.  But this is exactly related to
encouraging people to develop more general solutions, when
narrow ones accomplish what they need (see point 5).

I understand that the whole model is built on people contributing
code that not only addresses their own needs, but the needs of
others.  But of course there should be balance.  For example
I have concerns about integrating this into the printk code path,
because I think that code path is complex enough as it is,
and that combining this functionality with that is likely to
create more maintenance problems rather than less in the
long run.  (But I'll still plan to look at this option ...)

Sometimes, features should just remain separate.

> 
>> 5) blocking this is perceived to be a way to accomplish a
>> larger, related goal (if this is true then it has lots of
>> interesting implications for the economics of open source
>> work)
> 
> No, I don't think that's the issue here.

I don't think anyone is thinking: "If I block this
I can get Tim to do x".  But there *is* a desire to
create a more general logging solution.  And not
accepting this as is, is a way to encourage people to
work on that.

For some situations, I would object to that.  But in
this case I actually agree that there are more potential users
of this, and it would be nice to solve more problems than
just the Android case, with a consolidated code base.  That's
why I'm willing to invest in researching other loggers and
doing some experimental development.

> 
>> In general, there is a tension between the normal nature of adapting
>> the kernel to the most general use cases, and the specialization
>> that is performed in developing an embedded product.  Often
>> times, solutions to embedded requirements are very finely tuned
>> to a particular field of use or situation, and don't lend themselves
>> easily to the type of generalization that mainlining usually requires.

I should have left off "embedded product" for this thread.  There is
a tension in general between generalization and specialization.  And
that tension shows up in a lot of discussions about mainlining code.
My goal here is to determine where people think the balance lies
for this particular code.

> Why do people get hung up on the "embedded is special" case here.  Fact,
> it's not.  Do you somehow think that the work done for the HUGE
> multiprocessor machines 10 years ago would have gotten away with hacks
> saying, "this is a special case, only we care about this", when they
> were dealing with 4 and 8 way machines?  No, they didn't, and as such,
> there's nothing special with embedded here either.  Matter of fact, your
> machines are now more powerful than those old 10 year old machines, and
> are really general purpose computers, just used in a single/limited
> manner, again, just like those original big SMP machines were.
> 
> So, I've said it many times before, and I'll say it again:
> 
>   Yes, you are special and unique, just like everyone else.
> 
> The next person who says the "embedded is different" phrase again, owes
> me a beer of my choice.

Consider this your free beer token... :-)

I believe "embedded is different" because we throw away so much code,
that I just don't think desktop and enterprise do.  The number of
non-mainlined BSPs that have gone straight from product release to
bit bucket is truly staggering.

You're only looking at the Android case, where the machines are as
powerful as they were 10 years ago.  Broad swaths of embedded
are not on that kind of hardware.  It's different (there it is again,
is that two beers?) being at the bottom side of the scalability
spectrum rather than at the top.  Everyone expected that eventually
there would be more SMP machines in the world.  This is not true of
all embedded processors.  We're used to developing code that we'll
throw away after a single release.

But I think this is beside the point for this particular code.

I agree that it's worth some effort to try to generalize this
logger code. Indeed, when I first saw the logger code I thought,
"this would be nice to use on my other projects".  So we'll spend
some time trying to see if it can address more than a single group's
requirements, without gumming up the features that make it valuable
to Android as is.  I'll tell you in a few months whether I think
it's practical or worth it.

>> Which brings me to my last point and a question.
>> Is it inconceivable for there to be a category of code in the
>> Linux kernel which supports ONLY Android user space, and no
>> other?  That is, must every Android patch be generalized in
>> some manner to a broader use case?
> 
> No, that's fine, I have no problem with a drivers/android/ directory for
> android only stuff, because:
> 
>> I suspect some of them (particularly binder) will not lend
>> themselves easily to this type of generalization.
> 
> Exactly, that is where the binder code should eventually end up, and
> probably a few other minor bits.

That's good to hear.

> But for almost everything else (and
> really, there isn't all that much android-only code we are talking about
> here:
> $ wc drivers/staging/android/* drivers/staging/android/switch/* -l | tail -n 1
>    8429 total
> 
> And the switch code is already being worked on to be generalized by
> others, so that means we only have:
> $ wc drivers/staging/android/*  -l | tail -n 1
>    8015 total
> to worry about here.

Well, I'm not sure you've gotten it all (my count is closer to 20k,
some of it sprinkled in a few weird places), but I agree completely
that it's not a lot of code, which is encouraging.  Did you put
anything in besides what's in staging?
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

