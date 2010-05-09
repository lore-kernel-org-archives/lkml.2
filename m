Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0EILSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 07:18:51 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47873 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0EILSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 07:18:49 -0400
Date: Sun, 9 May 2010 16:48:41 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 10/10] perf: perf interface for uprobes.
Message-ID: <20100509111841.GJ7426@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
 <20100506180340.28877.25709.sendpatchset@localhost6.localdomain6>
 <4BE34D1D.2020100@redhat.com>
 <20100507022403.GH7426@linux.vnet.ibm.com>
 <4BE453A1.1060003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BE453A1.1060003@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> > 
> > Either zfree_3329 or having a new event group for each process is
> > possible.
> 
> I think adding new groups make controlling those event easier.
> (e.g. deleting all probes on exited process)
> 

Okay..

> 
> >> [...]
> >>> @@ -383,7 +450,11 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
> >>>  	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
> >>>  	if (!buf)
> >>>  		die("Failed to allocate memory by zalloc.");
> >>> -	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
> >>> +	if (pp->offset)
> >>> +		ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function,
> >>> +					pp->offset);
> >>> +	else
> >>> +		ret = e_snprintf(buf, MAX_CMDLEN, "%s", pp->function);
> >>>  	if (ret <= 0)
> >>>  		goto error;
> >>>  	len = ret;
> >>
> >> Isn't it a cleanup ?
> > 
> > Can you please elaborate?
> 
> symbol+offset is always allowed even if offset == 0,
> so I think this change isn't needed. I guessed it is just for cleanup.
> 

kprobes has an advantage that it can make sense of kernel symbols. 
However uprobes doesnt have the advantage. It cannot make any sense of
user space symbols. Hence unlike kprobes, uprobes doesnt have
symbol_name and offset fields. To overcome this the perf probe for
uprobes resolves the symbol_name, offset and pass the plain vaddr to
uprobes. 

--
Thanks and Regards
Srikar Dronamraju


