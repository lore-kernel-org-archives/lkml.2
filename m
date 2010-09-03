Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0ICQwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:52:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0ICQwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:52:10 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100903164010.GA1904@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
	 <1283372009.2059.1557.camel@laptop>
	 <20100903164010.GA1904@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 18:51:54 +0200
Message-ID: <1283532714.2050.244.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 22:10 +0530, Srikar Dronamraju wrote:
> > > +   mb();
> > 
> > Where is the matching barrier?
> 
> I dont want the compiler to reorder the instructions and do the
> assignment for user_bkpt to be done before we complete the copy above.
> 
> If the assignment happens before we copy the content into the slot,
> someother thread that might hit the same probe actually things the slot
> is ready and tries to jump to that slot even before the slot is
> initialized.
> 
> Please let me know if I could have done it differently. 


If you want a compiler barrier, use barrier(), but here you seem to
describe a multi-threaded situation, in which case the observer thread
needs at least a rmb() in order for that mb() to mean anything other
than the compiler barrier it implies.

Also, use smp_* barriers.


