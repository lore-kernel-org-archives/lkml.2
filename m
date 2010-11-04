Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0KDSqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:46:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab0KDSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:46:32 -0400
Date: Thu, 4 Nov 2010 14:45:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 0/15]  0: Uprobes Patches
Message-ID: <20101104184556.GA26104@infradead.org>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20101029092350.GA353@infradead.org>
 <20101029104858.GA1800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029104858.GA1800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 04:18:58PM +0530, Srikar Dronamraju wrote:
> Current issues: Given a vma; finding all tasks that have this vma
> mapped. The current solution seems to walk thro all tasks in the system
> and check if each task's mm field. But this could be inefficient
> especially if the vma is part of all processes like libc etc.

It's pretty much guaranteed to be inefficient, yes.

> I dont think we can use mm->owner to walk thro all the tasks that map to
> this mm_struct.

I don't see a way around that if we have to find the task by the vma.

You'll have to start with vma->vm_mm->owner and then walk the list
of thread siblings inside the heavy weight process.

> Slot allocation delays: Using a per-thread slot instead of a per-probe
> slot leads to a 3.5X degradation in performance. If we need to use
> per-probe slots, we would have to have maintain metadata, i.e the slot
> to virtual address mapping per process. However Peter prefers that we
> reduce such metadata.

The performance numbers are pretty drastic.  But I'll let Peter comment
on the desire in more detail.  I'm really not in enough touch with this
code anymore to give too useful comments.

> >From a perf/ftrace perspective:

I really prefer the new interface.  But as said before I'm just a user
here and I don't care how it's implemented underneath.  I'll defer to
Peter and others knowing the code in more detail to make the trade offs
between the different low level implementations.

