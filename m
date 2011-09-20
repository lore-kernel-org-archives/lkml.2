Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1ITJUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:20:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:32932 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab1ITJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:20:03 -0400
Date: Tue, 20 Sep 2011 11:19:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
In-Reply-To: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109201047210.2723@ionos>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Move the global posix timer ids IDR to signal_struct. This removes
> a minor global scalability bottleneck and also allows to finally limit
> the number of process timers in a sane way (see next patch)
> 
> I put it into signal_struct following the other posix timer per process
> structures.
> 
> v2: Now with locking again (thanks Eric)
> v3: Fix the locking too (Eric Dumazet)
> v4: Use a mutex. Get rid of retry loop.
> idr_pre_get() is still there to avoid major surgery in lib/idr.c.
> Random gleixnerfication

I could laugh about that if you've had actually addressed my review
comments proper.

>  #ifdef CONFIG_SMP
> @@ -46,6 +48,8 @@ extern struct fs_struct init_fs;
>  	},								\
>  	.cred_guard_mutex =						\
>  		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
> +	.posix_timers_id = IDR_INIT(posix_timer_id),			\
> +	.idr_lock	 = __MUTEX_INITIALIZER(init_signals.idr_lock),  \

Hint: I even gave you the proper arguments for both initializers last
time.

So the above should be: Random sloppyfication.

Andi, seriously. Your signal to noise ratio has become annoying
again. We've been there before and you are on the verge of entering
the ignore list again.

Thanks,

	tglx

