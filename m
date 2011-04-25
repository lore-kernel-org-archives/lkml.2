Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1DYLVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:21:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56582 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab1DYLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L1wghaM7PeGtM6Xg1Mdx1M5EPA0+RCtOgkw9SUCwgf3uTJn4ZGkb4uVk+d4nzqpFAD
         gFlYDf8auDwHtPWOxdazTOHlDiNmbQO/3dO42/8Xc3tJOpLJDz+an+TPuVHpqpKyG6CC
         oeqpsbxX4OLa9QPcSjiQghSv+HvsYN7KZ4XKw=
Date: Mon, 25 Apr 2011 13:21:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] x86: signal: sys_rt_sigreturn() should use
 set_current_blocked()
Message-ID: <20110425112130.GJ17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134641.GH15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134641.GH15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:46:41PM +0200, Oleg Nesterov wrote:
> Normally sys_rt_sigreturn() restores the old current->blocked which was
> changed by handle_signal(), and unblocking is always fine.
> 
> But the debugger or application itself can change frame->uc_sigmask and
> thus we need set_current_blocked()->retarget_shared_pending().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

>  arch/x86/kernel/signal.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- sigprocmask/arch/x86/kernel/signal.c~7_sigreturn	2011-04-17 23:07:14.000000000 +0200
> +++ sigprocmask/arch/x86/kernel/signal.c	2011-04-17 23:19:13.000000000 +0200
> @@ -601,10 +601,7 @@ long sys_rt_sigreturn(struct pt_regs *re
>  		goto badframe;
>  
>  	sigdelsetmask(&set, ~_BLOCKABLE);
> -	spin_lock_irq(&current->sighand->siglock);
> -	current->blocked = set;
> -	recalc_sigpending();
> -	spin_unlock_irq(&current->sighand->siglock);
> +	set_current_blocked(&set);

Comment!

Thanks.

-- 
tejun
