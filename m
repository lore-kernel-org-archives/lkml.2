Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2HDAs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:48:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42760 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043Ab2HDAs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:48:56 -0400
Date: Sat, 4 Aug 2012 01:48:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/6] ASoC: dapm: If one widget fails, do not
 force all subsequent widgets to fail too
Message-ID: <20120804004821.GG4515@opensource.wolfsonmicro.com>
References: <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
 <20120801132022.GS11892@opensource.wolfsonmicro.com>
 <50193428.5000708@linaro.org>
 <20120801160824.GB11892@opensource.wolfsonmicro.com>
 <20120801194134.GA4103@sirena.org.uk>
 <20120802074517.GA19231@gmail.com>
 <20120802175604.GF4537@opensource.wolfsonmicro.com>
 <20120803083009.GC7416@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803083009.GC7416@gmail.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 09:30:10AM +0100, Lee Jones wrote:

> I do agree that it should be correct, but the difference between getting
> it 90% correct and absolutely perfect increases the effort at least x2.
> With so much left to do, I think it would be better to get everything in
> and functioning, then fix the minor issues as we come across them later.

If you're going to do this the usual way is to do it by leaving bits
out, and see below.

> If only it were that easy. We're not bursting at the seems with resources
> here. I'm working in a very customer focused ecosystem. If they don't 
> request it, or file a bug about it, there's no resource allocation to fix

Right, I work in the same industry - but this shouldn't be a problem,
if it's not urgent for people to help it's probably not urgent to do
whatever's blocked by it either.

> > You're not telling us about the problems you see so it's very difficult
> > for anyone to help you.

> > For example with this patch the only information you've sent is the
> > patch and the fact that you're seeing the error you're ignoring going
> > off on the system you're working with (which I had to ask to find out

> I only went off what I knew. Some objects (which wouldn't have
> prevented playing audio) were failing. It seemed wrong to shut down the
> entire audio system because for instance, 'headset mute' or the 'vibrator'
> links were broken. As I said to you before, time is a big factor and I
> have a massive TODO list. Fixing audio links a) isn't my subject of

This isn't the point, and it's a *very* important point which is the
main reason I'm replying here.

The immediate point here is that you're not communicating about what
you're trying to which is the source of a lot of problems.  Things would
run a lot more smoothly if when you try to cut corners you were explicit
about the corners you cut, and if when you run into problems you report
those problems as well as sending whatever code you're using to work
around things.  Set people's expecations about what they're seeing and
provide them with context.

Consider the patch that's in the subject line here - it took me a couple
of goes before you even said you'd seen an issue on your system which
you were working around (I still don't know what the actual errors are).
As far as I could tell looking at the patch description it was something
done for taste reasons which was being sent as a bug fix.

The usual approach for things like this is a changelog or cover mail
which says something like "I'm seeing this error, here's the code I'm
using to get things working on my system and I think this is a good idea
because..." (or "...but that can't be right", or whatever).  This works
a whole lot better, it makes it clear what the underlying motivation for
the change is and understand the submitter's expecation for the quality
of the patch.

Similarly with the missing device tree binding documentation, had you
said something about the patches not being complete and writing the
binding documentation later that'd have helped a lot.  Having it there
is a basic checklist thing for new DT bindings which is easy to spot
from a diffstat, it's really not something a reviewer should ever need
to ask about especially from someone doing a lot of DT work and it's a
big red flag for the quality of the code.

Things like this are really important, especially for people doing lots
of work, as they have such a big impact on communication and so much of
what makes this thing tick is about communication.

> expertise, so it would take me much longer to fix than someone with
> a good knowledge of the system and b) isn't really my responsibility.

That's fine, just tell people about the problem and move on to
something else from what's probably a large task list if it's blocking
you (and start nagging people if it doesn't get fixed and it seems
important).  This happens fairly often, it works well most of the time.
Sending a fix is of course ideal but it's not essential.

> Well I know my submissions are not always 100% perfect, but I hope 
> you're not implying that they're poor quality. Writing code and fixing
> things you view as bugs in code you have no prior knowledge of isn't the 

This is process stuff more than code stuff, it's all about communication.

> easiest task in the world. All I can do is attempt to fix the issues that
> I see, which get things off the ground or make drivers work again and
> submit the changes. If they're wrong they're wrong, but I don't think this
> should be viewed as poor quality code!

What you can do here is to commmunicate about what you're doing more.
Don't just think about the code, think about the communication
surrounding the code - this is the core of the issue.

> the experience. Some Maintainers say things like, "That's wrong. This
> is wrong. Why are you doing this?" etc without explaining what the
> issues are. That's not a good review, and will put people off trying
> again.

Like I said in my previous mail this is one of the tools people have
available to them to drive up quality - if you watch a bit more closely
you'll often see that the quality of the review is scaled to factors in
the submission (and often the pattern of submissions from a contributor).
It's often not something that's done conciously, a lot of this is just
people conveying that they're annoyed.

>        Equally being too overzealous and nit-picky about stuff that a)
> really doesn't matter or b) can be changed really easily _if_ in the
> rare case there's an issue. I've also submitted to some Maintainers

This is a similar thing - it's part of the toolbox.

> who are a pleasure to work with. They explain what's wrong and why
> and encourage resubmission. I know Maintainers aren't school teachers,
> or life coaches, but they should be encouraging more people to share
> their good ( after some fixup ;) ) code and not playing the role of 
> an incredibly hard to please boss, or impenetrable brick wall.

Maintainer bandwidth is limited, and people will focus these efforts
where they think it'd be useful.  What I'm spending time doing here is
trying to convey that there's some fairly easily solvable process issues
here which are making everyone's life harder here.
