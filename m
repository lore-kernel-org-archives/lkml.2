Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab0JFLVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:21:18 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38378 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab0JFLVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:21:17 -0400
Date: Wed, 6 Oct 2010 12:21:15 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Adam Jiang <jiang.adam@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mips: irq: add stackoverflow detection
Message-ID: <20101006112114.GA19856@linux-mips.org>
References: <1286361676-10743-1-git-send-email-jiang.adam@gmail.com>
 <4CAC5537.9040904@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAC5537.9040904@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 02:53:43PM +0400, Sergei Shtylyov wrote:

> >Add stackoverflow detection to mips arch
> 
>    There's no such word: stackoverflow. Space is needed.
> 
> >This is the 3rd version of the smiple patch. 2K is too big for many
> >system, so I Modified the warning line by following Ralf's suggestion.
> 
> >Signed-off-by: Adam Jiang<jiang.adam@gmail.com>
> [...]
> 
> >diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> >index c6345f5..b43edb7 100644
> >--- a/arch/mips/kernel/irq.c
> >+++ b/arch/mips/kernel/irq.c
> >@@ -151,6 +151,28 @@ void __init init_IRQ(void)
> >  #endif
> >  }
> >
> >+#ifdef CONFIG_DEBUG_STACKOVERFLOW
> >+static inline void check_stack_overflow(void)
> >+{
> >+	unsigned long sp;
> >+
> >+	asm volatile("move %0, $sp" : "=r" (sp));
> >+	sp = sp & THREAD_MASK;
> 
>    Why not:
> 
> 	sp &= THREAD_MASK;
> 
>    It's C, after all! :-)

I already had accepted his previous version with minor changes so I've
combined the two.

Thanks Adam!

  Ralf
