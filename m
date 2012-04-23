Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2DWHlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:41:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:47662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2DWHlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:41:08 -0400
Message-ID: <1335166842.28150.92.camel@twins>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Mon, 23 Apr 2012 09:40:42 +0200
In-Reply-To: <20120423072445.GC8357@linux.vnet.ibm.com>
References: <20120414205200.GA9083@redhat.com>
	 <1334487062.2528.113.camel@twins> <20120415195351.GA22095@redhat.com>
	 <1334526513.28150.23.camel@twins> <20120415234401.GA32662@redhat.com>
	 <1334571419.28150.30.camel@twins> <20120416214707.GA27639@redhat.com>
	 <1334916861.2463.50.camel@laptop> <20120420183718.GA2236@redhat.com>
	 <1335165240.28150.89.camel@twins>
	 <20120423072445.GC8357@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 12:54 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-04-23 09:14:00]:
> 
> > On Fri, 2012-04-20 at 20:37 +0200, Oleg Nesterov wrote:
> > > Say, a user wants to probe /sbin/init only. What if init forks?
> > > We should remove breakpoints from child->mm somehow. 
> > 
> > How is that hard? dup_mmap() only copies the VMAs, this doesn't actually
> > copy the breakpoint. So the child doesn't have a breakpoint to be
> > removed.
> > 
> 
> Because the pages are COWED, the breakpoint gets copied over to the
> child. If we dont want the breakpoints to be not visible to the child,
> then we would have to remove them explicitly based on the filter (i.e if
> and if we had inserted breakpoints conditionally based on filter). 

I thought we didn't COW shared maps since the fault handler will fill in
the pages right and only anon stuff gets copied.

> Once we add the conditional breakpoint insertion (which is tricky),

How so?

>  we have
> to support conditional breakpoint removal in the dup_mmap() thro the
> uprobe_mmap hook (which I think is not that hard).  Conditional removal
> of breakpoints in fork path would just be an extension of the
> conditional breakpoint insertion.

Right, I don't think that removal is particularly hard if needed.
