Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0FVFuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:50:15 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55235 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0FVFuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:50:13 -0400
Date: Tue, 22 Jun 2010 11:16:33 +0530
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
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 10/14] trace: Common code for kprobes/uprobes
 traceevents
Message-ID: <20100622054633.GC25989@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082953.29068.76083.sendpatchset@localhost6.localdomain6>
 <1277129899.9181.8.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1277129899.9181.8.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2010-06-21 10:18:19]:

> On Mon, 2010-06-14 at 13:59 +0530, Srikar Dronamraju wrote:
> > share_traceevents.patch.
> > 
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > Changelog from v5: Addressed comments from Masami.
> >         Also shared lot more code from kprobes traceevents.
> > 
> > Move common parts of trace_kprobe.c and trace_uprobec.
> > Adjust kernel/trace/trace_kprobe.c after moving common code to
> > kernel/trace/trace_probe.h. However they still have few duplicate
> > functions.
> > 
> > TODO: Merge both events to a single probe event.
> > 
> > Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > ---
> > 
> >  kernel/trace/trace_kprobe.c |  141 +--------------------------------------
> >  kernel/trace/trace_probe.h  |  157 +++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 161 insertions(+), 137 deletions(-)
> >  create mode 100644 kernel/trace/trace_probe.h
> > 
> 
> > diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> > new file mode 100644
> > index 0000000..b4c5763
> > --- /dev/null
> > +++ b/kernel/trace/trace_probe.h
> > @@ -0,0 +1,157 @@
> > +/*
> > + * Common header file for probe-based Dynamic events.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > + *
> > + * Copyright (C) IBM Corporation, 2010
> > + * Author:	Srikar Dronamraju
> 
> Note, when moving stuff from one file to another, you still need to keep
> the copyright and author of the original file. You can add your name and
> copyright as well, when you add your stuff to it.

Okay .. will modify as suggested by you.

--
Thanks and Regards
Srikar
> 
> -- Steve
> 
> 
