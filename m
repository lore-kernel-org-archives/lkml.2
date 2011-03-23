Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1CWJPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:15:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59328 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1CWJPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dhLI31r86yNDkC+9FznLzdrlubikOjTD5dw3XCDuzFhYP+OFMEiw5nRd/Dkz6m2JgS
         osJCKgFetSmMiSlNXhjfzp8xLpB3ZhyhTlWWSnw1azukpM71WurQdfxIb28QFF4rhHDX
         3/qPb0te3Wc0f0rLru9RGDATmb3wNlDsavvNs=
MIME-Version: 1.0
In-Reply-To: <1300870200-24405-2-git-send-email-jslaby@suse.cz>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz> <1300870200-24405-2-git-send-email-jslaby@suse.cz>
From: Govindraj <govindraj.ti@gmail.com>
Date: Wed, 23 Mar 2011 14:45:31 +0530
Message-ID: <AANLkTim3XGC5EuHEdNqchQmWmcerXpnKCKZ3SbaibmXQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] TTY: serial_core, remove unused variable
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 2:19 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> drivers/tty/serial/serial_core.c:1980:2: warning: Value stored to 'tty' is never read
>        tty = port->tty;
>        ^     ~~~~~~~~~
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>


Acked-by: Govindraj.R <govindraj.raja@ti.com>


> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-serial@vger.kernel.org
> ---
>  drivers/tty/serial/serial_core.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 733fe8e..d6e7240 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1972,13 +1972,9 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>        struct tty_port *port = &state->port;
>        struct device *tty_dev;
>        struct uart_match match = {uport, drv};
> -       struct tty_struct *tty;
>
>        mutex_lock(&port->mutex);
>
> -       /* Must be inside the mutex lock until we convert to tty_port */
> -       tty = port->tty;
> -
>        tty_dev = device_find_child(uport->dev, &match, serial_match_port);
>        if (device_may_wakeup(tty_dev)) {
>                if (!enable_irq_wake(uport->irq))
> --
> 1.7.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
