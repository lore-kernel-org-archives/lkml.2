Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0FDIQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:16:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0FDIQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:16:14 -0400
Date: Fri, 4 Jun 2010 10:15:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604081538.GC15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <20100603231153.GA11302@elte.hu>
 <20100603232302.GA16184@elte.hu>
 <alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
 <20100603234634.GA21831@elte.hu>
 <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org>
 <20100603204521.09808a7f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603204521.09808a7f@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 3 Jun 2010 19:26:50 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > If the system is idle (or almost idle) for long times, I would heartily 
> > recommend actively shutting down unused cores. Some CPU's are hopefully 
> > smart enough to not even need that kind of software management, but I 
> > suspect even the really smart ones might be able to take advantage of the 
> > kernel saying: "I'm shutting you down, you don't have to worry about 
> > latency AT ALL, because I'm keeping another CPU active to do any real 
> > work".
> 
> sadly the reality is that "offline" is actually the same as "deepest C 
> state". At best.
> 
> As far as I can see, this is at least true for all Intel and AMD cpus.
> 
> And because there's then no power saving (but a performance cost), it's 
> actually a negative for battery life/total energy.
> 
> (lots of experiments inside Intel seem to confirm that, it's not just 
> theory)

Well, the scheme would only be useful if it's _NOT_ just a deep C4 state, but 
something that prevents tasks from being woken to that CPU for a good period 
of time. Hot-unplugging that CPU achieves that (the runqueues are pulled), so 
i think in Linus's idea makes sense in principle.

[ Or have you done deep-idle experiments to that effect as well? ]

I suspect it all depends on the cost: and our current hot-unplug and 
hot-replug code is all but cheap ...

	Ingo
