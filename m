Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab0KKH7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:59:22 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39055 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab0KKH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:59:21 -0500
X-AuditID: b753bd60-a41a1ba000003e7d-5e-4cdba255a294
Message-ID: <4CDBA251.4010505@hitachi.com>
Date: Thu, 11 Nov 2010 16:59:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [RFD tracing] Tracing ABI Work Plan
References: <20101111004612.GB32564@Krystal>
In-Reply-To: <20101111004612.GB32564@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2010/11/11 9:46), Mathieu Desnoyers wrote:
> A) New ABI for user-space
> 
> This new ABI will provide the features long-awaited by tracing users. We've
> already started this discussion by listing the requirements and acknowledging
> them. It is now time to start discussing the ABI. Upon disagreement on answering
> a specific requirement, two questions will arise:
> 
> 1. How much trouble it really is to take care of this requirement. If the answer
>    is "not much", then we simply take care of it.
> 2. If it really is a big deal to take care of a requirement at the ABI level,
>    then we will have to discuss the use-cases.
> 
> Once we are on the same page with respect to these requirements, we can come up
> with an ABI proposal for:
> 
> - Tracing control
> - Trace format
> 
> 
> B) Internal Instrumentation API
> 
> I propose to standardize the instrumentation mechanisms (Tracepoints, Function
> Tracer, Dynamic Probes, System Call Tracing, etc), so they can be used by
> Ftrace, Perf, and by the new ABI without requiring to build all three tracer
> ABI code-bases in the kernel. This involves modularizing the instrumentation
> sources, taking the following aspects into account:
> 
> - They should be stand-alone objects, which can be built without a full tracer
>   enabled.
> - They should offer a "registration/unregistration" API to tracers, so tracers
>   can register a callback along with a private data pointer (this would fit
>   with the "multiple concurrent tracing session" requirement).
> - They should call these callbacks passing the private data pointer when the
>   instrumentation is hit.
> - They should provide a mechanism to list the available instrumentation (when it
>   makes sense) and active instrumentation. E.g., it makes sense for tracepoints
>   to list the available tracepoints, but it only makes sense for dynamic probes
>   to list the enabled probes.
> 
> Masami Hiramatsu and Frederic Weisbecker already showed interest in undertaking
> this task.

Actually, I didn't talked about what API should be provided internally.
(Yeah, I know LTTng handler want that. However, there is no "external" handler
 _inside_ linux kernel tree)
Instead, I and Frederic talked shortly about something like user interface
for events. (so it would be more close to A, about controlling)

As Thomas said, eventually kernel internal tracer should simply provide
"events tracing" functionality. User tools will analyze it and it's not
kernel's business. I agree with his opinion.

>From above viewpoint, currently only trace-events(tracepoint-based events)
and dynamic-events (kprobe-based events) are providing same interface for
users. And, for example, perf's PMU events or ftrace's mcount events aren't
shown up under debugfs/tracing/events. IMHO, all events provided by kernel
should be there, so that user tools can read the format and control those
events same way.

For this purpose, I'd like to expand trace-event/dynamic-event framework to
those events. It seems that some PMU events can be treated as trace-events,
mcount and other parametric events can be treated as dynamic-events.

Anyway, those stuffs can be done without new-ring-buffer-ABI things.
I'll just expand dyn-events a bit far from here :-)

Best Regards,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
