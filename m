Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0DFM1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:27:53 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51774 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0DFM1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:27:47 -0400
Message-ID: <4BBB28BB.2080102@in.ibm.com>
Date: Tue, 06 Apr 2010 17:57:39 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Amit Shah <amit.shah@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and hvc_remove
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <20100321043725.GA21566@amit-x200.redhat.com> <20100324121902.GJ15789@amit-x200.redhat.com> <4BAC7AD4.4030309@in.ibm.com> <20100326095821.GA7039@amit-x200.redhat.com> <4BAC9D9E.5070901@in.ibm.com> <20100326124340.GB7039@amit-x200.redhat.com> <20100406114238.GN5594@kryten>
In-Reply-To: <20100406114238.GN5594@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> The patch below changes things to call tty_kref_put once for every
> hvc_close call, and with that my machine boots fine.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>   
Works for me. Thanks Anton.

Regards
-Sachin

> diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
> index d3890e8..35cca4c 100644
> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -368,16 +368,12 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
>  	hp = tty->driver_data;
>
>  	spin_lock_irqsave(&hp->lock, flags);
> -	tty_kref_get(tty);
>
>  	if (--hp->count == 0) {
>  		/* We are done with the tty pointer now. */
>  		hp->tty = NULL;
>  		spin_unlock_irqrestore(&hp->lock, flags);
>
> -		/* Put the ref obtained in hvc_open() */
> -		tty_kref_put(tty);
> -
>  		if (hp->ops->notifier_del)
>  			hp->ops->notifier_del(hp, hp->data);
>
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

