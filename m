Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0IFSPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:15:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:34856 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0IFSPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:15:43 -0400
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
Date: Mon, 06 Sep 2010 20:15:22 +0200
Message-ID: <1283796922.1930.736.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 23:16 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-09-03 19:19:09]:
> 
> > > 
> > > However I would have an issue with making inode based probing the
> > > default.
> > > 1. Making all probing based on inode can be a performance hog.
> > 
> > How so? You can add filters if you want.
> 
> The breakpoint exception and singlestep account for a substaintial
> time
> of the uprobes probe handling. With increasing number of breakpoint
> hits and singlesteps, wouldnt the overall load increase?
> 
You're really not getting it, are you? No, it would result in the exact
same amount of actual breakpoints hit.

> > 
> > > 2. Since unlike kernel space, every process has a different space, so
> > > why would we have to insert breakpoints in each of its process space if
> > > we are not interested in them.
> > 
> > You don't have to, but you can. The problem I have with this stuff is
> > that it makes the pid thing a primary interface, whereas it should be
> > one of many filter possibilities.
> 
> I think the otherway, 
> Why instrument a process and filter it out, if we are not interested in it.
> While instrumenting kernel, we dont have this flexibility. So
> having a pid based filter is the right thing to do for kernel
> based tracing.
> 
> If we can get the per process based tracing right, we can build
> higher lever stuff including the file based tracing easily.

Creating inode based probes on top of pid based probes is terribly ugly.

>  Just to clarify, I am not looking at probing per task
> but probing per process. So the pid field in uprobe refers to the
> tgid. 

Urgh,.. I really oppose the whole pid-centric thing, if that means
process wide and not per task its even worse.


