Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0L1Qkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 11:40:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48039 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751706Ab0L1Qkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 11:40:37 -0500
Date: Tue, 28 Dec 2010 16:40:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, "'Takashi Iwai'" <tiwai@suse.de>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassi.brar@samsung.com>
Subject: Re: linux-next: manual merge of the sound tree with the s5p tree
Message-ID: <20101228164047.GA2417@opensource.wolfsonmicro.com>
References: <s5hk4j0n43g.wl%tiwai@suse.de>
 <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
 <s5hvd2ku49r.wl%tiwai@suse.de>
 <004101cba294$8639de30$92ad9a90$%kim@samsung.com>
 <s5h7hf0tvct.wl%tiwai@suse.de>
 <008f01cba30a$72f5c160$58e14420$%kim@samsung.com>
 <20101224082736.GA31540@flint.arm.linux.org.uk>
 <018b01cba636$6c3a8390$44af8ab0$%kim@samsung.com>
 <20101228153948.GB14860@sirena.org.uk>
 <20101228162330.GA31226@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228162330.GA31226@flint.arm.linux.org.uk>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 04:23:30PM +0000, Russell King wrote:
> On Tue, Dec 28, 2010 at 03:39:48PM +0000, Mark Brown wrote:

> > Please keep myself and Liam in the CC on all ASoC discussion.

> You weren't included on Stephen's email.  Have you told Stephen which
> files he needs to notify you about?  I suspect Stephen operates by
> notifying the people who's trees clash, rather than selecting people
> based on files.

I suspect so too; the file patterns in MAINTAINERS cover it otherwise
(and originally the ASoC tree was actually getting merged first so the
right thing would've happened anyway).

> > > Of course, I know you need rebase you tree for it...so sorry for bothering.

> > This isn't going to help as it will just introduce the same duplicate
> > commits issue into the sound tree.  I'm still not clear what the
> > affected commits actually are but given that Stephen's original report
> > indicated that the ASoC changes are subsets of your changes would it not
> > make sense to just drop the relevant commits from your tree (which seems
> > to be rebased often, unlike the sound tree which doesn't rebase)?

> I don't think you read what I said (you probably didn't even see it.)

> What Kukjin has already done is looked in the ALSA tree, extracted the
> commits he wants from it, committed those into his tree, and based a
> pile of work on top of that.

Right, but looking at Stephen's original mail it seems like the bits
that are conflicting here are two different commits in the ASoC and
Samsung code where the ASoC version is a superset of the Samsung side
set.  If that analysis is correct then the ASoC commits will do the
right thing once they turn up in the Samsung tree so unless there's a
pressing reason for the Samsung versions they could just be dropped for
the time being.

> I said "don't do that" because it creates unnecessary duplications in
> the git history.  I suggested that if Kukjin needs commits from the ALSA
> tree, he asks the ALSA people for a commit in their tree to pull into
> his tree to base his code on instead.

Yes, which due to the lack of rebasing is hard to arrange except by
merging all of ASoC en masse (which someone already suggested).

> > Another option is to do a second round of merges after both sound and
> > ALSA trees with whatever the dependant commits are.

> If Kukjin has code which requires commits from the ALSA tree, and he
> doesn't have the ALSA tree, he can't build-test the code in his tree.
> Are you really suggesting that people should keep un-build-tested code
> in their trees, and push that un-tested code upstream when the dependent
> trees have merged?  Are you really suggesting that swathes of commits
> should not be bisectable?

No, I'm suggesting that a separate branch be maintained with the
affected commits which gets rebased and tested against -next or whatever
until everything they need hits the tree they need to be merged via.
The bulk of things go in as normal, then the extra commits are added in
a second merge later.  This is often required for practical testing when
there's a lot of work going on over the tree, even if it can be split up
neatly for merge.

This is annoying if it goes on for a long time but given that Linus is
likely to release this week that shouldn't be the case, and it assumes
the set of affected changes is small.  As I've no idea why the Samsung
side of the changes is there I don't know if that is the case or not.
