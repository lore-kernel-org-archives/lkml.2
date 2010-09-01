Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0IAGOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:14:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab0IAGOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:14:17 -0400
Date: Wed, 1 Sep 2010 08:14:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        acme@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 4/9] mce: Add persistent events
Message-ID: <20100901061402.GA22874@elte.hu>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-5-git-send-email-bp@amd64.org>
 <1281106636.1947.710.camel@laptop>
 <1283300000.1377.863.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283300000.1377.863.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2010-08-06 at 16:57 +0200, Peter Zijlstra wrote:
> > On Fri, 2010-08-06 at 16:25 +0200, Borislav Petkov wrote:
> > > +static const struct file_operations perf_mce_fops = {
> > > +       .llseek         = no_llseek,
> > > +       .open           = mce_perf_open,
> > > +       .poll           = perf_poll,
> > > +       .unlocked_ioctl = perf_ioctl,
> > > +       .compat_ioctl   = perf_ioctl,
> > > +       .mmap           = perf_mmap,
> > > +       .fasync         = perf_fasync,
> > > +       .release        = perf_release,
> > > +}; 
> > 
> > I'd rather see this part of the persistent bits live in
> > kernel/perf_event.c, that way you don't need the previous patch either.
> > 
> 
> This is part of what I hate about the perf design. The fact that 
> everything needs to be very coupled. I would like the infrastructure 
> to be more flexible.

Well, Peter's comment was mostly about not making this arch specific but 
core kernel - the new bits can live in kernel/perf_event_persistent.c 
just fine.

There is no 'flexibility' in each arch doing the same thing with small 
variations.

More generally i agree with you that better modularization helps - a 
nice improvement in this area would be to do a kernel/perf_event/ 
splitup: i.e. split kernel/perf_event.c (which is getting a tad big) 
into:

  kernel/events/output.c
  kernel/events/trace.c
  kernel/events/core.c
  kernel/events/syscall.c
  kernel/events/persistent.c

Maybe even move hw_breakpoint.c there, etc. There's already various 
wrappers in perf_event.c that could be split out of the core code to 
increase modularity. Later on we could have a sysfs.c, etc.

Any taker for such a massive restructuring? :)

Thanks,

	Ingo
