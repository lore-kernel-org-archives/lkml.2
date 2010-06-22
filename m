Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0FVFsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:48:10 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34703 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0FVFsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:48:08 -0400
Date: Tue, 22 Jun 2010 11:14:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/14] User Space Breakpoint Assistance Layer
Message-ID: <20100622054429.GB25989@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082832.29068.53628.sendpatchset@localhost6.localdomain6>
 <1277128787.9181.3.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1277128787.9181.3.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/**
> > + * user_bkpt_write_data - Write @nbytes from @kbuf at @vaddr in @tsk.
> > + * Can be used to write to stack or data VM areas, but not instructions.
> > + * Not exported, but available for use by arch-specific user_bkpt code.
> > + * @tsk: The probed task
> > + * @vaddr: Destination address, in user space.
> > + * @kbuf: Source address, in kernel space to be read.
> 
> I'm curious. Anything prevent this from being called on instructions, or
> is this just "Don't do that?". 
> 

Both, 
copy_to_user doesnt work on writes to text.
And if I am right, copy_to_user isnt preferred while writing to text
pages too.

> > +
> > +	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
> > +	/* poke the new insn in, ASSUMES we don't cross page boundary */
> > +	vaddr = vaddr & (PAGE_SIZE - 1);
> 
> This should probably be vaddr = vaddr & ~PAGE_MASK;

Okay, I will make the corresponding change.
> 
> 
