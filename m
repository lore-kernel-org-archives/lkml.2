Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882Ab1ETOdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:33:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42646 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1ETOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hi1ACq3oqOqe7OgfmBy1gT/sj7yeG2J3EJR1Px8R49+AFoo44ufmNpyIeq1CA2wh/N
         yRUk4/iLITOkj1pVIzbl+mc6v83lwqnb/rpSSRRR+DnYKpcFnGUmLYFlsbhydetaEzV5
         cSybafP0G56djbWmngozIP8AwVudJHpXploYg=
Date: Fri, 20 May 2011 16:32:59 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
Message-ID: <20110520143259.GB5785@riccoc20.at.omicron.at>
References: <1305777978.7481.37.camel@pasglop>
 <20110520132328.GA5785@riccoc20.at.omicron.at>
 <20110520135845.GG25179@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520135845.GG25179@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 09:58:45AM -0400, Josh Boyer wrote:
> On Fri, May 20, 2011 at 03:23:29PM +0200, Richard Cochran wrote:
> >When I try to build 'next' (now at 208b3a4c), it does not compile due
> >to a change from the following commit.
> >
> >> Benjamin Herrenschmidt (1):
> >>       powerpc/smp: Make start_secondary_resume available to all CPU variants
> >
> >I would appreciate your help in getting this fixed...
> 
> Could you try the patch below?

Yes, and it both compiles and boots.

Thanks,
Richard

> 
> Commit 69e3cea8d5fd526 introduced start_secondary_resume to misc_32.S,
> however it uses a 64-bit instruction which is not valid on 32-bit
> platforms.  Use 'stw' instead.
> 
> Reported-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> ---
> 
> diff --git a/arch/powerpc/kernel/misc_32.S
> b/arch/powerpc/kernel/misc_32.S
> index 402560e..998a100 100644
> --- a/arch/powerpc/kernel/misc_32.S
> +++ b/arch/powerpc/kernel/misc_32.S
> @@ -700,7 +700,7 @@ _GLOBAL(start_secondary_resume)
> 	rlwinm  r1,r1,0,0,(31-THREAD_SHIFT)     /* current_thread_info() */
> 	addi    r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
> 	li      r3,0
> -	std     r3,0(r1)                /* Zero the stack frame pointer */
> +	stw     r3,0(r1)                /* Zero the stack frame pointer */
> 	bl      start_secondary
> 	b       .
>  #endif /* CONFIG_SMP */
> 
