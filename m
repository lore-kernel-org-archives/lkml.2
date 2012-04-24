Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab2DXVyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:54:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2DXVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:54:04 -0400
Date: Tue, 24 Apr 2012 14:54:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spinlock_debug: Print kallsyms name for lock
Message-Id: <20120424145402.4f9be035.akpm@linux-foundation.org>
In-Reply-To: <4F961B2F.4060203@codeaurora.org>
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
	<1335217525-30709-2-git-send-email-sboyd@codeaurora.org>
	<20120423145431.617c2b01.akpm@linux-foundation.org>
	<4F961B2F.4060203@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 20:17:03 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 04/23/12 14:54, Andrew Morton wrote:
> >
> >> --- a/lib/spinlock_debug.c
> >> +++ b/lib/spinlock_debug.c
> >> @@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
> >>  	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
> >>  		msg, raw_smp_processor_id(),
> >>  		current->comm, task_pid_nr(current));
> >> -	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
> >> +	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
> >>  			".owner_cpu: %d\n",
> >>  		lock, lock->magic,
> >>  		owner ? owner->comm : "<none>",
> > Maybe.  It will only do useful things for statically-allocated locks
> > which are rare and which we are unlikely to screw up as easily as locks
> > which lie in dynamically allocated memory.
> 
> Agreed. It catches the really stupid stuff and that's about it. I was
> thinking we could get more information about dynamic allocated locks by
> adding some code to slab to find the slab that a pointer is allocated
> in. Does that sound possible?

Well lockdep knows lots of things about the lock, including numerous
stack backtraces which can be used to identify the lock.  Making 
spinlock_debug use lockdep infrastructure seems a good fit.

