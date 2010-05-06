Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0EFGba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:31:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0EFGb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:31:29 -0400
Date: Thu, 6 May 2010 08:31:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
Message-ID: <20100506063116.GE1172@elte.hu>
References: <1272994165.1642.203.camel@laptop>
 <4BE0FB68.7080403@kernel.org>
 <1273050400.1642.229.camel@laptop>
 <4BE13B33.3030709@kernel.org>
 <1273053073.1642.235.camel@laptop>
 <4BE1406C.2000400@kernel.org>
 <1273059488.1642.245.camel@laptop>
 <4BE1648B.1080709@kernel.org>
 <20100505165532.GC14323@elte.hu>
 <1273083173.1642.250.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273083173.1642.250.camel@laptop>
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

> Well, I'd much rather just see a direct call in the code than having to 
> reverse engineer wth hangs onto that _EVENT() junk.

Direct calls into code were fine 10 years ago, but since then we got:

 - preempt notifiers
 - sw events
 - tracepoints

Which add up to a lot more than just a plain call into code.

Also, with the jump-optimizations we will have tracepoints that are _cheaper_ 
than a plain function call.

> Also, we don't need ABI muck for this.

we already have an ABIs in place here - this would just properly unify and 
enumerate it.

	Ingo
