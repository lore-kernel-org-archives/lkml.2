Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0IHPhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:37:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61846 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0IHPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r+5XJnbEy4mbcBgbYKnEj3i8yc2+yiv4EQuMCEEk7+ivi6d8NQHYhMQbPWl6udPf9h
         h7P612gHbHePSebf8VyeWyl6qwr868ESGH6ch3Vn52OaK2nCVW18B9f+iapiyytwIHHR
         5sGxwOmXgJHm8mB2/3up209WsNHc0I16oHcBA=
Date: Wed, 8 Sep 2010 08:37:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/30] input: misc/hp_sdc_rtc: semaphore cleanup
Message-ID: <20100908153745.GD4190@core.coreip.homeip.net>
References: <20100907124636.880953480@linutronix.de>
 <20100907125054.888438853@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907125054.888438853@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 02:31:58PM -0000, Thomas Gleixner wrote:
> Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Dmitry Torokhov <dtor@mail.ru>

All 3 look good to me Thomas, please merge with the rest of the patch
series.

> 
> ---
>  drivers/input/misc/hp_sdc_rtc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/input/misc/hp_sdc_rtc.c
> ===================================================================
> --- linux-2.6.orig/drivers/input/misc/hp_sdc_rtc.c
> +++ linux-2.6/drivers/input/misc/hp_sdc_rtc.c
> @@ -104,7 +104,7 @@ static int hp_sdc_rtc_do_read_bbrtc (str
>  	t.endidx =		91;
>  	t.seq =			tseq;
>  	t.act.semaphore =	&tsem;
> -	init_MUTEX_LOCKED(&tsem);
> +	sema_init(&tsem, 0);
>  	
>  	if (hp_sdc_enqueue_transaction(&t)) return -1;
>  	
> @@ -698,7 +698,7 @@ static int __init hp_sdc_rtc_init(void)
>  		return -ENODEV;
>  #endif
>  
> -	init_MUTEX(&i8042tregs);
> +	sema_init(&i8042tregs, 1);
>  
>  	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
>  		return ret;
> 
> 

-- 
Dmitry
