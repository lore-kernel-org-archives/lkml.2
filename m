Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0HWIx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:53:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0HWIxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:53:53 -0400
Date: Mon, 23 Aug 2010 10:53:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100823085339.GA26713@elte.hu>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820152510.GA4167@elte.hu>
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
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > I'll test tip later today to see if I can reproduce it.
> > 
> > Cheers,
> > Don
> > 
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > >
> > >it's not working so well, i'm getting:
> > >
> > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > Do you have a strange power saving mode enabled?
> > > Dazed and confused, but trying to continue
> > >
> > >on a nehalem box, after a perf top and perf stat run.
> 
> FYI, it does not trigger on an AMD box.

Ok, to not hold up the perf/urgent flow i zapped these two commits for 
the time being:

 4a31beb: perf, x86: Fix handle_irq return values
 8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU

We can apply them if they take a form that dont introduce a different 
kind of (and more visible) regression.

Thanks,

	Ingo
