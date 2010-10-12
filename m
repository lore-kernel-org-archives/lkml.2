Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0JLKCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:02:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49277 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab0JLKCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:02:42 -0400
Date: Tue, 12 Oct 2010 12:02:35 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101012100235.GH29673@pengutronix.de>
References: <20101012103314.41b00cbe.sfr@canb.auug.org.au> <20101012080354.GC29673@pengutronix.de> <20101012082814.GC12845@flint.arm.linux.org.uk> <20101012092357.GE29673@pengutronix.de> <20101012094208.GD12845@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101012094208.GD12845@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, Oct 12, 2010 at 10:42:08AM +0100, Russell King wrote:
> On Tue, Oct 12, 2010 at 11:23:57AM +0200, Uwe Kleine-König wrote:
> > Hi Russell,
> > 
> > On Tue, Oct 12, 2010 at 09:28:14AM +0100, Russell King wrote:
> > > On Tue, Oct 12, 2010 at 10:03:54AM +0200, Uwe Kleine-König wrote:
> > > > On Tue, Oct 12, 2010 at 10:33:14AM +1100, Stephen Rothwell wrote:
> > > > > Hi Russell,
> > > > > 
> > > > > Today's linux-next merge of the arm tree got a conflict in
> > > > > arch/arm/mach-imx/mach-cpuimx27.c between commit
> > > > > 4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
> > > > > selection") from the arm-current tree and commit
> > > > > 77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
> > > > > to add imx-i2c devices") from the arm tree.
> > > A more concerning question is - these recent conflicts have been happening
> > > as a result of merging people's GIT trees, which tend to be sent close
> > > to the merge window.
> > > 
> > > If the first time their changes become visible to linux-next is when
> > > they're merged into my tree, something is wrong...
> > I tried to reconstruct that.  I guess I cannot see yet that Russell took
> > 4793ca4028e4dcdbf2740db50995c9378ded3cf8 because I have no access to
> > Russell's kernel.org repo and his ftp.arm.linux.org.uk repo currently
> > barfs for me and Stephen didn't push out a tree newer than 20101011 yet.
> 
> What's up with it?  What URL are you using?

	http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm.git/

and it fails for me with

	ukl@octopus:~/gsrc/linux-2.6$ git fetch rmk
	error: Unable to find 81490fcdf406f42fff9d9f57d541788f90242885 under
	http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm.git
	Cannot obtain needed commit 81490fcdf406f42fff9d9f57d541788f90242885
	while processing commit d7840ed08bf6f74677a6b2b21b96269180be9eb6.
	error: Fetch failed.

I'm trying to reproduce with 

	git clone --reference ~/gsrc/linux-2.6 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git t
	cd t
	git remote add -f rmk http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm.git/

... sometime later ...

works, so something in my repo seems to be the problem.  I assume a pack
file is corrupt?!  Hmm, I'll try to remove all packs I got from your
repo ...

... wget ... sed $magic ... rm $(cat filelist)

	ukl@octopus:~/gsrc/linux-2.6$ git fetch rmk
	 + 86c4743...74a4333 devel      -> rmk/devel  (forced update)
	   aa30900..c9ee46a  devel-stable -> rmk/devel-stable
	   d907387..a581da1  master     -> rmk/master
	   151b6a5..85a3318  origin     -> rmk/origin

\o/

I guess the problem is that I "Ctrl-C"d an earlier git fetch.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
