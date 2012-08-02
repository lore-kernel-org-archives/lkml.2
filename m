Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2HBR4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:56:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45637 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734Ab2HBR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:56:08 -0400
Date: Thu, 2 Aug 2012 18:56:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <ljkenny@gmail.com>
Cc: ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/6] ASoC: dapm: If one widget fails, do not
 force all subsequent widgets to fail too
Message-ID: <20120802175604.GF4537@opensource.wolfsonmicro.com>
References: <5017EDCA.4020601@linaro.org>
 <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
 <20120801132022.GS11892@opensource.wolfsonmicro.com>
 <50193428.5000708@linaro.org>
 <20120801160824.GB11892@opensource.wolfsonmicro.com>
 <20120801194134.GA4103@sirena.org.uk>
 <20120802074517.GA19231@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802074517.GA19231@gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 08:45:18AM +0100, Lee Jones wrote:

> Over time, the requests for Maintainers have Snowballed (pun intended). My 
> task now seems to be enabling drivers for Device Tree _and_ fix all 
> associated driver bugs, including any requested restructuring and API

One thing to bear in mind with device tree is that it's all about
defining an ABI - it's supposed to be stable and OS agnostic so it puts
a lot of pressure on to really address quality problems that become
visible in the bindings.  This stuff is much less critical with platform
data, it's relatively easy to change.

> adoption. What you fail to notice is that I am only one person, and hopping
> all over the code-base trying to do everyone's bidding is no mean feat. In

It's fairly obvious that it's only you, or at least only you posting
stuff (I know sometimes there are bigger teams behind people) - the
pressure you're under to get something in is very clear.  A big part of
what I'm saying here is that it would be really helpful if could you
slow down a bit, discuss problems more and avoid cutting corners so
much.  This is likely to save you time overall, you'll have a much
higher success rate and you'll get much better feedback if it's clear
what's going on and that there's an interest in understanding the
issues.

If you need to focus on device tree enablement and there are underlying
problems in the subsystems you're looking at perhaps you need to push
back on whoever's asking you to do the work and say you need the domain
experts to pitch in and help you out.

> reality I am no more obliged to fix driver bugs than you are. In fact as
> the Maintainer of some of these subsystems, perhaps you could even help out
> a bit?

You're not telling us about the problems you see so it's very difficult
for anyone to help you.

For example with this patch the only information you've sent is the
patch and the fact that you're seeing the error you're ignoring going
off on the system you're working with (which I had to ask to find out
about...).  You've not shown the error message or provided any other
hint which would help anyone understand why the error might be occuring
and what a good solution to the problem is.  Ola's guess seems very
likely but nobody's got enough information to confirm that unless
there's been some off-list ST/Linaro communication.

Obviously with the stuff that's device specific you also have to contend
with the fact that you're working on hardware which just isn't all that
widely available and quite possibly has closed datasheets.

> We are all trying to do good things here. Please try not to be too over-
> critical. We all know Mainlining is a good thing. Perhaps less people
> would be so frightened of it, thus more people would do it if the reviews
> weren't such a ball-ache ( for want of a better expression :) ).

This is a two way thing - one of the tools that maintainers have to try
to drive up the quality of the code is to push back on poor quality
submissions and devote less bandwith to sources of those submissions.

It is true that there's a bunch of people who seem to view review as
being just an annoying obstacle to be dealt with with the minimum
possible effort but in practice all that does is make things more
painful for everyone, they do tend to be more noticable because
"applied, thanks" doesn't make for a big thread.
