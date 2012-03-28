Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2C2B0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:26:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42792 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab2C2BZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:25:22 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>
In-Reply-To: <20120326082515.GB20638@sortiz-mobl>
References: <20120323143237.9b5917955cb42951f0368ec4@canb.auug.org.au> <20120323094139.GA7231@sortiz-mobl> <20120324173152.494DA3E0A26@localhost> <20120326082515.GB20638@sortiz-mobl>
Date: Wed, 28 Mar 2012 16:47:18 -0600
Message-Id: <20120328224718.8C7B33E0E4D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 10:25:15 +0200, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Sat, Mar 24, 2012 at 05:31:52PM +0000, Grant Likely wrote:
> > On Fri, 23 Mar 2012 10:41:39 +0100, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > > Hi Stephen,
> > > 
> > > On Fri, Mar 23, 2012 at 02:32:37PM +1100, Stephen Rothwell wrote:
> > > > Hi Samuel,
> > > > 
> > > > Today's linux-next merge of the mfd tree got a conflict in
> > > > drivers/mfd/twl-core.c between commits 5769089ac725 ("mfd: twl-core.c:
> > > > Fix the number of interrupts managed by twl4030"), 75294957be1d
> > > > ("irq_domain: Remove 'new' irq_domain in favour of the ppc one") and
> > > > 964dba283439 ("devicetree: Add empty of_platform_populate() for !
> > > > CONFIG_OF_ADDRESS (sparc)") from Linus' tree and commits 9e1786202704
> > > > ("mfd: Make twl-core not depend on pdata->irq_base/end") and 78518ffa08fc
> > > > ("mfd: Move twl-core IRQ allocation into twl[4030|6030]-irq files") from
> > > > the mfd tree.
> > > > 
> > > > I *think* that the right thing to do is to use the version from the mfd
> > > > tree ...
> > > That's correct.
> > > I have a for-next-merge branch where I usually have the merge conflicts with
> > > Linus tree fixed, in case you're interested.
> > > 
> > > 
> > > > I do wonder why I only got this now (in the merge window) ...
> > > I got a pull request from Benoit a couple days before the merge window opened.
> > > Then I realized part of the pull request contained a merge of one of Grant's
> > > branch. So I wanted to wait for Grant's code to get in before picking the mfd
> > > work on top of it. I didn't want to send a pull request to Linus with a merge
> > > point for something that would have been already merged. Maybe I was wrong,
> > > you tell me.
> > 
> > It should have gone into linux-next before then.  Waiting for my tree
> > to hit linus' tree defeats the purpose of linux-next.  Now you're
> > branch hasn't had any testing and therefore is a risky merge.
> The branch has been tested by TI folks, on 3 different TI platforms. And the
> patches we're talking about are all TI's twl related ones.

...hasn't had any integration testing.  It isn't the risk to your
platform that is the concern (indeed, I'd expect it to be tested on
the TI platforms).  It's the risk of breakage to other users that is
the issue.  That's why linux-next exists, to catch post-merge breakage
before the merge window opens, and that is why it is important to get
the branches in before the window opens.

In fact, this exact driver caused problems in linux-next before the
merge window opened that affected Randy Dunlap and Andrew Morton.
The irq_domain changes caused twl build failures on allmodconfig.  So,
even though it is "only" driver code being touched here, it still
affects the larger kernel community.

g.
