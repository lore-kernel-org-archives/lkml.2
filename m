Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0IDHXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 03:23:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40472 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0IDHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 03:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WF964j7zPjFIimqWvcdHgNuNmS+XCyF1/Y/uVpn5Kk5tUh1EszlFYikUuVP2A3j7zS
         k2QCEvfGI/s8Y27r+Vg/VLNAzbfwJf8fmy8yyuxdbvOuM1pxKw/NQ8OBMXZdtlXSuT//
         Acc4NzW3AXE9jJrcYDnV/gqDyg6JKWN7J50OI=
Date: Sat, 4 Sep 2010 10:23:23 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, gregkh@suse.de
Subject: Re: [PATCH] serial: amba-pl010: fix set_ldisc
Message-ID: <20100904072323.GR25559@gw.healthdatacare.com>
References: <1283101965-12161-1-git-send-email-mika.westerberg@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283101965-12161-1-git-send-email-mika.westerberg@iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 08:12:45PM +0300, Mika Westerberg wrote:
> Commit d87d9b7d1 ("tty: serial - fix tty referencing in set_ldisc") changed
> set_ldisc to take ldisc number as parameter. This patch fixes AMBA PL010 driver
> according the new prototype.

Hi,

If there are no objections, could this be merged? I CC'd Greg as I'm not sure
who is the serial maintainer.

Thanks,
MW

> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/serial/amba-pl010.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
> index 50441ff..2904aa0 100644
> --- a/drivers/serial/amba-pl010.c
> +++ b/drivers/serial/amba-pl010.c
> @@ -472,14 +472,9 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
>  	spin_unlock_irqrestore(&uap->port.lock, flags);
>  }
>  
> -static void pl010_set_ldisc(struct uart_port *port)
> +static void pl010_set_ldisc(struct uart_port *port, int new)
>  {
> -	int line = port->line;
> -
> -	if (line >= port->state->port.tty->driver->num)
> -		return;
> -
> -	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
> +	if (new == N_PPS) {
>  		port->flags |= UPF_HARDPPS_CD;
>  		pl010_enable_ms(port);
>  	} else
> -- 
> 1.5.6.5
