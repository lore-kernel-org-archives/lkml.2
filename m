Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2FZXFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:05:18 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48819 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab2FZXFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:05:16 -0400
Date: Tue, 26 Jun 2012 16:05:03 -0700
From: Mike Turquette <mturquette@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: linux-next: adding the common clk tree
Message-ID: <20120626230503.GA4402@gmail.com>
References: <20120626015551.GW4402@gmail.com>
 <20120626132502.7584f6acbfc23bdc3d6a8f8e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626132502.7584f6acbfc23bdc3d6a8f8e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120626-13:25, Stephen Rothwell wrote:
> Hi Mike,
> 
> On Mon, 25 Jun 2012 18:55:51 -0700 Mike Turquette <mturquette@ti.com> wrote:
> >
> > Would you please add the clk-next branch of the common clock tree to
> > linux-next?
> > 
> > git://git.linaro.org/people/mturquette/linux.git clk-next
> > 
> > Thanks much!
> > 
> > For all of those Cc'd, I just wanted to say that I'm changing the way I
> > manage clk-next.  The clk-next branch now WILL be rebased, and it's only
> > purpose is to make it easy to test things in linux-next.  You can base
> > work on it, but be prepare for breakage and shifting commit ids.
> > 
> > If you don't want breakage and shifting commit ids then you might want
> > to use my clk-fixes branch (stable) and my clk-3.x branch (stable).  As
> > patches go through the linux-next cycle and appear stable I'll migrate
> > them over to clk-3.x which won't ever be rebased.  This is the branch
> > I'll send to Linus.  clk-next is simply comprised of merging clk-fixes,
> > clk-3.x and whatever unstable patches I have laying around.
> 
> Maybe you have misunderstood the point of linux-next (is is an
> integration testing tree, not a development tree)?  I am wondering if, in
> particular, the clk-3.x branch (or something near that) may be more
> appropriate for linux-next inclusion (and maybe the clk-fixes branch in
> my "fixes to the current release" section)?
> 

Hi Stephen,

Let me explain how I planned to use linux-next and you can tell me if I
have it all wrong.

I had hoped to have three public branches:

clk-fixes which would be fixes for the current -rc series

clk-3.x which would be stable (never rebased) that I building up towards
the next merge window

clk-next which would be the branch for you to pull

clk-next would essentially be built as the following:

git checkout clk-next
git reset --hard $linus-latest-tag
git merge clk-fixes (only if not yet merged into the -rc bugfix window)
git merge clk-3.x
git am patches/clk/next/incoming/*.patch

The goal would be to move patches out of the 'incoming' directory and
into clk-3.x as soon as they had made it through a couple of rounds in
linux-next and no one complained that things were broken.  All of this
was just to keep clk-3.x very stable and not have me reverting or
makings lots of little fixes to that as folks reported issues on the
list.

In fact, my goal is that the 'incoming' patches directory would be empty
and clk-next would only be a fast-forward merge of clk-3.x by the time
Linus' merge window opens.  So in that regard I am following the
guidelines to treat my pull request to linux-next as the same thing I
would send to Linus.

Finally, I have never meant to throw bad patches at linux-next, so
perhaps I shouldn't have used the term "breakage" in my above mail.  I
only meant that from the perspective of downstream developers pulling a
rebased clk-next branch.  I do not intend to put patches into linux-next
which are not unit tested first.

So please let me know if I still have the concept wrong and I'll change
things up.  Otherwise my clk-next fulfils all of the guidelines you've
mentioned below for inclusion into linux-next.

Thanks much,
Mike

> This is what I tell everyone:
> 
> You will need to ensure that the commits in your tree have been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and 
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
> 
> -- 
> Cheers,
> Stephen Rothwell	sfr@canb.auug.org.au


