Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0IFVSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:18:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0IFVSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:18:31 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20100906211217.GA3962@infradead.org>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
	 <1283377414.2059.1729.camel@laptop>
	 <20100903164219.GB1904@linux.vnet.ibm.com>
	 <1283534349.2050.297.camel@laptop>
	 <20100906174642.GG14891@linux.vnet.ibm.com>
	 <20100906204042.GA19815@infradead.org> <1283807168.1930.919.camel@laptop>
	 <20100906211217.GA3962@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Sep 2010 23:18:19 +0200
Message-ID: <1283807899.1930.932.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 17:12 -0400, Christoph Hellwig wrote:
> On Mon, Sep 06, 2010 at 11:06:08PM +0200, Peter Zijlstra wrote:
> > > The other things is that perf currently only supports per-kernel pid
> > > recording, while we'd really need per Posix process, which may contain
> > > multiple threads for useful tracing of complex userspace applications.
> > > I also suspect that this will fit the uprobes model much better given
> > > that the probes will be in any given address space.
> > 
> > perf does report both:
> > 
> >          *      { u32                   pid, tid; } && PERF_SAMPLE_TID
> > 
> > the pid is the process id (thread group leader like) and tid is the
> > task/thread id.
> 
> It records both, but I haven't found a way to only record samples
> or trace things in a Posix Process.
> 
> E.g. perf record -p seems to be only per-thread, not per-process.
> If that has changes recently everything is fine of course.

Hrm, the record code seems to look up all threads for -p and use only a
single thread for -t, didn't actually try it though so it could be
borken.


