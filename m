Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1FNIIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:08:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40091 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1FNIIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:08:45 -0400
Date: Tue, 14 Jun 2011 10:08:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch v4 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110614080824.GC29900@elte.hu>
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
 <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
 <20110613195613.GA11196@elte.hu>
 <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2011-06-13 at 12:56 -0700, Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > >  include/linux/stop_machine.h |   11 +++--
> > >  kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
> > >  2 files changed, 93 insertions(+), 9 deletions(-)
> > 
> > Btw., this is *way* too risky for a -stable backport.
> > 
> 
> Ingo, we can have a smaller patch (appended) for the -stable. How 
> do you want to go ahead? Take this small patch for both mainline 
> and -stable and the two code cleanup/consolidation patches for -tip 
> (to go into 3.1?). Thanks.

this:

>  arch/x86/kernel/cpu/mtrr/main.c |   15 ++++++++++++++-
>  include/linux/stop_machine.h    |   17 +++++++++++++++++
>  kernel/stop_machine.c           |   15 +++++++++++++++
>  3 files changed, 46 insertions(+), 1 deletions(-)

looks pretty risky as well, this is core kernel code that is 
relatively rarely used and if it breaks it causes various high impact 
regressions.

Once Tejun is fine with the code we can do the larger patch upstream 
but not mark it for -stable backport. Once it's been upstream for a 
couple of weeks, once we are sure it does not regress, can we perhaps 
forward it to -stable ...

Thanks,

	Ingo
