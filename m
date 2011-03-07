Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1CGUYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:24:17 -0500
Received: from kroah.org ([198.145.64.141]:44842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab1CGUYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:24:15 -0500
Date: Mon, 7 Mar 2011 12:13:41 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-gadget: unlock data->lock mutex on error path in
 ep_read()
Message-ID: <20110307201341.GA27863@kroah.com>
References: <51766.91.79.113.99.1299279290.squirrel@mail.ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51766.91.79.113.99.1299279290.squirrel@mail.ispras.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 01:54:50AM +0300, Alexey Khoroshilov wrote:
> ep_read() acquires data->lock mutex in get_ready_ep() and releases it on
> all paths except for one: when usb_endpoint_xfer_isoc() failed. The patch
> adds mutex_unlock(&data->lock) at that path.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/usb/gadget/inode.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index 3ed73f4..a01383f 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -386,8 +386,10 @@ ep_read (struct file *fd, char __user *buf, size_t
> len, loff_t *ptr)
> 
>         /* halt any endpoint by doing a "wrong direction" i/o call */
>         if (usb_endpoint_dir_in(&data->desc)) {
> -               if (usb_endpoint_xfer_isoc(&data->desc))

Your patch is line-wrapped and all of the tabs are converted to spaces,
making it impossible to apply :(

Care to fix your email client and try again?

thanks,

greg k-h
