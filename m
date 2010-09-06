Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0IFPsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:48:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0IFPsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:48:05 -0400
Date: Mon, 6 Sep 2010 17:47:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100906154737.GA4332@elte.hu>
References: <4C84B088.5050003@redhat.com>
 <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C850147.8010908@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>  On 09/06/2010 03:59 PM, Ingo Molnar wrote:
> >
> >>Is this a roundabout way of saying "jit"?
> >Partly. I'm not sure we want to actually upload programs in bytecode
> >form. ASCII is just fine - just like a .gz Javascript is fine for web
> >apps. (and in most cases compresses down better than the bytecode
> >equivalent)
> >
> >So a clear language (the simpler initially the better) plus an in-kernel
> >compiler.
> >
> >This could be used for far more than just instrumentation: IMO security
> >policies could be expressed in such a way. (Simplified, they are quite
> >similar to filters installed on syscall entry/exit, with the ability of
> >the filter to influence whether the syscall is performed.)
> 
> For me the requirements are:
> - turing complete (more than just filters)

Yep. Filters are obviously just basically expressions.

Conditions and variables can be added. Maybe loops too in simpler forms 
- as long as we can prove halting - or maybe with a runtime abort 
mechanism.

> - easy interface to kernel APIs (like hrtimers)
> - safe to use by untrusted users

Yep.

> The actual language doesn't really matter.

There are 3 basic categories:

 1- Most (least abstract) specific code: a block of bytecode in the form 
    of a simplified, executable, kernel-checked x86 machine code block - 
    this is also the fastest form. [yes, this is actually possible.]

 2- Least specific (most abstract) code: A subset/sideset of C - as it's 
    the most kernel-developer-trustable/debuggable form.

 3- Everything else little more than a dot on the spectrum between the
    first two points.

I lean towards #2 - but #1 looks interesting too. #3 is distinctly 
uninteresting as it cannot be as fast as #1 and cannot be as convenient 
as #2.

Thanks,

	Ingo
