Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1DRQbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:31:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1DRQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:31:08 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=JTjb3um6TXYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tRtyh2qvoiNuSwtzAtEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 3/7] lockdep: Annotate read/write states
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110417095507.026186002@chello.nl>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.026186002@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 12:31:06 -0400
Message-ID: <1303144266.7181.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 11:45 +0200, Peter Zijlstra wrote:
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  # ifdef CONFIG_PROVE_LOCKING
> -#  define rwlock_acquire(l, s, t, i)           lock_acquire(l, s, t, 0, 2, NULL, i)
> -#  define rwlock_acquire_read(l, s, t, i)      lock_acquire(l, s, t, 2, 2, NULL, i)
> +#  define rwlock_acquire(l, s, t, i)           \
> +               lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
> +#  define rwlock_acquire_read(l, s, t, i)      \
> +               lock_acquire(l, s, t, STATE_RECURSIVE_READ, 2, NULL, i)
>  # else
> -#  define rwlock_acquire(l, s, t, i)           lock_acquire(l, s, t, 0, 1, NULL, i)
> -#  define rwlock_acquire_read(l, s, t, i)      lock_acquire(l, s, t, 2, 1, NULL, i)
> +#  define rwlock_acquire(l, s, t, i)           \
> +               lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
> +#  define rwlock_acquire_read(l, s, t, i)      \
> +               lock_acquire(l, s, t, STATE_RECURSIVE_READ, 1, NULL, i)
>  # endif
>  # define rwlock_release(l, n, i)               lock_release(l, n, i)
>  #else 

OT, I like this, we need to get rid of that other 2 and 1 too, as it is
very confusing to what they mean. But that can be done in a later clean
up.

-- Steve


