Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab0EGEUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:20:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34794 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0EGEU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gqEod8roVFF8NSSRqqcBYshHVBU9k0dlSCPy4TJNIMzPzqSecNYLZDzZoQQzpAh1Pt
         Uj0gRZvJRudjs9JKkPSqFr2JYNPGq8zbGX/DSOUegOAI8HU2/hJCk7W1WsrvneIXQUAi
         RJR/IWj7fir8hBwO5rIsa1BZPwW6QqF/emgOc=
Date: Fri, 7 May 2010 06:20:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace
	registering
Message-ID: <20100507042025.GC8069@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034202.282030521@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504034202.282030521@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 11:40:48PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch removes the register functions of TRACE_EVENT() to enable
> and disable tracepoints. The registering of a event is now down
> directly in the trace_events.c file. The tracepoint_probe_register()
> is now called directly.
> 
> The prototypes are no longer type checked, but this should not be
> an issue since the tracepoints are created automatically by the
> macros. If a prototype is incorrect in the TRACE_EVENT() macro, then
> other macros will catch it.



Agreed. Typechecking matters for human code but not in this context.
Considering that the tracepoint and the probe are created by the same
CPP code, bugs will be tracked down quickly and located to a single
place.




> 
> The trace_event_class structure now holds the probes to be called
> by the callbacks. This removes needing to have each event have
> a separate pointer for the probe.
> 
> To handle kprobes and syscalls, since they register probes in a
> different manner, a "reg" field is added to the ftrace_event_class
> structure. If the "reg" field is assigned, then it will be called for
> enabling and disabling of the probe for either ftrace or perf. To let
> the reg function know what is happening, a new enum (trace_reg) is
> created that has the type of control that is needed.
> 
> With this new rework, the 82 kernel events and 616 syscall events
> has their footprint dramatically lowered:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
> 5793448	1333780	9351592	16478820	 fb7264	vmlinux.tracepoint
> 5796926	1337748	9351592	16486266	 fb8f7a	vmlinux.data
> 5774316	1306580	9351592	16432488	 fabd68	vmlinux.regs
> 
> The size went from 16477030 to 16432488, that's a total of 44K
> in savings. With tracepoints being continuously added, this is
> critical that the footprint becomes minimal.
> 
> v2: Changed the callback probes to pass void * and typecast the
>     value within the function.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>



Very nice!!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

