Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1AZQhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:37:33 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56506 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1AZQhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:37:32 -0500
Date: Wed, 26 Jan 2011 22:00:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
Message-ID: <20110126163052.GO19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957739.28776.717.camel@laptop>
 <20110126090346.GH19725@linux.vnet.ibm.com>
 <1296037239.28776.1149.camel@laptop>
 <20110126145955.GJ19725@linux.vnet.ibm.com>
 <1296055009.28776.1202.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296055009.28776.1202.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-26 16:16:49]:

> On Wed, 2011-01-26 at 20:29 +0530, Srikar Dronamraju wrote:
> > list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
> >                 down_read(&mm->map_sem);
> >                 if (!install_uprobe(mm, uprobe))
> >                         ret = 0;
> >                 up_read(&mm->map_sem);
> >                 list_del(&mm->uprobes_list);
> >                 mmput(mm);
> > } 
> 
> and the tmp_list thing works because new mm's will hit the mmap callback
> and you cannot loose mm's due to the refcount, right?
> 

Right, In other words, the tmp_list has all mm's that have already
running and have this inode mapped as executable text. Those process
that are yet to start or yet to map the inode as executable text
will hit mmap and then we look at inserting the probes thro
uprobes_mmap. 

-- 
Thanks and Regards
Srikar
> 
