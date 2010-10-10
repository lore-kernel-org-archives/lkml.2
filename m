Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0JJOGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:06:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab0JJOGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:06:11 -0400
Date: Sun, 10 Oct 2010 16:05:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
Message-ID: <20101010140554.GB20400@elte.hu>
References: <20101008213429.GB7223@sgi.com>
 <4CAFA1DB.6010802@kernel.org>
 <20101009125944.GA18248@sgi.com>
 <20101009163908.GX14068@sgi.com>
 <20101010104129.GB30271@elte.hu>
 <20101010104319.GA9862@elte.hu>
 <20101010114459.GY14068@sgi.com>
 <20101010115605.GC14064@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010115605.GC14064@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> On Sun, Oct 10, 2010 at 06:44:59AM -0500, Robin Holt wrote:
> > On Sun, Oct 10, 2010 at 12:43:19PM +0200, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Robin Holt <holt@sgi.com> wrote:
> > > > 
> > > > > On Sat, Oct 09, 2010 at 07:59:45AM -0500, Russ Anderson wrote:
> > > > > > Yes, Yinghai's patch fixes the problem.
> > > > > > Thank you very much.
> > > > > 
> > > > > Will this be included in 2.6.36?  It is needed for boot in order for UV
> > > > > systems to boot.
> > > > 
> > > > -tip uses memblock APIs. If this happens with vanilla -git as well 
> > > > then we need a bootmem backport for the fix.
> > > 
> > > And to answer your question: yes, we can queue it up for -final as well 
> > > if it's a recent regression - 'doesnt boot at all' bugs are nasty. But 
> > > i'm not sure this is a bootmem problem so please double check vanilla 
> > > v2.6.36-rc7 as well.
> > 
> > The 36-rc7 kernel does not boot at all either.  I don't have any 
> > decent debug tools to dig in further.  It does fail on the same 
> > machine that Russ was testing with, but passes on any that have a 
> > single blade as the kernel Russ first identified as being a problem 
> > had.  Based upon my vague recollection of the boot messages, it 
> > appears to fail in a similar point in boot.  I would assume it is a 
> > similar problem.
> 
> 2.6.35 fails as well.  I will bisect for as long as time permits.

That's really bad. If this means that you have not booted vanilla 
mainline on UV in that timeframe _at all_, and that it was perma-broken 
since 2009 when that commit Yinghai identified went upstream, then 
there's little point in squeezing this fix into v2.6.36-final.

-rcs are strictly for regression fixes.

If you want upstream to care about you then you absolutely have the duty 
to at minimum test latest mainline ...

Thanks,

	Ingo
