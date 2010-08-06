Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600Ab0HFRDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:03:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:33073 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761554Ab0HFRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:03:08 -0400
Date: Fri, 6 Aug 2010 09:57:58 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] serport: place serport serio device correctly in
 the device tree
Message-ID: <20100806165758.GA3364@suse.de>
References: <1281112169-27086-1-git-send-email-dbaryshkov@gmail.com>
 <1281112169-27086-2-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281112169-27086-2-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 08:29:29PM +0400, Dmitry Eremin-Solenikov wrote:
> Make serport serio device to be a child of corresponding tty device
> instead of just hanging at /sys/devices/serioX.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  drivers/input/serio/serport.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 6d34511..ee0ff0c 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -165,6 +165,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
>  	serio->open = serport_serio_open;
>  	serio->close = serport_serio_close;
>  	serio->port_data = serport;
> +	serio->dev.parent = tty_get_device(tty);

You just grabbed a reference to this device, do you ever need to free it
up?

thanks,

greg k-h
