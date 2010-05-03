Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab0ECNBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:01:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35039 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868Ab0ECNBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:01:05 -0400
Date: Mon, 3 May 2010 15:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] lockdep updates
Message-ID: <20100503130035.GA19763@elte.hu>
References: <1272648859-7203-1-git-send-regression-fweisbec@gmail.com>
 <20100503072331.GD6642@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503072331.GD6642@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull the core/locking branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	core/locking
> > 
> > Note there is also a merge of v2.6.34-rc6 because these patches
> > depend on older per cpu updates.
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (2):
> >       lockdep: Fix redundant_hardirqs_on incremented with irqs enabled
> >       lockdep: Simplify debug atomic ops
> > 
> > 
> >  kernel/lockdep.c           |    7 ++++++-
> >  kernel/lockdep_internals.h |   10 ++--------
> >  2 files changed, 8 insertions(+), 9 deletions(-)

this one is causing:

kernel/lockdep.c:2306: error: 'lockdep_stats' undeclared (first use in this function)
kernel/lockdep.c:2306: error: (Each undeclared identifier is reported only once
kernel/lockdep.c:2306: error: for each function it appears in.)

with these settings:

CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set

Thanks,

	Ingo
