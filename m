Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0JPQQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:16:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0JPQQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:16:35 -0400
Date: Sat, 16 Oct 2010 18:16:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: ftrace does not work on cpus > 999.
Message-ID: <20101016161627.GA3567@elte.hu>
References: <20101016131505.GW14064@sgi.com>
 <20101016144529.GA5384@nowhere>
 <1287242272.16971.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287242272.16971.53.camel@gandalf.stny.rr.com>
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

> On Sat, 2010-10-16 at 16:45 +0200, Frederic Weisbecker wrote:
> 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 9ec59f5..3565f9e 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3999,7 +3999,7 @@ static void tracing_init_debugfs_percpu(long cpu)
> >  	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
> >  	char cpu_dir[7];
> >  
> > -	if (cpu > 999 || cpu < 0)
> > +	if (cpu < 0)
> >  		return;
> >  
> >  	sprintf(cpu_dir, "cpu%ld", cpu);
> 
> You need to change the size of cpu_dir, otherwise this will overflow.

If you change it to 30 that ought to be enough, as long as cpu_id's fit 
into u64. (I think we wont overflow that in my lifetime.)

> The other case is to dynamically allocate cpu_dir.

Please tell me that is a joke ...

	Ingo
