Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab0LCBmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 20:42:42 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:49065 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758253Ab0LCBml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 20:42:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFPU90xGNBQZ/2dsb2JhbACjLnLCboVHBIRejAw
Date: Thu, 2 Dec 2010 20:42:39 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/2] tracing: Add conditional to tracepoints
Message-ID: <20101203014239.GA14675@Krystal>
References: <20101202223654.596106888@goodmis.org> <20101202231957.GB1639@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101202231957.GB1639@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:36:58 up 239 days, 11:27,  3 users,  load average: 0.25, 0.21,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Thu, Dec 02, 2010 at 05:36:54PM -0500, Steven Rostedt wrote:
> > 
> > Note, another variant of this, is to move the test directly into the
> > _DO_TRACE() macro, and not call any registered event callbacks. This would
> > even speed it up faster when tracing is enabled. I did not do this
> > orginially because I just thought of it now as I wrote this change log ;-)
> 
> Hehe :)
> 
> Yeah indeed. And that looks fairly possible.

I'd very much prefer if the test is performed before the call, within
the block that contains the stack setup and the tracepoint function
call. Having an utterly low performance impact for the events that are
filtered out is very important for my client's use-cases. Also, moving
it outside of the tracepoint probe function allows us to filter only
once for all the registered handlers.

All it would require is to skip over the function call rather than doing
a "return".

For the rest, it looks nice. :-)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
