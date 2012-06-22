Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867Ab2FVJIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:08:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:33543 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761839Ab2FVJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:08:53 -0400
Date: Fri, 22 Jun 2012 11:08:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        leroy christophe <christophe.leroy@c-s.fr>,
        Iratxo Pichel Ortiz <ipichel@albentia.com>,
        David Garcia <dgarcia@albentia.com>
Subject: Re: [PATCH][RT] spinlock: Add include for BUG() in spinlock_rt.h
In-Reply-To: <1340285878.27036.138.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1206221108180.2853@ionos>
References: <1340285878.27036.138.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Steven Rostedt wrote:

> spinlock_rt.h references BUG(), but it does not include bug.h, and on
> some architectures (powerpc) this can cause a build failure.
> 
> Reported-by: Iratxo Pichel Ortiz <ipichel@albentia.com>
> Reported-by: leroy christophe <christophe.leroy@c-s.fr>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ----
> [ Thomas, can you add this patch to your queue so that I can add it to
> stable. Please, let me know when you have. Thanks! ]

Picked it up, thanks. Please take it right away w/o waiting for my
release.

Thanks,

	Thomas

 
> diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
> index 3b555b4..0618387 100644
> --- a/include/linux/spinlock_rt.h
> +++ b/include/linux/spinlock_rt.h
> @@ -5,6 +5,8 @@
>  #error Do not include directly. Use spinlock.h
>  #endif
>  
> +#include <linux/bug.h>
> +
>  extern void
>  __rt_spin_lock_init(spinlock_t *lock, char *name, struct lock_class_key *key);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
