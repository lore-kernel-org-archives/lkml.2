Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1AZIBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:01:23 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41774 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AZIBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:01:22 -0500
Date: Wed, 26 Jan 2011 13:17:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        linux-mm@kvack.org, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
Message-ID: <20110126074737.GA19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
 <1295957745.28776.723.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295957745.28776.723.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-25 13:15:45]:

> > +
> > +       if (atomic_read(&uprobe->ref) == 1) {
> > +               synchronize_sched();
> > +               rb_erase(&uprobe->rb_node, &uprobes_tree);
> 
> How is that safe without holding the treelock?

Right, 
Something like this should be good enuf right?

if (atomic_read(&uprobe->ref) == 1) {
	synchronize_sched();
	spin_lock_irqsave(&treelock, flags);
	rb_erase(&uprobe->rb_node, &uprobes_tree);
	spin_lock_irqrestore(&treelock, flags);
	iput(uprobe->inode);
}
	
-- 
Thanks and Regards
Srikar

PS: Last time I had goofed up with Linux-mm mailing alias. 
Hopefully this time it goes to the right list.
