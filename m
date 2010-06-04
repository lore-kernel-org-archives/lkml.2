Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0FDKEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:04:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0FDKEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:04:11 -0400
Date: Fri, 4 Jun 2010 12:03:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Arve Hj?nnev?g <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604100306.GB3324@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <20100603231153.GA11302@elte.hu>
 <20100603232302.GA16184@elte.hu>
 <1275644619.27810.39462.camel@twins>
 <1275645245.27810.39493.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275645245.27810.39493.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-06-04 at 11:43 +0200, Peter Zijlstra wrote:
> > I still believe containment is a cgroup problem. The freeze/snapshot/resume
> > container folks seem to face many of the same problems. Including the
> > pending timer one I suspect. Lets solve it there. 
> 
> While talking to Thomas about this, we'd probably need a CLOCK_MONOTONIC 
> namespace to pull this off, so that resumed apps don't see the jump in 
> absolute time.
> 
> This would also help with locating the relevant timers, since they'd be on 
> the related timer base.

Ok - this looks workable, and looks technically isolated that can be pursued 
as a separate module of this whole topic.

> The only 'interesting' issue I can see here is that if you create 1000 
> CLOCK_MONOTONIC namepaces, we'd need to have a tree of trees in order to 
> efficiently find the leftmost timer.

Realistically Android userspace would create just a single such namespace for 
all the untrusted/unknown/uncontrolled apps, right?

	Ingo
