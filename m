Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1CUQLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:11:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab1CUQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:11:39 -0400
Date: Mon, 21 Mar 2011 17:11:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110321161102.GB23614@elte.hu>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321155836.GE2570@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Mar 21, 2011 at 04:37:19PM +0100, Ingo Molnar wrote:
> 
> > has been pushed upstream - although the build breakage was reported against 
> > linux-next two weeks ago, with fix provided, in this lkml thread:
> > 
> >   [PATCH -next] soc: sgtl5000 uses regulator interfaces
> 
> Zheng, you said you'd provide a better patch for this but I've heard
> nothing since?  It's a trivial change you need to make...
> 
> > Please do not push known-broken code upstream.
> 
> That seems like an overreaction, it'll only show up in fairly unrealstic 
> randconfigs [...]

I've seen it trigger with a likelyhood of about 20%, that's not unrealistic.

> [...] and can be trivially avoided by anyone who actually needs the driver - 
> core things like all*config won't be affected, and right now it'll only come 
> up at all if you enable SND_SOC_ALL_CODECS which is purely about build 
> coverage.
> 
> > Randy's fix below resolved the bug for me.
> 
> As indicated that's not a good fix since the affected code is all runtime 
> conditional already. [...]

Well, AFAICS Randy's patch correctly expresses current infrastructure 
dependencies the driver has.

If it's undesirable to disable the driver in the (unlikely but possible) 
SND_SOC_ALL_CODECS=y but !REGULATOR case, i.e. if it's desirable to have the 
driver build more widely, then that can be enhanced further - but first please 
get things to build.

> [...]  It'd be more likely to impede than help the sort of build coverage 
> tests where one would encounter it.

It's an invariant mostly - both Randy's and my testing will find breakages 
regardless of how restrictively enabled this driver is.

Thanks,

	Ingo
