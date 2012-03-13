Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2CMMAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:00:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34666 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2CMMAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:00:49 -0400
Date: Tue, 13 Mar 2012 12:00:14 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
	finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313120014.GB13220@flint.arm.linux.org.uk>
References: <20120313083310.GA27560@flint.arm.linux.org.uk> <20120313083630.GA10131@elte.hu> <20120313084713.GB27560@flint.arm.linux.org.uk> <20120313085628.GB6991@elte.hu> <20120313090040.GE27560@flint.arm.linux.org.uk> <20120313092649.GA15406@elte.hu> <20120313095020.GA13220@flint.arm.linux.org.uk> <20120313101859.GA2626@elte.hu> <20120313112729.GA25835@flint.arm.linux.org.uk> <20120313115640.GA27378@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313115640.GA27378@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:56:40PM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk@arm.linux.org.uk> wrote:
> 
> > On Tue, Mar 13, 2012 at 11:19:00AM +0100, Ingo Molnar wrote:
> > > 
> > > * Russell King <rmk@arm.linux.org.uk> wrote:
> > > 
> > > > On Tue, Mar 13, 2012 at 10:26:49AM +0100, Ingo Molnar wrote:
> > > > >
> > > > > As I said it in my first mail, doing that is unnecessary - 
> > > > > but if you insist on being difficult then Catalin, feel free 
> > > > > to pull the patch from tip:sched/arch:
> > > > 
> > > > Nope, I'm not taking the tree anymore, [...]
> > > 
> > > So instead of saying "sure, lets avoid conflicts next time 
> > > around" you are now *refusing* to take technically perfectly 
> > > fine patches just because another maintainer asked you to use a 
> > > different workflow for future patches? Wow ...
> > 
> > No, I'm pissed off at how you're treating me over this trivial issue,
> > so I'm taking the easy way out and getting out of the way.  If you want
> > to run your bit of the tree with idiotic rules about zero conflicts,
> > and "git solutions" then that's your perogative.  Just don't expect
> > other people to play with you.
> > 
> > The fact of the matter is that Peter Z. was fully aware of what was
> > happening.  He was aware that he'd been asked for his ack for that
> > patch (because I'd explicitly asked Peter for it, but not by email) -
> > and he provided his ack for that patch to Catalin:
> > 
> > http://lists.arm.linux.org.uk/lurker/message/20120227.144813.5614e7f8.en.html
> > 
> > Catalin sent a pull request to me, copying Peter Z on the 27th Feb:
> > 
> > http://lists.arm.linux.org.uk/lurker/message/20120227.164502.6b58a37e.en.html
> > 
> > I pulled it into my tree for testing, and pushed it out in the last
> > couple of days.
> > 
> > Moreover, these kinds of trivial conflicts are the type of things which
> > Linus wants to see between trees.  It allows him to get a feel for what's
> > going on, and makes Linus feel like he's more on top of things.  Linus
> > said that he would like to see these trivial conflicts (he said so to me
> > in an email dated 15th Jan 2011).
> > 
> > So please, stop your insistance on this zero conflict crap.
> 
> While I still think this is a storm in a teacup, I think you are 
> subtly misunderstanding Linus's position about conflicts and you 
> are seriously misrepresenting my request and my position as 
> well:
> 
> The thing is, most conflicts are fine in general. So on one hand 
> you are right, we *do* allow and quite often *keep* conflicts in 
> place even within our own topic branches.
> 
> Those are *real* conflicts that Linus would arguably be 
> interested in: two teams working on two things in parallel that 
> somehow conflict at the code level content-wise or concept-wise 
> - high level maintainers rightfully are curious about those 
> kinds of conflicts because while often they are just fine, it 
> might also be the canary of possible workflow problems or it 
> might also be the canary of the code being shaped in some 
> inefficient way.
> 
> On the other hand, this particular conflict you pushed to 
> linux-next is *neither*, and this is what got my attention. This 
> is a plain *STUPID* conflict.
> 
> Look into the fine conflict report Russell: it conflicts with 
> *Linus's* tree, because it's based off some random 
> barely-beyond-rc1 development window -rc3 base. Even at the 
> commit date of Feb 27 we had a more stable base tree available - 
> and especially when you pulled it, several weeks down the line, 
> -rc3 was not a defensible base for the integrated result.
> 
> Having a patch applied to an old scheduler tree that is barely 
> out of -rc1 and then pushing it out into linux-next at -rc8, 
> without even checking how it integrates with upstream, barely a 
> few days before the merge window is just plain stupid.
> 
> While nothing of what you talked to PeterZ is visible in the 
> public record, I'm quite sure had you asked him about what base 
> kernel to use, he'd have suggested something much more stable 
> ...

Why am _I_ responsible for which kernel version _Catalin_ used for _his_
patches when _he_ committed them?

You're insane.  Totally.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
