Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1ECOGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:06:51 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46663 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752213Ab1ECOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:06:50 -0400
Date: Tue, 3 May 2011 10:06:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
Message-ID: <20110503140647.GA29665@Krystal>
References: <20110502211123.163877033@efficios.com> <20110502213216.050459585@efficios.com> <20110503132138.GL1762@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503132138.GL1762@opensource.wolfsonmicro.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:39:56 up 160 days, 18:43,  6 users,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown (broonie@opensource.wolfsonmicro.com) wrote:
> On Mon, May 02, 2011 at 05:11:52PM -0400, Mathieu Desnoyers wrote:
> > Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> > of events, thus saving space for trace event probes.
> 
> Can I apply this in my tree or does this depend on some earlier patch I
> don't have?

Hi Mark,

This depends on a preliminary ftrace cleanup patch I just forwarded to
you. LKML has eaten that patch due to too many CC. [ insert favorite
expression of frustration here ]. But I think the best way to proceed
would be to get a Acked-by from you and let Steven pull the patch
through the tracing tree.

> 
> > +#ifndef _TRACE_ASOC_DEF_
> > +#define _TRACE_ASOC_DEF_
> > +
> >  struct snd_soc_jack;
> >  struct snd_soc_codec;
> >  struct snd_soc_card;
> >  struct snd_soc_dapm_widget;
> >  
> > +#endif /* _TRACE_ASOC_DEF_ */
> 
> This is an unrelated change and should be split out.  Frankly I'm not
> that this is an improvement anyway, the struct declarations aren't going
> to do any harm...

Yes, this change is related, because these declarations will cause harm.
The structure declaration cannot be put within an array declaration,
because then they won't be simply "ignored": they will try to declare
structures within an array, which is not valid. This is why I did this
change in the same patch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
