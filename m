Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2FPAVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:21:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab2FPAVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:21:25 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=R5I9ChW_JYgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=rs3dCQBxvbIYi4zThekA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339806080.25903.68.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH tip/core/rcu 09/15] rcu: Increasing rcu_barrier()
 concurrency
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Fri, 15 Jun 2012 20:21:20 -0400
In-Reply-To: <20120615233151.GA7613@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
	 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1339794370-28119-9-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120615233151.GA7613@leaf>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 16:31 -0700, Josh Triplett wrote:
>   
> > -	smp_mb();  /* Prevent any prior operations from leaking in. */
> > +	/*
> > +	 * Ensure tht all prior references, including to ->n_barrier_done,
> > +	 * are ordered before the _rcu_barrier() machinery.
> > +	 */
> > +	smp_mb();  /* See above block comment. */
> 
> If checkpatch complains about the lack of a comment to the right of a
> barrier even when the barrier has a comment directly above it, that
> seems like a bug in checkpatch that needs fixing, to prevent developers
> from having to add noise like "See above block comment.". :)


Yuck yuck yuck yuck!!!


Really, checkpatch is not the golden rule. I've copied an old checkpatch
from something like 2.6.38 or so and use that today, where it was still
reasonable. I've long abandoned the latest checkpatch, as it causes too
many false positives. Or nazis like dictation.

My rule of thumb is this. If what checkpatch tells you to do makes the
format either uglier, or look stupid, it's a good idea to ignore the
checkpatch complaint.

I think in this case, you hit the latter.

-- Steve


