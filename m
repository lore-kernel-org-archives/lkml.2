Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0IFSPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:15:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab0IFSPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:15:40 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20100906174642.GG14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
	 <1283377414.2059.1729.camel@laptop>
	 <20100903164219.GB1904@linux.vnet.ibm.com>
	 <1283534349.2050.297.camel@laptop>
	 <20100906174642.GG14891@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Sep 2010 20:15:21 +0200
Message-ID: <1283796921.1930.735.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 23:16 +0530, Srikar Dronamraju wrote:
> > > Unlike kernel probing, uprobes has a disadvantage.
> > > Lets assume that the request for removing a probepoint when some of the
> > > threads have actually hit the probe. Because the handlers in uprobes can
> > > sleep, we cant remove the probepoint at the same time as the request for
> > > the removing the probe. This is where refcount steps in and helps us to
> > > decide when we can remove the probepoint. Even inoode based
> > > tracing or file based tracing would need it.
> > 
> > Stick the refcount in the actual struct uprobe instead?
> 
> What if the called does something like this when one or more
> threads are processing the breakpoint.
> unregister_uprobe(u);
> kfree(u);

That's what atomic_inc_unless_zero() and RCU are for.
