Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0DSVfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:35:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab0DSVfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:35:41 -0400
Date: Mon, 19 Apr 2010 23:35:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100419213529.GA855@elte.hu>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
 <20100416014712.GC15570@nowhere>
 <20100419212135.GN15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419212135.GN15159@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> On Fri, Apr 16, 2010 at 03:47:14AM +0200, Frederic Weisbecker wrote:
> > On Thu, Apr 15, 2010 at 05:25:10PM -0400, Don Zickus wrote:
> > > The new nmi_watchdog (which uses the perf event subsystem) is very
> > > similar in structure to the softlockup detector.  Using Ingo's suggestion,
> > > I combined the two functionalities into one file, kernel/watchdog.c.
> > > 
> > > Now both the nmi_watchdog (or hardlockup detector) and softlockup detector
> > > sit on top of the perf event subsystem, which is run every 60 seconds or so
> > > to see if there are any lockups.
> 
> Hello all,
> 
> After making a bunch of cleanups, I am stuck debating whether to continue 
> updating this patch on the stale branch perf/nmi on Ingo's tree or just 
> repost the whole patch again (which isn't much bigger just adds the 
> arch/x86/kernel/apic/hw_nmi.c piece).
> 
> Part of the new patch series includes removing kernel/nmi_watchdog.c, which 
> seemed kinda silly because it was only an intermediate file until things got 
> shifted to kernel/watchdog.c
> 
> Thoughts?

I'd prefer relative patches as the current perf/nmi bits are tested quite 
well.

Intermediate stages are not a problem: 90% of the code in the kernel's Git 
history is 'intermediate' as well, in hindsight. What matters is that the 
workflow that resulted was clean and that the patches were (and are) clean.

	Ingo
