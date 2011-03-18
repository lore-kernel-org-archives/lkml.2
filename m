Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab1CRWLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:11:54 -0400
Received: from mout.perfora.net ([74.208.4.194]:64235 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304Ab1CRWLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:11:48 -0400
Date: Fri, 18 Mar 2011 18:10:42 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 17/20] 17: uprobes: filter chain
Message-ID: <20110318221042.GA3586@fibrous.localdomain>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133722.27435.55663.sendpatchset@localhost6.localdomain6> <20110315194914.GA24972@fibrous.localdomain> <20110318191648.GD31152@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318191648.GD31152@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:yT1HhYGud4qwdcAVX7yVOdos19NQ9c9UFulYJNwAJkB
 8lstwYSeOZLsh+YuqGDimBa/WcfeE7IeAgGNcRQqgTvK+PDhNn
 LglMbh61kqgudaTiXlotW9/EEvASNcsZcfTGB5l2WOmTF9LTRK
 VUPOmPiCID+xewlsDBCJrJ7oVcUwghV2zJUz5IlI0LcFfU5f09
 F9N4FT9dlwQcutOGquJGnrHM4NwlYpKm7DkWKx6lmI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, Mar 19, 2011 at 12:46:48AM +0530, Srikar Dronamraju wrote:
> > > +	for (consumer = uprobe->consumers; consumer;
> > > +					consumer = consumer->next) {
> > > +		if (!consumer->filter || consumer->filter(consumer, t)) {
> > 
> > The implementation does not seem to match the changelog description.
> > Should this not be:
> > 
> >                 if (consumer->filter && consumer->filter(consumer, t))
> > 
> >   ?
> 
> filter is optional; if filter is present, then it means that the
> tracer is interested in a specific set of processes that maps this
> inode. If there is no filter; it means that it is interested in all
> processes that map this filter. 

Ah OK.  That does make sense then.  Thanks!


> filter_chain() should return true if any consumer is interested in
> tracing this task.  if there is a consumer who hasnt defined a filter
> then we dont need to loop thro remaining consumers.
> 
> Hence 
> 
> if (!consumer->filter || consumer->filter(consumer, t)) {
>  
> seems better suited to me.

-- 
steve

