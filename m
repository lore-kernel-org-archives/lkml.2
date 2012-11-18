Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2KRTCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:02:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2KRTCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:02:39 -0500
Date: Sun, 18 Nov 2012 20:02:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] percpu_rw_semaphore: lockdep + config
Message-ID: <20121118190257.GA9660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Oleg Nesterov wrote:
>
> To remind, once/if I am sure you agree with this patch I'll send 2 additional
> and simple patches:
>
> 	1. lockdep annotations
>
> 	2. CONFIG_PERCPU_RWSEM

It turns out, lockdep annotations are not that simple due to internal
locks used by percpu_rw_semaphore. To clarify, it is actually simple
but lockdep_set_novalidate_class() doesn't seem to actually work, and
more importantly, it must not be used according to checkpatch.pl. And
I guess ->lockdep_recursion should not be used too.

However, without some tricks, the output from lockdep (when it finds
the problem) does not look very clear because it blames those internal
locks instead of "the whole" percpu_rw_semaphore.

So this series starts with the small optimization which I was going to
do later. It removes ->writer_mutex and greatly simplifies 2/3.

Oleg.

