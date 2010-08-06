Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611Ab0HFRDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:03:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:33075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761572Ab0HFRDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:03:09 -0400
Date: Fri, 6 Aug 2010 09:58:44 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty_io: add an API to get device corresponding to
 tty_struct
Message-ID: <20100806165844.GB3364@suse.de>
References: <1281112169-27086-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281112169-27086-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 08:29:28PM +0400, Dmitry Eremin-Solenikov wrote:
> Some device drivers (mostly tty line disciplines) would like to have way
> to get a struct device instancve corresponding to passed tty_struct. Add
> respective API call.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  drivers/char/tty_io.c |   20 ++++++++++++++++++++
>  include/linux/tty.h   |    1 +
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index d71f0fc..43fdeef 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -3017,6 +3017,26 @@ dev_t tty_devnum(struct tty_struct *tty)
>  }
>  EXPORT_SYMBOL(tty_devnum);
>  
> +static int dev_match_devt(struct device *dev, void *data)
> +{
> +	dev_t *devt = data;
> +	return dev->devt == *devt;
> +}
> +
> +/**
> + * 	tty_get_device - get a device corresponding to tty
> + * 	@tty: the struct that describes the tty device
> + *
> + * 	Returns a pointer to the struct device for this tty device
> + * 	(or NULL in case of error).

You should add some wording here that says that the device now has an
increased reference count and that you better drop it when you are done
with it, otherwise it will stay around for a while.

Other than that, I like the idea.

Care to redo it?

thanks,

greg k-h
