Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0EGMxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:53:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0EGMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:53:00 -0400
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: xiaosuo@gmail.com, akpm@linux-foundation.org, eric.dumazet@gmail.com,
       jslaby@suse.cz, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com
In-Reply-To: <201005072142.IIC30776.FFtOOHMOVFJLQS@I-love.SAKURA.ne.jp>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
	 <t2p412e6f7f1005062132lbcaf5192ua6ead4872465a766@mail.gmail.com>
	 <201005072142.IIC30776.FFtOOHMOVFJLQS@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 14:52:54 +0200
Message-ID: <1273236774.1642.353.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 21:42 +0900, Tetsuo Handa wrote:
> Changli Gao wrote:
> > static void __kvfree(void *ptr, bool inatomic)
> 
> inatomic might be confusing because what vfree() checks is
> BUG_ON(in_interrupt()) rather than BUG_ON(in_atomic()).
> 
> > {
> >         if (unlikely(ZERO_OR_NULL_PTR(ptr)))
> >                 return;
> >         if (is_vmalloc_addr(ptr)) {
> >                 if (inatomic) {
> 
> By the way, is in_interrupt() a heavy operation?
> 
>   register unsigned long current_stack_pointer asm("esp") __used;
>   static inline struct thread_info *current_thread_info(void)
>   {
>   	return (struct thread_info *)
>   		(current_stack_pointer & ~(THREAD_SIZE - 1));
>   }
>   #define preempt_count() (current_thread_info()->preempt_count)
>   #define irq_count()     (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK | NMI_MASK))
>   #define in_interrupt()  (irq_count())
> 
> If we can agree on changing from (inatomic) to (in_interrupt()),
> we can merge kvfree() and kvfree_inatomic().

I really dislike all of that, just don't allow usage from interrupt
context.



