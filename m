Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0IVOl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0IVOl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:41:56 -0400
Date: Wed, 22 Sep 2010 10:41:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] avoid second smp_processor_id() call in __touch_watchdog
Message-ID: <20100922144101.GG26290@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <20100818123346.02028e96.akpm@linux-foundation.org>
 <20100922090012.GA5459@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922090012.GA5459@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 12:00:12PM +0300, Sergey Senozhatsky wrote:
> Hello,
> 
> Per our previous conversation:
> 
> Andrew Morton wrote:
> > Fair enough, although strictly speaking this should be done in a
> > separate and later patch.
> > 
> 
> 
> Avoid double smp_processor_id() call in __touch_watchdog (smp_processor_id() 
> itself and later call in __get_cpu_var())
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks!  I'll apply it.

Cheers,
Don
> 
> ---
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 7f9c3c5..03d97c5 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -116,8 +116,7 @@ static unsigned long get_sample_period(void)
>  static void __touch_watchdog(void)
>  {
>  	int this_cpu = smp_processor_id();
> -
> -	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
> +	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
>  }
>  
>  void touch_softlockup_watchdog(void)
> 
