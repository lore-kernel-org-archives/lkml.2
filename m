Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2DSUT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:19:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60768 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2DSUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:19:25 -0400
Message-ID: <4F907348.9060201@suse.cz>
Date: Thu, 19 Apr 2012 22:19:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/tty/amiserial.c: add missing tty_unlock
References: <1334851960-29409-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1334851960-29409-1-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 06:12 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> tty_unlock is used on all other exits from the function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Jiri Slaby <jslaby@suse.cz>

This is broken since 2008 BTW.

> ---
>  drivers/tty/amiserial.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
> index 24145c3..6cc4358 100644
> --- a/drivers/tty/amiserial.c
> +++ b/drivers/tty/amiserial.c
> @@ -1073,8 +1073,10 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
>  		    (new_serial.close_delay != port->close_delay) ||
>  		    (new_serial.xmit_fifo_size != state->xmit_fifo_size) ||
>  		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
> -		     (port->flags & ~ASYNC_USR_MASK)))
> +		     (port->flags & ~ASYNC_USR_MASK))) {
> +			tty_unlock();
>  			return -EPERM;
> +		}
>  		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
>  			       (new_serial.flags & ASYNC_USR_MASK));
>  		state->custom_divisor = new_serial.custom_divisor;


-- 
js
suse labs

