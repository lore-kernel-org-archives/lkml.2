Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0HZX1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:27:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56021 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0HZX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sO0Rlqrbe6OWZQXQeGS75Rr3rFktmHSGffQpnEoD4yl1R5RFdgeIieqJUx0bs81doS
         dxA7U6WVPFM0je6sdRhJT94Lf8eQ/smIL5cg0/U5rMtAY3ukW3gRQv8iF4EseS71SjEJ
         SDZHxIgg/CwIIK1m4DzQWV5u4laeeF9BEwctw=
Date: Fri, 27 Aug 2010 08:30:25 +0900
From: Adam Jiang <jiang.adam@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: irq: add stackoverflow detection
Message-ID: <20100826232947.GA12367@capricorn-x61>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <linux-mips@linux-mips.org>
 <1282828755-11953-1-git-send-email-jiang.adam@gmail.com>
 <4C76B9E1.4080500@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C76B9E1.4080500@mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 11:00:49PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Adam Jiang wrote:
> 
> >Add stackoverflow detection to mips arch
> 
> [...]
> 
> >diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> >index c6345f5..8fdf79e 100644
> >--- a/arch/mips/kernel/irq.c
> >+++ b/arch/mips/kernel/irq.c
> >@@ -151,6 +151,25 @@ void __init init_IRQ(void)
> > #endif
> > }
> >+#ifdef DEBUG_STACKOVERFLOW
> >+static inline void check_stack_overflow(void)
> >+{
> >+	long sp;
> >+
> >+	asm volatile("move %0, $sp" : "=r" (sp));
> >+	sp = sp & (THREAD_SIZE-1);
> >+
> >+	/* check for stack overflow: is there less than 2KB free? */
> >+	if (unlikely(sp < (sizeof(struct thread_info) + 2048))) {
> >+		printk("do_IRQ: stack overflow: %ld\n",
> >+		       sp - sizeof(struct thread_info));
> >+		dump_stack();
> >+	}
> >+}
> >+#else
> >+static inline void check_stack_overflow(void) {}
> >+#endif
> >+
> > /*
> >  * do_IRQ handles all normal device IRQ's (the special
> >  * SMP cross-CPU interrupts have their own specific
> 
>    You've dropped call check_stack_overflow() call in do_IRQ() --
> was that intentional?

Of course NO. It is awful, I have say.

I spent a lot of time to struggle with git yesterday. When I revised the
coding style problem and tried to format-patch to master branch, then I
got 2 patches but not all in one. How could I rebase my working copy and
get an all-in-one patch of this?

I tried to revert my commit and redo this patch, then I lost to calling
it in do_IRQ();

Best regards,
/Adam

> 
> WBR, Sergei
