Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2DWHdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:33:53 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33167 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWHdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:33:52 -0400
Date: Mon, 23 Apr 2012 12:54:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120423072445.GC8357@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120414205200.GA9083@redhat.com>
 <1334487062.2528.113.camel@twins>
 <20120415195351.GA22095@redhat.com>
 <1334526513.28150.23.camel@twins>
 <20120415234401.GA32662@redhat.com>
 <1334571419.28150.30.camel@twins>
 <20120416214707.GA27639@redhat.com>
 <1334916861.2463.50.camel@laptop>
 <20120420183718.GA2236@redhat.com>
 <1335165240.28150.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1335165240.28150.89.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042307-4242-0000-0000-0000016C5FE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-04-23 09:14:00]:

> On Fri, 2012-04-20 at 20:37 +0200, Oleg Nesterov wrote:
> > Say, a user wants to probe /sbin/init only. What if init forks?
> > We should remove breakpoints from child->mm somehow. 
> 
> How is that hard? dup_mmap() only copies the VMAs, this doesn't actually
> copy the breakpoint. So the child doesn't have a breakpoint to be
> removed.
> 

Because the pages are COWED, the breakpoint gets copied over to the
child. If we dont want the breakpoints to be not visible to the child,
then we would have to remove them explicitly based on the filter (i.e if
and if we had inserted breakpoints conditionally based on filter). 

Once we add the conditional breakpoint insertion (which is tricky), we have
to support conditional breakpoint removal in the dup_mmap() thro the
uprobe_mmap hook (which I think is not that hard).  Conditional removal
of breakpoints in fork path would just be an extension of the
conditional breakpoint insertion.

-- 
Thanks and Regards
Srikar

