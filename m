Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0J3TV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:21:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0J3TVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:21:53 -0400
Date: Sat, 30 Oct 2010 21:21:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        "Ma Ling:" <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] perf bench: port memcpy_64.S to perf bench
Message-ID: <20101030192131.GB26503@elte.hu>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1288381751.1988.13.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288381751.1988.13.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2010-10-30 at 01:01 +0900, Hitoshi Mitake wrote:
> > This patch ports arch/x86/lib/memcpy_64.S to "perf bench mem".
> > When PERF_BENCH is defined at preprocessor level,
> > memcpy_64.S is preprocessed to includable form from the sources
> > under tools/perf for benchmarking programs.
> > 
> > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Cc: Ma Ling: <ling.ma@intel.com>
> > Cc: Zhao Yakui <yakui.zhao@intel.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > ---
> >  arch/x86/lib/memcpy_64.S |   30 ++++++++++++++++++++++++++++++
> >  1 files changed, 30 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> > index 75ef61e..72c6dfe 100644
> > --- a/arch/x86/lib/memcpy_64.S
> > +++ b/arch/x86/lib/memcpy_64.S
> > @@ -1,10 +1,23 @@
> >  /* Copyright 2002 Andi Kleen */
> >  
> > +/*
> > + * perf bench adoption by Hitoshi Mitake
> > + * PERF_BENCH means that this file is included from
> > + * the source files under tools/perf/ for benchmark programs.
> > + *
> > + * You don't have to care about PERF_BENCH when
> > + * you are working on the kernel.
> > + */
> > +
> > +#ifndef PERF_BENCH
> 
> I don't like littering the actual kernel code with tools/perf/
> ifdeffery..


Yeah - could we somehow accept that file into a perf build as-is?

Thanks,

	Ingo
