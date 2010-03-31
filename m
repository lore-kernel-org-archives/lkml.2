Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab0CaVrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:47:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab0CaVrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:47:19 -0400
Date: Wed, 31 Mar 2010 23:47:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100331214701.GA27833@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
 <4BB2EB1B.8090303@zytor.com>
 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <20100331185916.GA12306@elte.hu>
 <v2m21d7e9971003311357ga4626e41h535ae733933fdc84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v2m21d7e9971003311357ga4626e41h535ae733933fdc84@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> On Thu, Apr 1, 2010 at 4:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * James Morris <jmorris@namei.org> wrote:
> >
> >> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
> >>
> >> > On 03/30/2010 09:49 PM, James Morris wrote:
> >> > >
> >> > > Please make NO_BOOTMEM default to n, at least for amd64, where I've found
> >> > > that it leads to all kinds of strange, undebuggable boot hangs and errors
> >> > > (with relatively current Fedora development userland).
> >> >
> >> > Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
> >>
> >> Yes, it was happening with -rc3.
> >
> > Could you please send the bootlog that Yinghai asked for, plus also one that
> > you get with NO_BOOTMEM turned off (for comparison)?
> >
> > Also, when did you first hit this bug? This code has been upstream for almost
> > a month, and it was in linux-next before that - so you should have hit this
> > much sooner. A rough timeframe would suffice. I suppose you were booting
> > upstream kernels during the merge window as well?
> 
> A default y config option causing regressions still at rc3? and you guys 
> keep going? This is the sort of shit Linus would flame me for a day or two 
> for,
> 
> Can we get some f'ing consistency here?

Note, without trying to defend the bootmem conversion itself, which didnt work 
out well, this is not some optional new driver feature that was default-y 
randomly but it was an infrastructure change that was to be made unconditional 
in .35.

The flag was basically a testing/debug flag to allow the old code to be used 
too, in case the new code was buggy. This is what helped James to report this 
today, instead of forcing James through a very difficult ~14-reboot bisection.

Thanks,

	Ingo
