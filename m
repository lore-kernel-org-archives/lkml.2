Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0FFT2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:28:41 -0400
Received: from www.tglx.de ([62.245.132.106]:43405 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab0FFT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:28:40 -0400
Date: Sun, 6 Jun 2010 21:26:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Swetland <swetland@google.com>
cc: James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTilRbTVbjAt9uodpzecHLUmcDQEKT_EVpjyrSIwn@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006062114550.2933@localhost.localdomain>
References: <1275834706.7227.545.camel@mulgrave.site> <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain> <1275844114.7227.552.camel@mulgrave.site> <alpine.LFD.2.00.1006061932240.2933@localhost.localdomain>
 <AANLkTilRbTVbjAt9uodpzecHLUmcDQEKT_EVpjyrSIwn@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, Brian Swetland wrote:

> On Sun, Jun 6, 2010 at 11:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> Right, so the sooner we make it easier for the drivers to use the kernel
> >> as their main repository, the better.
> >
> > Yep, the fastest way is to provide two stub inlines in pm.h and let
> > the driver flood come in.
> 
> As mentioned previously, we didn't know this was an option (stubs
> without an implementation behind them).  If it is, and thus we can

That's what Greg did when he pulled stuff into staging, but there is
no reason not to do it outside of staging as well. We can simply put
the stub functions into Documentation/feature-removal.txt to ensure
that we don't forget about them :)

> simplify the driver merging process short-term while sorting out a
> long-term implementation or replacement for suspend blockers, then I
> think we're making real progress.

Yes, that way we do not lose the annotations. Replacing them, ripping
them out or whatever we agree on, is a nobrainer.

But it gets the drivers into the tree, so they are usable outside of
android as well and the delta between android and mainline shrinks
significantly.

Thanks,

	tglx
