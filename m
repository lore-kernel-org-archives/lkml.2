Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0D2AEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:04:05 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:36656 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530Ab0D2AEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:04:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEZn2EtGGNqG/2dsb2JhbACdA3K9foUOBA
Date: Wed, 28 Apr 2010 20:03:57 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/10][RFC] tracing: Convert TRACE_EVENT() to use the
	DECLARE_TRACE_DATA()
Message-ID: <20100429000357.GA30353@Krystal>
References: <20100426195024.256424113@goodmis.org> <20100426200241.938003192@goodmis.org> <20100428203939.GD8591@Krystal> <1272499077.9739.85.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1272499077.9739.85.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:00:05 up 21 days,  9:53,  4 users,  load average: 0.28, 0.21,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2010-04-28 at 16:39 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > Switch the TRACE_EVENT() macros to use DECLARE_TRACE_DATA(). This
> > > patch is done to prove that the DATA macros work. If any regressions
> > > were to surface, then this patch would help a git bisect to localize
> > > the area.
> > > 
> > > Once again this patch increases the size of the kernel.
> > > 
> > 
> > As recommended in the earlier email:
> > 
> > It would make sense to just add the extra "callback_data" argument
> > directly to DECLARE_TRACE(), modify the user (TRACE_EVENT) accordingly.
> > And possibly create a TRACE_EVENT_NOARG() variant.
> 
> Are you suggesting to make DECLARE_TRACE() be...
> 
> #define DECLARE_TRACE(name, proto, args, data)
> 
> ?

err.. forget about that. We only need to modify the callback to take the
extra argument into acount, not DECLARE_TRACE().

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
