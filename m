Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2HCIaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:30:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62186 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2HCIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:30:16 -0400
Date: Fri, 3 Aug 2012 09:30:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/6] ASoC: dapm: If one widget fails, do not
 force all subsequent widgets to fail too
Message-ID: <20120803083009.GC7416@gmail.com>
References: <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
 <20120801132022.GS11892@opensource.wolfsonmicro.com>
 <50193428.5000708@linaro.org>
 <20120801160824.GB11892@opensource.wolfsonmicro.com>
 <20120801194134.GA4103@sirena.org.uk>
 <20120802074517.GA19231@gmail.com>
 <20120802175604.GF4537@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120802175604.GF4537@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 06:56:04PM +0100, Mark Brown wrote:
> On Thu, Aug 02, 2012 at 08:45:18AM +0100, Lee Jones wrote:
> 
> > Over time, the requests for Maintainers have Snowballed (pun intended). My 
> > task now seems to be enabling drivers for Device Tree _and_ fix all 
> > associated driver bugs, including any requested restructuring and API
> 
> One thing to bear in mind with device tree is that it's all about
> defining an ABI - it's supposed to be stable and OS agnostic so it puts
> a lot of pressure on to really address quality problems that become
> visible in the bindings.  This stuff is much less critical with platform
> data, it's relatively easy to change.
>
> > adoption. What you fail to notice is that I am only one person, and hopping
> > all over the code-base trying to do everyone's bidding is no mean feat. In
> 
> It's fairly obvious that it's only you, or at least only you posting
> stuff (I know sometimes there are bigger teams behind people) - the
> pressure you're under to get something in is very clear.  A big part of
> what I'm saying here is that it would be really helpful if could you
> slow down a bit, discuss problems more and avoid cutting corners so
> much.  This is likely to save you time overall, you'll have a much
> higher success rate and you'll get much better feedback if it's clear
> what's going on and that there's an interest in understanding the
> issues.

I do agree that it should be correct, but the difference between getting
it 90% correct and absolutely perfect increases the effort at least x2.
With so much left to do, I think it would be better to get everything in
and functioning, then fix the minor issues as we come across them later.
This is what I've been doing from the start and it's actually looking
pretty good. I also agree that DT should be OS agnostic, but breaking up
MFDs into their functions shouldn't be an issue for other OSes. Either
they can choose to break them up and use the individual child compatible
strings, or only use the parent node.

My personal opinion is if we'd sat around discussing how it should look
prior to doing any work a) the project probably wouldn't have even got
off the ground yet and b) we would have most likely got it all wrong, as
most of our learning and knowledge has been done/gained by actually doing
the work. Instead I've been using the JFDI (Just Frickin' Do It) 
philosophy, and we've actually made some amazing headway. Being blocked
on minor issues and easy to change, orthogonal issues such as vendor
defined properties (i2c) isn't helpful to anyone.
 
> If you need to focus on device tree enablement and there are underlying
> problems in the subsystems you're looking at perhaps you need to push
> back on whoever's asking you to do the work and say you need the domain
> experts to pitch in and help you out.

If only it were that easy. We're not bursting at the seems with resources
here. I'm working in a very customer focused ecosystem. If they don't 
request it, or file a bug about it, there's no resource allocation to fix
it. However, the future is looking up from that point of view. We've just 
started a new project, which I'm hoping will attract some new resources. 
Watch this space.

> > reality I am no more obliged to fix driver bugs than you are. In fact as
> > the Maintainer of some of these subsystems, perhaps you could even help out
> > a bit?
> 
> You're not telling us about the problems you see so it's very difficult
> for anyone to help you.
> 
> For example with this patch the only information you've sent is the
> patch and the fact that you're seeing the error you're ignoring going
> off on the system you're working with (which I had to ask to find out
> about...).  You've not shown the error message or provided any other
> hint which would help anyone understand why the error might be occuring
> and what a good solution to the problem is.  Ola's guess seems very
> likely but nobody's got enough information to confirm that unless
> there's been some off-list ST/Linaro communication.

I only went off what I knew. Some objects (which wouldn't have
prevented playing audio) were failing. It seemed wrong to shut down the
entire audio system because for instance, 'headset mute' or the 'vibrator'
links were broken. As I said to you before, time is a big factor and I
have a massive TODO list. Fixing audio links a) isn't my subject of
expertise, so it would take me much longer to fix than someone with
a good knowledge of the system and b) isn't really my responsibility.
I've tested the DT stuff and it works well. Now I should move onto
something else, like providing the PRCMU with a IRQ Domain, which is
currently blocking the mainlining of other (i.e. thermal) drivers.

> Obviously with the stuff that's device specific you also have to contend
> with the fact that you're working on hardware which just isn't all that
> widely available and quite possibly has closed datasheets.
> 
> > We are all trying to do good things here. Please try not to be too over-
> > critical. We all know Mainlining is a good thing. Perhaps less people
> > would be so frightened of it, thus more people would do it if the reviews
> > weren't such a ball-ache ( for want of a better expression :) ).
> 
> This is a two way thing - one of the tools that maintainers have to try
> to drive up the quality of the code is to push back on poor quality
> submissions and devote less bandwith to sources of those submissions.
> 
> It is true that there's a bunch of people who seem to view review as
> being just an annoying obstacle to be dealt with with the minimum
> possible effort but in practice all that does is make things more
> painful for everyone, they do tend to be more noticable because
> "applied, thanks" doesn't make for a big thread.

Well I know my submissions are not always 100% perfect, but I hope 
you're not implying that they're poor quality. Writing code and fixing
things you view as bugs in code you have no prior knowledge of isn't the 
easiest task in the world. All I can do is attempt to fix the issues that
I see, which get things off the ground or make drivers work again and
submit the changes. If they're wrong they're wrong, but I don't think this
should be viewed as poor quality code!

I didn't say reviews in general. I personally think that reviews are a
very handy way of ensuring code is as the correct level for entry into
Mainline. It's also vital for the learning process, and is where most
of my knowledge has been gained. It's the type of review which defines
the experience. Some Maintainers say things like, "That's wrong. This
is wrong. Why are you doing this?" etc without explaining what the
issues are. That's not a good review, and will put people off trying
again. Equally being too overzealous and nit-picky about stuff that a)
really doesn't matter or b) can be changed really easily _if_ in the
rare case there's an issue. I've also submitted to some Maintainers
who are a pleasure to work with. They explain what's wrong and why
and encourage resubmission. I know Maintainers aren't school teachers,
or life coaches, but they should be encouraging more people to share
their good ( after some fixup ;) ) code and not playing the role of 
an incredibly hard to please boss, or impenetrable brick wall.

Let's just drop this now, or we'll be going round and round forever.
I need to move on to this PRCMU stuff, as it's blocking driver
submission. If you can lend a hand with the audioclk stubs that would
be grand. If not, me might just have to wait for Ola to come back from
his well earned vacation.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
