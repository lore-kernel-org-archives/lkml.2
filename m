Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0JTSk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:40:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0JTSkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:40:55 -0400
Date: Wed, 20 Oct 2010 20:40:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101020184032.GB12666@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
 <20101019184111.GA17266@elte.hu>
 <20101020154045.GA18353@elte.hu>
 <1287592675.16971.559.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287592675.16971.559.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> jump_label_update uses stop_machine to enable each tracepoint. Thus this is 
> stressing stop machine.
> 
> Does this only happen on i386, or do we get this on x86_64 too?

I've only seen it on 32-bit - and this testbox is booting both random 64-bit and 
32-bit kernels, so the test proportion is 50%.

The failures started at around the time Thomas did the big irq/core changes a couple 
of days ago. I first blamed it on him. I.e. it's around:

  12ef49d: Merge branch 'irq/core'

That's right after jump labels and some other tracing changes went in. The compiler 
i'm using is:

  gcc version 4.4.4 20100514 (Red Hat 4.4.4-3) (GCC) 

which doesnt support jump labels.

	Ingo
