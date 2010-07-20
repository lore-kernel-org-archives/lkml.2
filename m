Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0GTWnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:43:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932925Ab0GTWny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:43:54 -0400
X-User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
From: Tejun Heo <tj@kernel.org>
Date: Wed, 21 Jul 2010 00:39:13 +0200
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Message-ID: <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 22:42:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, David.

"David Howells" <dhowells@redhat.com> wrote:
> Does this mean you don't get reentrancy guarantees with unbounded work queues?

It means that unbound wq behaves like a generic worker pool.  Bound wq limits concurrency to minimal level but unbound one executes works as long as resources are available.  I'll continue below.

>I can't work out how you're achieving it with unbounded queues.  I presume with
>CPU-bound workqueues your doing it by binding the work item to the current CPU
>still...

Unbound works are served by a dedicated gcwq whose workers are not affine to any particular CPU.  As all unbound works are served by the same gcwq, non reentrancy is automatically guaranteed.

>Btw, how does this fare in an RT system, where work items bound to a CPU can't
>get executed because their CPU is busy with an RT thread, even though there are
>other, idle CPUs?

Sure, there's nothing special about unbound workers.  They're just normal kthreads.

>> Oh, and Frederic suggested that we would be better off with something based
>> on tracing API and I agree, so the debugfs thing is currently dropped from
>> the tree.  What do you think?
>
>I probably disagree.  I just want to be able to cat a file and see the current
>runqueue state.  I don't want to have to write and distribute a special program
>to do this.  Of course, I don't know that much about the tracing API, so
>cat'ing a file to get the runqueue listed nicely may be possible with that.

I'm relatively sure we can do that.  Frederic?

Thanks.

-- 
tejun
