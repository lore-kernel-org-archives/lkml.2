Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab0JFPWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:22:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61548 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab0JFPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IVFy7eugbt3b+epJtEejQoZ7Ai1mgp7RH0i+wRSZUDKnBW3u54F+QDTXtKiCpwHGF7
         2Ww2WX5qIZmcjSvUeOL8Ijwz4kQ106GmwcxTEO0txqBi6HAEtJ+4swM7Qqs0zLxcd40z
         tDyOUpzrWU2qq5XRmRn4MUP5yulOMGbxh2AWs=
Date: Thu, 7 Oct 2010 00:25:54 +0900
From: Adam Jiang <jiang.adam@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mips: irq: add stackoverflow detection
Message-ID: <20101006152554.GC13400@capricorn-x61>
Mail-Followup-To: Ralf Baechle <ralf@linux-mips.org>,
	Sergei Shtylyov <sshtylyov@mvista.com>, linux-mips@linux-mips.org,
	linux-kernel@vger.kernel.org
References: <1286361676-10743-1-git-send-email-jiang.adam@gmail.com>
 <4CAC5537.9040904@mvista.com>
 <20101006112114.GA19856@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006112114.GA19856@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:21:15PM +0100, Ralf Baechle wrote:
> On Wed, Oct 06, 2010 at 02:53:43PM +0400, Sergei Shtylyov wrote:
> 
> > >Add stackoverflow detection to mips arch
> > 
> >    There's no such word: stackoverflow. Space is needed.
> > 
> > >This is the 3rd version of the smiple patch. 2K is too big for many
> > >system, so I Modified the warning line by following Ralf's suggestion.
> > 
> > >Signed-off-by: Adam Jiang<jiang.adam@gmail.com>
> > [...]
> > 
> > >diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> > >index c6345f5..b43edb7 100644
> > >--- a/arch/mips/kernel/irq.c
> > >+++ b/arch/mips/kernel/irq.c
> > >@@ -151,6 +151,28 @@ void __init init_IRQ(void)
> > >  #endif
> > >  }
> > >
> > >+#ifdef CONFIG_DEBUG_STACKOVERFLOW
> > >+static inline void check_stack_overflow(void)
> > >+{
> > >+	unsigned long sp;
> > >+
> > >+	asm volatile("move %0, $sp" : "=r" (sp));
> > >+	sp = sp & THREAD_MASK;
> > 
> >    Why not:
> > 
> > 	sp &= THREAD_MASK;
> > 
> >    It's C, after all! :-)
> 
> I already had accepted his previous version with minor changes so I've
> combined the two.

Thanks Ralf. I am very glad I can do this small piece of code for Linux
kernel, though with many faults. :) No doubt I will try to do much more
then.

Best regards,
/Adam
