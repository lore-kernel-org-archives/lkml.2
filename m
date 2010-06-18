Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452Ab0FRKbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:31:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759218Ab0FRKbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:31:15 -0400
Date: Fri, 18 Jun 2010 12:30:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618103058.GA8934@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
 <20100614135403.GH4894@redhat.com>
 <20100614144403.GA369@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614144403.GA369@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4509]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > I think the perf event subsytem can log events in NMI context already and 
> > deliver them to userspace when the NMI is done.  This is why I think Ingo 
> > wants MCE to be updated to sit on top of the perf event subsytem to avoid 
> > re-invent everything again.
> 
> perf is not solving the problem this is trying to solve.

That is why i requested to extend the events backend. That will unify more of 
the code than the first few steps achieved by these three patches - and offers 
the functionality to all code that uses the events framework.

> [...]
>
> perf does not fit into this because it has no way to process such an event 
> inside the kernel.

It 'does not fit' into the events backend only if you pretend that it is 
impossible or undesirable to have a delayed, in-context callback mechanism 
implemented there.

If you look at it more closely you'll notice that in reality it's not only 
possible but that it is also a pretty natural fit.

Thanks,

	Ingo
