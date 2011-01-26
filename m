Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1AZKKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:10:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1AZKKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:10:50 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110126074737.GA19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
	 <1295957745.28776.723.camel@laptop>
	 <20110126074737.GA19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 11:10:56 +0100
Message-ID: <1296036656.28776.1137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 13:17 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-01-25 13:15:45]:
> 
> > > +
> > > +       if (atomic_read(&uprobe->ref) == 1) {
> > > +               synchronize_sched();
> > > +               rb_erase(&uprobe->rb_node, &uprobes_tree);
> > 
> > How is that safe without holding the treelock?
> 
> Right, 
> Something like this should be good enuf right?
> 
> if (atomic_read(&uprobe->ref) == 1) {
> 	synchronize_sched();
> 	spin_lock_irqsave(&treelock, flags);
> 	rb_erase(&uprobe->rb_node, &uprobes_tree);
> 	spin_lock_irqrestore(&treelock, flags);
> 	iput(uprobe->inode);
> }
> 	

How is the atomic_read() not racy with a future increment, and what is
that synchronize_sched() thing for?
