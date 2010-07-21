Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0GUNKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0GUNKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:10:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com>
References: <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com>
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
Date: Wed, 21 Jul 2010 14:08:45 +0100
Message-ID: <21485.1279717725@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> As all unbound works are served by the same gcwq, non reentrancy is
> automatically guaranteed.

That doesn't actually explain _how_ it's non-reentrant.  The gcwq includes a
collection of threads that can execute from it, right?  If so, what mechanism
prevents two threads from executing the same work item, if that work item
isn't bound to a CPU?  I've been trying to figure this out from the code, but
I don't see it offhand.

> > Btw, how does this fare in an RT system, where work items bound to a CPU
> > can't get executed because their CPU is busy with an RT thread, even
> > though there are other, idle CPUs?
> 
> Sure, there's nothing special about unbound workers.  They're just normal
> kthreads.

I should've been clearer: As I understand it, normal (unbound) worker items
are bound to the CPU on which they were queued, and will be executed there
only (barring CPU removal).  If that's the case, isn't it possible that work
items can be prevented from getting execution time by an RT thread that's
hogging a CPU and won't let go?

David
