Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1CRHHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:07:08 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:17787 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1CRHHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:07:04 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3oEdRSaFcDcJC9Yr951Ks
Date: Fri, 18 Mar 2011 00:06:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110318070654.GB3555@atomide.com>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [110317 19:48]:
> On Thu, Mar 17, 2011 at 11:30 AM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > Please pull omap changes for this merge window from:
> 
> Gaah. Guys, this whole ARM thing is a f*cking pain in the ass.
> 
> You need to stop stepping on each others toes. There is no way that
> your changes to those crazy clock-data files should constantly result
> in those annoying conflicts, just because different people in
> different ARM trees do some masturbatory renaming of some random
> device. Seriously.
> 
> That usb_musb_init() thing in arch/arm/mach-omap2/usb-musb.c also
> seems to be totally insane. I wonder what kind of insanity I'm missing
> just because I don't happen to see the merge conflicts, just because
> people were lucky enough to happen to not touch the same file within a
> few lines.

This merge conflict was really unfortunate, the plan was to queue
driver related changes via the usb-devel list and the platform init
changes via the linux-omap list. But obviously something went wrong..

Anyways, we are close to done making the platform init code shared
between omaps and then drivers become arch independent. So things
should get easier for next merge window already.
 
> Somebody needs to get a grip in the ARM community. I do want to do
> these merges, just to see how screwed up things are, but guys, this is
> just ridiculous. The pure amount of crazy churn is annoying in itself,
> but when I then get these "independent" pull requests from four
> different people, and they touch the same files, that indicates that
> something is wrong.

Well in this case the conflicts were between driver changes and arch
related changes :) For the ARM and various ARM related SoC changes
there is a lot of work going on to make things more generic. So with
that the crazy churn should also ease, but it takes a lot of work to
get there.
 
> And stop the crazy renaming already! Just leave it off. Don't rename
> boards and drivers "just because", at least not when there clearly are
> clashes. There's no point. I'm not even talking about the file renames
> (which happened and can also make it "fun" to try to resolve the
> conflicts when somebody else then makes _other_ changes), but about
> the stupid "change human-readable names in board files just to annoy
> whoever needs to merge the crap".

OK, point taken. One part of the problem here are the current dependencies
between the driver code and platform code which makes it hard to patch
one without the other. Hopefully this will too ease as the drivers
become separated from the platform code.
 
> Somebody in the ARM community really needs to step up and tell people
> to stop dicking around.
>
> (I'm replying to the omap pull request, because that's the one I did
> last, but I don't know who to "blame". I don't care. It really doesn't
> matter. I realize thar ARM vendors do crazy shit and haven't figured
> out this whole "platform" thing yet, but you guys need to push back on
> the people sending you crap).

OK we'll pass on the message.

Regards,

Tony
