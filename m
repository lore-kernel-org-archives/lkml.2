Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab2AFU5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:57:36 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:24317
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172Ab2AFU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:57:34 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2dI9371I1528M1432N41c5N98dKzz1202hzz8275dhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4F075FFB.4090703@am.sony.com>
Date: Fri, 6 Jan 2012 12:56:27 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Brian Swetland <swetland@google.com>, "david@lang.hm" <david@lang.hm>,
        Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@osdl.org>, <david@lang.hm>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: android logger feedback request
References: <4EF264C3.6000104@am.sony.com>	<20111221231956.GB23859@suse.de>	<4EF27B85.9080801@am.sony.com>	<20111222122026.3a0fae36@notabene.brown>	<alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>	<CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com> <20111222180517.20bce47d@notabene.brown>
In-Reply-To: <20111222180517.20bce47d@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm back from vacation - sorry for the long delay in responding.

First, let me say thanks to all those who have responded with ideas
and suggestions.  I'll be following up on many of them in the new
few weeks.  This is a background task for me, so it will likely
go relatively slowly.  I have volunteer offers of assistance,
and some resources available for contract work, but it might take time
to set that up.  In general, though, things should be able to move forward.

I could respond to a lot of messages individually, but
to conserve space I'll focus on this one, and present an overall
idea for how I plan to proceed.

On 12/21/2011 11:05 PM, NeilBrown wrote:
> Possibly it would be useful to be clear what we all *are* really interested
> in, because I suspect there is a lot of variety.
> 
> You appear to be interested in providing a great platform for a phone, in
> minimising unnecessary churn in that platform, and in having the freedom to
> optimise various aspects however you see fit.  You appear to have little
> problem with maintaining some components out-of-mainline. This is all
> perfectly valid and very much in the spirit of "freedom" that binds us
> together.
> 
> Others want to be able to run a main-line kernel underneath the Android
> user-space - and that is perfectly reasonable as well.
> 
> I don't much care about either of those, but I want "Linux" to be "high
> quality" (according to my own personal standards of course) which means
> keeping bad stuff out (though you could argue that the horse has well and
> truly bolted there) and including good and useful stuff in.  And I think
> Android has something to offer on both sides there :-)

Thanks very much for this.  I think it *is* important to take a step
back and compare goals, to see how we can achieve the best result for
all parties.

> 
> Weighing all that up, I don't think it is useful to set our goal on "getting
> Android to use a mainline kernel" - that isn't going to happen.
> Rather we should focus primarily on "making it *possible* to run android
> user-space on mainline".
> 
> That could involve two things
> 1/ Making sure the interfaces that Android uses are abstracted at a suitable
>   level so that when running a mainline kernel you can just slip in an
>   alternate shared library with compatible functionality.
> 2/ Adding functionality to Linux so that it is possible to provide the
>   functionality that Android needs.

Agreed.

> Android should not *have* to use the interface that the "mainline
> community" decides is preferred, but nor should mainline be required to
> include the drivers that Android wants to use.  History shows us that isn't
> going to happen.

I agree with the sentiment in the first sentence, but I would like to
make a few observations about this code, and the problem in general,
for consideration.  I'll do this below because it's a bit philosophical,
and I'd rather focus on "the way forward" first.

> But if there was a fairly low-level API that Android used, then those in the
> community could who want Android on a mainline kernel could work to implement
> that API with whatever mixture of user-space and kernel-space that achieves
> consensus.
> Android could of course change to use the community version eventually if
> they found that was a good thing, or could keep using their own.
> 
> So: bringing this back to the android logger...
>   What I would like to see is a low-level API which is used to access logging
>   for which alternate implementations could be written.  Ideally this would
>   be embodied in a single .so, but we have the source so that doesn't need to
>   be a barrier.
>   Then we could argue to our heart's content about how best to implement that
>   API - Journal and nsyslogd and rsyslogd could all implement it in different
>   ways and we could be one step closer to running Android on a mainline
>   kernel, but the Android developers don't need to be involved (but can if
>   they want to of course).
> 
>   I would be important that the API is specified clearly - neither under
>   specified nor over-specified. That means that the Android implementation
>   would need to explicitly forbid anything that isn't explicit permitted.
>   This is because most testing will happen on the Android platform so it's
>   actual behaviour will become the defacto standard.
> 
>   Could that be a possible way forward?

I'd like to pursue this, as well as some of the minor code cleanups
suggested by Andrew Morton.  Here's what I'm thinking:

I'd like to implement Neil's file-system based solution as a test case,
and compare that with the existing code.  I like the elegance of using
existing filesystem semantics, and the removal of some hard-coded limits
and policy from the kernel.  A lower priority would be to also try
a user-space-only solution, as described by Arnd.  Optimally, it would
be nice to have all three systems to compare (char dev, log fs, and
ram fs) against each other.

I'll try to use these under the existing logger library API to see if the
current semantics expected by Android user space can be preserved.  This
would minimize the churn to Android user space.  Before this (or any other
changes for that matter) could be rolled out in an official Android
release, there would be a lot of testing required, to make sure something
hasn't been broken.  I want to avoid asking the Google developers to
do this, as they have something that works now, and there's little incentive
to change it.  I'm tackling this problem as something of a wider issue
for the industry.

Separately, I'd like to apply the changes requested by Andrew Morton
to the existing char dev driver, as just simple cleanups.  This, however,
also will require some testing to avoid regressions.

On a separate track, I want to compare the requirements discussed in this
thread with what systemd is doing (and how /dev/kmsg is being used) to see
if there are issues that inform a possible more general solution for
logging in the future.  To this end, it might be good to set up a
meeting at a future event (ELC or collab summit, depending on what
people plan to come to) to discuss things face-to-face.

I'm hoping that the existing code can live in staging while we sort
this out longer term.  This code has lived out of mainline for several
years, and I don't think we're in any kind of rush.  I plan to record
the requirements and the plan for this on a wiki page I've set up at:
http://elinux.org/Mainline_Android_logger_project, but I may also record
some of the simple cleanup requests in a TODO file in staging.

Also, separately, we'll likely do some benchmarking of the various
systems, as part of our overall comparison effort - to address questions
about the tradeoffs involved - particularly between implementing this
in or out of kernel and between existing and new kernel infrastructure.

[warning - next part is long...]

Now, having said all that, let me go off into some philosophical weeds...

This code is only about 700 lines long, and specializes the kernel for
an extremely popular (by usage) user space stack.  Code of
lower quality which specializes the kernel for much less-used hardware
has been admitted into the kernel with significantly less fuss than
this code has received.  That's not an argument to accept the code
as is, it's just an observation about the relative hurdle that this
code faces compared to lots of other code that goes into the kernel.
(And please don't interpret this as dissatisfaction with the feedback
received.)

If this code were a character driver for an obscure serial port
on a lesser-known chip architecture, I don't think it would get
any attention at all.  As it is, it's looking like at least a few
man months of work will be required, as well as some relatively
unneeded changes to Android user space, to get this feature into
a permanently acceptable state.  I wouldn't be surprised to see
this stretch into a few calendar years.

Code that specializes the kernel in weird ways is accepted into
the kernel all the time, and I've tried to figure out why this
particular bit of code is treated differently.  Especially since
this code is self-contained, configurable, and imposes no
perceivable long-term maintenance burden.  (That's not true of
all Android patches, but I believe it's true of this one).

I have a few theories:
1) this is not tied to hardware, and as such represents a general
feature (but people are not at all required to treat it as such,
just as they are not required to use other people's weird drivers).

2) people want to avoid duplication with other similar features
(again, since it's self-contained and configurable, I don't know
why it would bother people if this existed in tandem with other
solutions - especially since it's so small)

3) there is really no maintainer for this feature category, so
discussions get bogged down as varying requirements and solutions
are suggested, which can not easily be compared against each other
(especially for non-existent implementations)  In particular, it's
unclear who I have to get the approval of for this code or some
derivative of it to be accepted.  That makes the development task
a very open-ended one.

4) this is for a popular use case, as opposed to some minor
outlying thing, and so people perceive the need to get it
exactly right.  In this sense, the code would be a victim of
it's own success.

5) blocking this is perceived to be a way to accomplish a
larger, related goal (if this is true then it has lots of
interesting implications for the economics of open source
work)

In general, there is a tension between the normal nature of adapting
the kernel to the most general use cases, and the specialization
that is performed in developing an embedded product.  Often
times, solutions to embedded requirements are very finely tuned
to a particular field of use or situation, and don't lend themselves
easily to the type of generalization that mainlining usually requires.

Which brings me to my last point and a question.
Is it inconceivable for there to be a category of code in the
Linux kernel which supports ONLY Android user space, and no
other?  That is, must every Android patch be generalized in
some manner to a broader use case?

I suspect some of them (particularly binder) will not lend
themselves easily to this type of generalization.
Knowing the answer to this question would help me gauge the
amount of effort required for this project, and the
net value of continuing it.

Thanks and regards,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

