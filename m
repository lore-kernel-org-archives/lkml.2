Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0EKOGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:06:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:59294 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757892Ab0EKOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:06:00 -0400
Date: Tue, 11 May 2010 10:05:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10 -v3][RFC] tracing: Combine event filter_active
	and enable into single flags field
Message-ID: <20100511140557.GA29543@Krystal>
References: <20100511030020.837892321@goodmis.org> <20100511030911.927339838@goodmis.org> <20100511033026.GA28162@Krystal> <1273584628.22438.4501.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273584628.22438.4501.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:05:03 up 108 days, 16:42,  5 users,  load average: 0.80, 0.39,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2010-05-10 at 23:30 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > The filter_active and enable both use an int (4 bytes each) to
> > > set a single flag. We can save 4 bytes per event by combining the
> > > two into a single integer.
> > > 
> 
> > I would also comment about flags read-side:
> > 
> >  * Flags are read concurrently without locking.
> 
> That can go in outside this patch set. As we discussed before, the
> filter_active which does the same today as flags does here also has the
> issue you are concerned with. IOW, this issue has nothing to do with
> this patch set, because the issue existed before the patch set and has
> not changed after the patch set.

That's fine with me.

> 
> The comment should also be in Documentation, not here, since it would
> affect users more than the developers.

Typically, locking-related information belongs to comments close to the
definition. I'm not sure why you say it affects users at all.

Thanks,

Mathieu

> 
> > 
> > Besides that minor nit, the whole patchset has my
> > 
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Thanks!  I'll get an official release ready.
> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
