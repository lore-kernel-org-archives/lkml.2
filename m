Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0FQXHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:07:41 -0400
Received: from kroah.org ([198.145.64.141]:42933 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873Ab0FQXHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:07:35 -0400
Date: Thu, 17 Jun 2010 16:06:39 -0700
From: Greg KH <greg@kroah.com>
To: Matti Lammi <mattij.lammi@gmail.com>
Cc: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       reodge@gmail.com, andrea.gelmini@gelma.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Commedi: Fixed some warnings reported by
 checkpatch.pl tool
Message-ID: <20100617230639.GA3740@kroah.com>
References: <1276758011-7054-1-git-send-email-mattij.lammi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276758011-7054-1-git-send-email-mattij.lammi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:00:11AM +0300, Matti Lammi wrote:
> Fixed a few "line over 80 characters" warnings. One of those lines were an
> actual code line and I don't know if my corresction is sufficent with that
> part. This is my third patch.
> 
> Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
> ---
>  drivers/staging/comedi/drivers.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 4a29ed7..9dcc5ef 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		if (!try_module_get(driv->module)) {
>  			printk
> -			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
> +			    (KERN_INFO "comedi: failed to increment "
> +			     "module count, skipping\n");
>  			continue;
>  		}
>  		if (driv->num_names) {
> @@ -206,8 +207,8 @@ int comedi_driver_unregister(struct comedi_driver *driver)
>  		if (dev->attached && dev->driver == driver) {
>  			if (dev->use_count)
>  				printk
> -				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
> -				     dev->use_count);
> +				    (KERN_WARNING "BUG! detaching device "
> +				     "with use_count=%d\n", dev->use_count);

No, please don't break up printk lines like this.  Move the whole thing
to one line and the checkpatch warning will go away.

>  			comedi_device_detach(dev);
>  		}
>  		mutex_unlock(&dev->mutex);
> @@ -442,7 +443,9 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
>  		unsigned i;
>  		for (i = 0; i < async->n_buf_pages; ++i) {
>  			if (async->buf_page_list[i].virt_addr) {
> -				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
> +				clear_bit(PG_reserved,
> +				&(virt_to_page(async->buf_page_list[i].
> +					       virt_addr)->flags));

Ick, that's not very clean, push the virt_ stuff over a bunch please.

>  				if (s->async_dma_dir != DMA_NONE) {
>  					dma_free_coherent(dev->hw_dev,
>  							  PAGE_SIZE,
> @@ -647,7 +650,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
>  	if ((int)(async->buf_write_count + nbytes -
>  		  async->buf_write_alloc_count) > 0) {
>  		printk
> -		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
> +		    (KERN_INFO "comedi: attempted to write-free more "
> +		     "bytes than have been write-allocated.\n");

Same as above.

>  		nbytes = async->buf_write_alloc_count - async->buf_write_count;
>  	}
>  	async->buf_write_count += nbytes;
> @@ -684,7 +688,8 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
>  	if ((int)(async->buf_read_count + nbytes -
>  		  async->buf_read_alloc_count) > 0) {
>  		printk(KERN_INFO
> -		       "comedi: attempted to read-free more bytes than have been read-allocated.\n");
> +		       "comedi: attempted to read-free more bytes "
> +		       "than have been read-allocated.\n");

And again.

thanks,

greg k-h
