Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2FMBD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:03:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2FMBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:03:56 -0400
Date: Tue, 12 Jun 2012 18:03:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/13] fix wrong label in skel_open
Message-ID: <20120613010352.GD6765@kroah.com>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
 <1339057243-10029-2-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339057243-10029-2-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:20:31AM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/usb-skeleton.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> index 0616f23..efda3a5 100644
> --- a/drivers/usb/usb-skeleton.c
> +++ b/drivers/usb/usb-skeleton.c
> @@ -114,10 +114,11 @@ static int skel_open(struct inode *inode, struct file *file)
>  
>  	retval = usb_autopm_get_interface(interface);
>  	if (retval)
> -		goto out_err;
> +		goto exit2;
>  
>  	/* save our object in the file's private structure */
>  	file->private_data = dev;
> +exit2:
>  	mutex_unlock(&dev->io_mutex);

That's not so much as a "wrong label" as, "fix unlock bug on error
path", right?

thanks,

greg k-h
