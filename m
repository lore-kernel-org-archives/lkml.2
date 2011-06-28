Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab1F1RCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:02:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069Ab1F1Q7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:59:54 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=zgHg_0SvolMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=M7iHjAYi4NO0OCgm-g0A:9 a=PUjeQqilurYA:10 a=brMMY1IpqinEwQgu:21 a=2-FPJunabzDAf17j:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] mm: Document handle_mm_fault()
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <20110628165303.010143380@goodmis.org>
References: <20110628164750.281686775@goodmis.org>
	 <20110628165303.010143380@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 28 Jun 2011 12:59:52 -0400
Message-ID: <1309280392.26417.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 12:47 -0400, Steven Rostedt wrote:
> -
>  mm/memory.c |   22 ++++++++++++++++++++--
>  1 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 5371b5e..3cf30f6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3378,8 +3378,26 @@ unlock:
>  	return 0;
>  }
>  
> -/*
> - * By the time we get here, we already hold the mm semaphore
> +/**
> + * handle_mm_fault - main routine for handling page faults
> + * @mm:		the mm_struct of the target address space
> + * @vma:	vm_area_struct holding the applicable pages
> + * @address:	the address that took the fault
> + * @flags:	flags modifying lookup behaviour
> + *
> + * Must have @mm->mmap_sem held.
> + *
> + * Note: if @flags has FAULT_FLAG_ALLOW_RETRY set then the mmap_sem
> + *       may be released if it failed to arquire the page_lock. If the

s/arquire/acquire/

Hmm, I thought I fixed that. I better test the first patch again, in
case it has issues in it that I thought I fixed.

-- Steve

> + *       mmap_sem is released then it will return VM_FAULT_RETRY set.
> + *       This is to keep the time mmap_sem is held when the page_lock
> + *       is taken for IO.
> + * Exception: If FAULT_FLAG_RETRY_NOWAIT is set, then it will
> + *       not release the mmap_sem, but will still return VM_FAULT_RETRY
> + *       if it failed to acquire the page_lock.
> + *       This is for helping virtualization. See get_user_page_nowait().
> + *
> + * Returns status flags based on the VM_FAULT_* flags in <linux/mm.h>
>   */
>  int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		unsigned long address, unsigned int flags)


