Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab0GTWDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761676Ab0GTWDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:03:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
References: <4C2DAEBB.7090607@kernel.org> <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> 
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
Date: Tue, 20 Jul 2010 23:01:42 +0100
Message-ID: <31872.1279663302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> David, this should work for fscache/slow-work the same way too.  That
> should relieve your concern, right?

Not at the moment.  What does this mean:

	 * Unbound workqueues aren't concurrency managed and should be
	 * dispatched to workers immediately.

Does this mean you don't get reentrancy guarantees with unbounded work queues?

I can't work out how you're achieving it with unbounded queues.  I presume with
CPU-bound workqueues your doing it by binding the work item to the current CPU
still...

Btw, how does this fare in an RT system, where work items bound to a CPU can't
get executed because their CPU is busy with an RT thread, even though there are
other, idle CPUs?

> Oh, and Frederic suggested that we would be better off with something based
> on tracing API and I agree, so the debugfs thing is currently dropped from
> the tree.  What do you think?

I probably disagree.  I just want to be able to cat a file and see the current
runqueue state.  I don't want to have to write and distribute a special program
to do this.  Of course, I don't know that much about the tracing API, so
cat'ing a file to get the runqueue listed nicely may be possible with that.

David
