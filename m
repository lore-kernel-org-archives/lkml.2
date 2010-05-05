Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab0EEQ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:56:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45789 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab0EEQ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:56:08 -0400
Date: Wed, 5 May 2010 18:55:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
Message-ID: <20100505165532.GC14323@elte.hu>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
 <1272994165.1642.203.camel@laptop>
 <4BE0FB68.7080403@kernel.org>
 <1273050400.1642.229.camel@laptop>
 <4BE13B33.3030709@kernel.org>
 <1273053073.1642.235.camel@laptop>
 <4BE1406C.2000400@kernel.org>
 <1273059488.1642.245.camel@laptop>
 <4BE1648B.1080709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE1648B.1080709@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 05/05/2010 01:38 PM, Peter Zijlstra wrote:
> > As it stands I'd argue to simply drop this whole idea. The SCHED_EVENT()
> > thing doesn't look like its worth the obfuscation and I'm very much
> > opposed to making perf and sched_notifiers rely on tracepoints.
> 
> Hmmm... okay.  Well, this thing is born out of Ingo's suggestion that for 
> more sched notifiers to be added notification mechanisms need to be 
> consolidated.  As long as I can get those two notifiers needed for cmwq, 
> it's okay with me.  Ingo, what do you think?

I'd much rather see the *_EVENT() APIs used - but enhanced to address Peter's 
objections. One change would be to add a DEFINE_EVENT_ABI() variant, which 
would be called via trace_abi_*() calls. That way we always know they are 
'hardwired' events in the extreme.

That then would allow the software events to be consolidated.

Peter?

	Ingo
