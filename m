Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2ARMHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:07:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab2ARMHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:07:31 -0500
Date: Wed, 18 Jan 2012 13:07:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL][v3.3] tracing: Add header wrappers
 event_headers_start.h and event_headers_end.h
Message-ID: <20120118120711.GB14863@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
 <20120117095418.GG10397@elte.hu>
 <1326807145.17534.26.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326807145.17534.26.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2012-01-17 at 10:54 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> 
> > Hm, i don't really like the extra complexity - this code 
> > *really* does not need any more complexity ...
> 
> I agree.
> 
> > 
> > How about the low-tech solution of adding some text between
> > '/* */' markers to warns that these headers should not be 
> > included in ordinary headers?
> 
> The problem is that they currently are. For example:
> 
> include/linux/interrupt.h
> 
> has one to add a tracepoint in __raise_softirq_irqoff()
> 
> Which is fine, as long as no other tracepoint header includes
> linux/interrupt.h.

Could we try to remove this one from the header?

I'd argue that __raise_softirq_irqoff() should not be inline - 
that would solve a whole host of issues. Event tracing is 
enabled in most distros so there's no real overhead argument to 
be made here either - so it's probably a bit faster in fact to 
have this uninlined. What do you think?

Thanks,

	Ingo
