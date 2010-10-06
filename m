Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0JFEtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:49:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56123 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0JFEtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ewyqF2ym7z3EAkXRBvNmuh/JQ41ymhNnaDhFHmr9CFm+fL3ps3Qn6BjcNBgcuTovTY
         xB7rLF4Yrjwvfd+OBi0LkNXvYybdmw8IzkWfrPgR7UD4z7BbrXkNnSC03YVX6eRh5XPG
         0Xq4ZUVa3Xu3cIQC7aMmsFpA+2KB4HNpN1JoY=
Date: Wed, 6 Oct 2010 06:48:47 +0200
From: Dan Carpenter <error27@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/28] Staging: comedi: drivers.c: Edit file so that
	checkpatch.pl has 4 warnings and 0 errors
Message-ID: <20101006044847.GC5409@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
	abbotti@mev.co.uk, fmhess@users.sourceforge.net,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com> <1286326843-6170-7-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286326843-6170-7-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:00:22PM -0400, Tracey Dent wrote:
> @@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		if (!try_module_get(driv->module)) {
>  			printk
> -			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
> +			    (KERN_INFO "comedi: failed to increment	\
> +					module count, skipping\n");

This screws up the output that gets printed for the user.  It happens
again below several times.

Also it's best to not break up string literals across lines because then
someone can't do a:  grep "failed to increment module count".  For these
cases it's better to go over 80 characters and make grep work.

regards,
dan carpenter

>  			continue;
>  		}
>  		if (driv->num_names) {
> @@ -206,8 +207,9 @@ int comedi_driver_unregister(struct comedi_driver *driver)
>  		if (dev->attached && dev->driver == driver) {
>  			if (dev->use_count)
>  				printk
> -				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
> -				     dev->use_count);
> +				    (KERN_WARNING "BUG! detaching device     \
> +							with use_count=%d\n",
> +							dev->use_count);
>  			comedi_device_detach(dev);
>  		}
>  		mutex_unlock(&dev->mutex);
> @@ -647,7 +649,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
>  	if ((int)(async->buf_write_count + nbytes -
>  		  async->buf_write_alloc_count) > 0) {
>  		printk
> -		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
> +		    (KERN_INFO "comedi: attempted to write-free more	\
> +				bytes than have been write-allocated.\n");
>  		nbytes = async->buf_write_alloc_count - async->buf_write_count;
>  	}
>  	async->buf_write_count += nbytes;
> -- 
> 1.7.3.1.50.g1e633
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
