Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1CUQix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:38:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51470 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753512Ab1CUQiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:38:52 -0400
Date: Mon, 21 Mar 2011 16:38:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110321163849.GF2570@opensource.wolfsonmicro.com>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
 <20110321161102.GB23614@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321161102.GB23614@elte.hu>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 05:11:02PM +0100, Ingo Molnar wrote:
> * Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > As indicated that's not a good fix since the affected code is all runtime 
> > conditional already. [...]

> Well, AFAICS Randy's patch correctly expresses current infrastructure 
> dependencies the driver has.

That's because the driver code is trivially broken, though - the build
test has identified a flaw in the driver which we should fix.

> SND_SOC_ALL_CODECS=y but !REGULATOR case, i.e. if it's desirable to have the 
> driver build more widely, then that can be enhanced further - but first please 
> If it's undesirable to disable the driver in the (unlikely but possible) 
> get things to build.

Right, and as I indicated in my reply Zeng said he'd fix this.  I'd
rather encourage vendors to take responsibility for their own drivers.

> > [...]  It'd be more likely to impede than help the sort of build coverage 
> > tests where one would encounter it.

> It's an invariant mostly - both Randy's and my testing will find breakages 
> regardless of how restrictively enabled this driver is.

My point is that this is the build test equivalent of using memset to
fix uninitialised variables, it's making the test pass rather than
making things work.  When fixing this sort of thing you need to at least
consider if the appropriate fix is to knock out the whole thing in
Kconfig or to make sure the code copes with the dependency set either
way.
