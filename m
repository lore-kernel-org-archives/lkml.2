Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1F1RRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:17:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759768Ab1F1RQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:16:40 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=zgHg_0SvolMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=olSRqFwo9yuDYfkBqlkA:9 a=DCauGC0tstg6cRuJlPgA:7 a=PUjeQqilurYA:10 a=GogJvg7uENZPGQGa:21 a=VYJNpld5fFGkkUZa:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] mm: Document handle_mm_fault()
From: Steven Rostedt <rostedt@goodmis.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <20110628170953.GA3482@redhat.com>
References: <20110628164750.281686775@goodmis.org>
	 <20110628165303.010143380@goodmis.org>  <20110628170953.GA3482@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 28 Jun 2011 13:16:39 -0400
Message-ID: <1309281399.26417.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 20:09 +0300, Gleb Natapov wrote:

> > -/*
> > - * By the time we get here, we already hold the mm semaphore
> > +/**
> > + * handle_mm_fault - main routine for handling page faults
> > + * @mm:		the mm_struct of the target address space
> > + * @vma:	vm_area_struct holding the applicable pages
> > + * @address:	the address that took the fault
> > + * @flags:	flags modifying lookup behaviour
> > + *
> > + * Must have @mm->mmap_sem held.
> > + *
> > + * Note: if @flags has FAULT_FLAG_ALLOW_RETRY set then the mmap_sem
> > + *       may be released if it failed to arquire the page_lock. If the
> > + *       mmap_sem is released then it will return VM_FAULT_RETRY set.
> > + *       This is to keep the time mmap_sem is held when the page_lock
> > + *       is taken for IO.
> > + * Exception: If FAULT_FLAG_RETRY_NOWAIT is set, then it will
> > + *       not release the mmap_sem, but will still return VM_FAULT_RETRY
> > + *       if it failed to acquire the page_lock.
> I wouldn't describe it like that. It tells handle_mm_fault() to start
> IO if needed, but do not wait for its completion.

This isn't a description of the flag itself. It's a description of the
mmap_sem behavior for the flag. Again, this came about because of the
subtle locking that handle_mm_fault() does with mmap_sem. When it comes
to locking, we need things documented very well, as locking is usually
what most developers get wrong even when subtle locking does not exist.

> 
> > + *       This is for helping virtualization. See get_user_page_nowait().
> The virtialization is the only user right now, but I wouldn't describe
> this flag as virtialization specific. Why should we put this in the
> comment?  The comment will become outdated when other users arise
> and meanwhile a simple grep will reveal the above information anyway.

I've been going in the direction of adding comments about how things
help. OK, so it's the only user now. I could change this to, "This is
for helping things like virtualization." When reading code, it is nice
to know why something is done that is out of the ordinary.

If it changes, then we should change the comments. The best place for
keeping code documented and up to date, is right at the code. 
ie. comments.


-- Steve


