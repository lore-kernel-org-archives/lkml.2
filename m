Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1AUQoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:44:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53079 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1AUQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dxjkAM8I/zLWrSFD11Aic4oOaUByRwsgKi7TwQ+8FD4GS2jL7x538V7lHIBwLFw8i3
         miclie73nYmWJQz6vz3AXvZaV9LwEIIQ4GavCOAEr3SSQud7pBCklzG/r1zs8hG9sNYh
         BZILkrXJ4tjboP7VQNSibgPW4pTQ4u97E1Gmk=
Date: Fri, 21 Jan 2011 17:44:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org
Subject: Re: [PATCH V2] tracing, perf : add cpu hotplug trace events
Message-ID: <20110121164404.GA2520@nowhere>
References: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
 <20110120161101.GA17218@nowhere>
 <AANLkTinhX6UwQA0HFhuu5=jbq84woVhqtahuzA5hEo2o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinhX6UwQA0HFhuu5=jbq84woVhqtahuzA5hEo2o@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:43:18AM +0100, Vincent Guittot wrote:
> On 20 January 2011 17:11, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Thu, Jan 20, 2011 at 09:25:54AM +0100, Vincent Guittot wrote:
> >> Please find below a new proposal for adding trace events for cpu hotplug.
> >> The goal is to measure the latency of each part (kernel, architecture)
> >> and also to trace the cpu hotplug activity with other power events. I
> >> have tested these traces events on an arm platform.
> >>
> >> Changes since previous version:
> >> -Use cpu_hotplug for trace name
> >> -Define traces for kernel core and arch parts only
> >> -Use DECLARE_EVENT_CLASS and DEFINE_EVENT
> >> -Use proper indentation
> >>
> >> Subject: [PATCH] cpu hotplug tracepoint
> >>
> >> this patch adds new events for cpu hotplug tracing
> >>  * plug/unplug sequence
> >>  * core and architecture latency measurements
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.com>
> >> ---
> >>  include/trace/events/cpu_hotplug.h |  117 ++++++++++++++++++++++++++++++++++++
> >
> > Note we can't apply new tracepoints if they are not inserted in the code.
> 
> I agree, i just want to have 1st feedbacks on the tracepoint interface
> before providing a patch which inserts the trace in the code.
> 
> >
> >> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_start,
> >> +
> >> +     TP_PROTO(unsigned int cpuid),
> >> +
> >> +     TP_ARGS(cpuid)
> >> +);
> >> +
> >> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_end,
> >> +
> >> +     TP_PROTO(unsigned int cpuid),
> >> +
> >> +     TP_ARGS(cpuid)
> >> +);
> >
> > What is wait die, compared to die for example?
> >
> 
> The arch_wait_die is used to trace the process which waits for the cpu
> to die (__cpu_die) and the arch_die is used to trace when the cpu dies
> (cpu_die)

I still can't find the difference.

Having:

trace_cpu_hotplug_arch_die_start(cpu)
__cpu_die();
trace_cpu_hotplug_arch_die_end(cpu)

Is not enough to get both the information that a cpu dies
and the time took to do so?
