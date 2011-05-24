Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1EXHyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:54:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58802 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1EXHyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a8ecVPcFoA+D6C3QnDgIUzyv7YisZp3LV+DjMUk5ka4gpzFmTWimDHXGjLMHCSxTYG
         TKvvjSMe6hJaKoge2uhdyCSxz7wh3oc6EaCk6aePGW5UtZq5DCZMnEUmvXLCjysC6aoW
         As9jYJo/YDWI861epDOexq9xC5XJku6KVDFNs=
MIME-Version: 1.0
In-Reply-To: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
References: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
Date: Tue, 24 May 2011 15:54:17 +0800
Message-ID: <BANLkTinGZ0L4oQkBYo9H=R==X5Z+efjRaQ@mail.gmail.com>
Subject: Re: [PATCH] timers: consider slack value in mod_timer()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 6:58 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> There is an optimization which does not update the timer if the timer
> was pending and the expiration time was unchanged.
> Since commit 3bbb9ec9 ("timers: Introduce the concept of timer slack for
> legacy timers") this optimization is no longer applied for timers where
> the expiration time got extended due to the slack value. So here it adds
> the check again after the expiration time might have been updated.
>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  kernel/timer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index fd61986..bf09726 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -804,6 +804,8 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
>                return 1;
>
>        expires = apply_slack(timer, expires);

So, why not move above line up, then we can use the recalculated
expires?

Thanks,
Yong

> +       if (timer_pending(timer) && timer->expires == expires)
> +               return 1;
>
>        return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
>  }
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
