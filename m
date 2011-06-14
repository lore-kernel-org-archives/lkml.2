Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1FNVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:17:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab1FNVRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:17:25 -0400
Date: Tue, 14 Jun 2011 23:17:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "tj@kernel.org" <tj@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch v4 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110614211708.GC12249@elte.hu>
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
 <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
 <20110613195613.GA11196@elte.hu>
 <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
 <20110614101038.GH8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614101038.GH8141@htj.dyndns.org>
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


* tj@kernel.org <tj@kernel.org> wrote:

> Hello, Ingo, Suresh.
> 
> On Mon, Jun 13, 2011 at 01:49:18PM -0700, Suresh Siddha wrote:
> > On Mon, 2011-06-13 at 12:56 -0700, Ingo Molnar wrote:
> > > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > 
> > > >  include/linux/stop_machine.h |   11 +++--
> > > >  kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
> > > >  2 files changed, 93 insertions(+), 9 deletions(-)
> > > 
> > > Btw., this is *way* too risky for a -stable backport.
> > > 
> > 
> > Ingo, we can have a smaller patch (appended) for the -stable. How do you
> > want to go ahead? Take this small patch for both mainline and -stable
> > and the two code cleanup/consolidation patches for -tip (to go into
> > 3.1?). Thanks.
> 
> So, here's what I think we should do.
> 
> * Polish up this simpler patch and send it for 3.0 through -tip.  It's
>   slightly scary but not too much and fixes a real bug.  After a
>   while, we can ask -stable to pull the simple version.

Looks good to me.

> * Work on proper update which drops custom implementation from mtrr
>   code for 3.1 window.  BTW, even after the recent revisions, I think
>   the stop machine change is a bit too hacky.  I'll reply to that
>   separately.

ok.

Thanks,

	Ingo
