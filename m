Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2BVHdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:33:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab2BVHdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:33:08 -0500
Date: Wed, 22 Feb 2012 08:32:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222073251.GB17291@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329856745.25686.72.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2012-02-21 at 15:20 -0500, Jason Baron wrote:
> 
> > I'm not really too hung up on the naming, but I did think 
> > that very_[un]likely were an interesting possibility.
> 
> The problem comes from what Peter said. They are too similar 
> to "likely()" and "unlikely()", and can become confusing.

See my other mail.

> Maybe "static_likely()" and "static_unlikely()" as the word 
> "static" can imply something strange about these. Or perhaps a 
> "const_likely()"?
> 
> Maybe "dynamic_branch_true()" and "dynamic_branch_false()". This may be
> the most descriptive.

too long.

'static branch' or 'static condition' is not a bad concept, if 
people don't find the similarity to 'static' too confusing ;-).

But it is fundamentally mixing execution and *data type* and it 
is not conveying the build time bias properly.

So the best high level naming would be something like:

	struct static_condition static_flag = STATIC_COND_FALSE;


	if (very_unlikely(&static_flag)) {
		...
	}

	...

	static_cond_inc(&static_flag);
	...
	static_cond_dec(&static_flag);


See how *both* the build time bias and the cost of a state 
transition is properly conveyed?

I suggested something like this to Jason in the off-list 
discusion and it's not fully implemented yet. Let me whip up a 
test branch [pun and potential confusion unintended] that shows 
it.

Thanks,

	Ingo
