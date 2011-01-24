Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1AXVZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:25:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1AXVZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:25:52 -0500
Date: Mon, 24 Jan 2011 22:25:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110124212526.GA13724@elte.hu>
References: <20110124133400.GA1228@elte.hu>
 <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
 <20110124200738.GA10833@elte.hu>
 <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
 <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com>
 <20110124203802.GC29975@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124203802.GC29975@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Jan 25, 2011 at 06:27:31AM +1000, Linus Torvalds escreveu:
> > On Tue, Jan 25, 2011 at 6:17 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > It only happens for me with "g". With "perf record -af sleep 10" it worked.
> > 
> > Actually, it's something subtler than that. It must depend on the
> > actual data, because now when I tried it again, it worked with 'g'
> > too. I hadn't saved the old perf.data that caused the lockup (it got
> > overwritten by the non-g test), and now when I try to re-create it it
> > doesn't hang on the result.
> > 
> > So it's probably some very specific data pattern that causes it.
> > 
> > (And I don't know if it's a hard hang - it could just be something
> > _very_ slow. But we're talking half a minute kind of slow).
> 
> Was this on a freshly installed machine? Or on a freshly updated one?
> 
> Probably its the build-id collecting at the end of a session, on the
> first run you had a cold cache and it had to figure out which binaries
> to cache on ~/.debug, second time it was already cached so it was fast.

Hm, it would be nice to not surprise users with an unlimited-timeout, up to half a 
minute 'frozen' app. Can we possibly display a more finegrained progress indicator?

Thanks,

	Ingo
