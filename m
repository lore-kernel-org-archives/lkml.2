Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2GMPso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:48:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:45619 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2GMPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:48:43 -0400
Date: Fri, 13 Jul 2012 17:48:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seiji Aguchi <seiji.aguchi@hds.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "vnagarnaik@google.com" <vnagarnaik@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH]trace,x86: add x86 irq vector tracepoints
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E359@USINDEM101.corp.hds.com>
Message-ID: <alpine.LFD.2.02.1207131727430.32033@ionos>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AA07@USINDEM103.corp.hds.com> <1341521053.21574.22.camel@gandalf.stny.rr.com> <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E359@USINDEM101.corp.hds.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Seiji Aguchi wrote:
> Thomas,
> 
> Any comment?

Yes :)
 
> > > +DECLARE_EVENT_CLASS(irq_vector,
> > > +
> > > +	TP_PROTO(int irq),
> > > +
> > > +	TP_ARGS(irq),
> > > +
> > > +	TP_STRUCT__entry(
> > > +		__field(	int,	irq	)

Shouldn't this be vector?

> > > +DEFINE_EVENT(irq_vector, nmi_entry,
> > > +DEFINE_EVENT(irq_vector, nmi_exit,
> > > +DEFINE_EVENT(irq_vector, local_timer_entry,
> > > +DEFINE_EVENT(irq_vector, local_timer_exit,
> > > +DEFINE_EVENT(irq_vector, reschedule_entry,
> > > +DEFINE_EVENT(irq_vector, reschedule_exit,
> > > +DEFINE_EVENT(irq_vector, call_function_entry,
> > > +DEFINE_EVENT(irq_vector, call_function_exit,
> > > +DEFINE_EVENT(irq_vector, call_function_single_entry,
> > > +DEFINE_EVENT(irq_vector, call_function_single_exit,
> > > +DEFINE_EVENT(irq_vector, irq_work_entry,
> > > +DEFINE_EVENT(irq_vector, irq_work_exit,
> > > +DEFINE_EVENT(irq_vector, invalidate_tlb_entry,
> > > +DEFINE_EVENT(irq_vector, invalidate_tlb_exit,

So this set is pretty generic and applicable across
architectures. Good.

> > > +DEFINE_EVENT(irq_vector, error_apic_entry,
> > > +DEFINE_EVENT(irq_vector, error_apic_exit,
> > > +DEFINE_EVENT(irq_vector, thermal_apic_entry,
> > > +DEFINE_EVENT(irq_vector, thermal_apic_exit,
> > > +DEFINE_EVENT(irq_vector, threshold_apic_entry,
> > > +DEFINE_EVENT(irq_vector, threshold_apic_exit,
> > > +DEFINE_EVENT(irq_vector, spurious_apic_entry,
> > > +DEFINE_EVENT(irq_vector, spurious_apic_exit,
> > > +DEFINE_EVENT(irq_vector, x86_platform_ipi_entry,
> > > +DEFINE_EVENT(irq_vector, x86_platform_ipi_exit,

That part is x86 specific. If we go that route, we'll end up with
gazillions of arch specific vectors sooner than later.

Either we find better and more widely applicable names for them, if
there are similar functionalities on other architectures available, or
we should have a single generic tracepoint for those which cannot be
be mapped to anything useful shared across architectures.

Those x86 specific ones are not really frequently raised vectors, so
enabling them all won't affect performance and readability of the
traces too much.

Thanks,

	tglx
