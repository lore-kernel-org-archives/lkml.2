Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1BXOgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:36:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab1BXOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:36:49 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=687XAutVW18A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KKAkSRfTAAAA:8 a=v5fW1wrYxGBlHb-qY7EA:9 a=84P3Pl4rMuoNialZdQ6tbyUZRvcA:4 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH V4 1/2] tracing, perf : add cpu hotplug trace events
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, amit.kucheria@linaro.org,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <AANLkTinvZmoXQV3Kb7uyuHsCnDNNGfed0BfRfLaE_CdZ@mail.gmail.com>
References: <AANLkTi=V8xPzo-T=DMpf-FMF141SrMnb9J9mXqE9pW0w@mail.gmail.com>
	 <AANLkTinvZmoXQV3Kb7uyuHsCnDNNGfed0BfRfLaE_CdZ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Feb 2011 09:36:46 -0500
Message-ID: <1298558206.6376.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Ingo and Rusty ]

On Thu, 2011-02-24 at 15:26 +0100, Vincent Guittot wrote:
> Hi,
> 
> Any comments or feedbacks about these both patches ?

I'm fine with these patches and I believe Frederic said he was too. But
as these patches trace cpu hotplug, it is up to the maintainers of cpu
hotplug to make the final decision.

-- Steve

> 
> Thanks,
> Vincent
> 
> On 31 January 2011 11:22, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> > Please find below a new proposal for adding trace events for cpu hotplug.
> > The goal is to measure the latency of each part (kernel, architecture)
> > and also to trace the cpu hotplug activity with other power events. I
> > have tested these traces events on an arm platform.
> >
> > Subject: [PATCH 1/2] cpu hotplug tracepoint
> >
> > this patch adds new events for cpu hotplug tracing
> >  * plug/unplug sequence
> >  * core and architecture latency measurements
> >
> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > ---
> >  include/trace/events/cpu_hotplug.h |  103 ++++++++++++++++++++++++++++++++++++
> >  1 files changed, 103 insertions(+), 0 deletions(-)
> >  create mode 100644 include/trace/events/cpu_hotplug.h
> >
> > diff --git a/include/trace/events/cpu_hotplug.h
> > b/include/trace/events/cpu_hotplug.h
> > new file mode 100644
> > index 0000000..af05775
> > --- /dev/null
> > +++ b/include/trace/events/cpu_hotplug.h
> > @@ -0,0 +1,103 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM cpu_hotplug
> > +
> > +#if !defined(_TRACE_CPU_HOTPLUG_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_CPU_HOTPLUG_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +DECLARE_EVENT_CLASS(cpu_hotplug,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid),
> > +
> > +       TP_STRUCT__entry(
> > +               __field(        unsigned int,   cpuid   )
> > +       ),
> > +
> > +       TP_fast_assign(
> > +               __entry->cpuid = cpuid;
> > +       ),
> > +
> > +       TP_printk("cpuid=%u", __entry->cpuid)
> > +);
> > +
> > +/* Core function of cpu hotplug */
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_down_start,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_down_end,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_up_start,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_up_end,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +/* Architecture function for cpu hotplug */
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_disable_start,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_disable_end,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_die_start,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_die_end,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_up_start,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_up_end,
> > +
> > +       TP_PROTO(unsigned int cpuid),
> > +
> > +       TP_ARGS(cpuid)
> > +);
> > +
> > +#endif /* _TRACE_CPU_HOTPLUG_H */
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
> > --
> > 1.7.1
> >


