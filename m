Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0HKD1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 23:27:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62385 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab0HKD1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 23:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tO5mrU4H954SnBzjO5X7pxhlEoXGSsCtLkmX8QFgbzhTVpRzMKGoFSc39SHNITYSzW
         yNfhCAblvbrGUgVf61V4aEtSDsGcjvTmxYOxmUTBgCFvUxJIsua/Nseoj7PF5Z7jvKd9
         wdPwCfOOg/UrLs+K9mrUfGchEFZ3b3sEL788s=
Date: Tue, 10 Aug 2010 20:27:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2] serport: place serport serio device correctly in the
 device tree
Message-ID: <20100811032744.GA10035@core.coreip.homeip.net>
References: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
 <1281363770-23598-2-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281363770-23598-2-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 06:22:50PM +0400, Dmitry Eremin-Solenikov wrote:
> Make serport serio device to be a child of corresponding tty device
> instead of just hanging at /sys/devices/serioX.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Looks good to me.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> ---
>  drivers/input/serio/serport.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 6d34511..6e362de 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -165,6 +165,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
>  	serio->open = serport_serio_open;
>  	serio->close = serport_serio_close;
>  	serio->port_data = serport;
> +	serio->dev.parent = tty->dev;
>  
>  	serio_register_port(serport->serio);
>  	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
> -- 
> 1.7.1
> 

-- 
Dmitry
