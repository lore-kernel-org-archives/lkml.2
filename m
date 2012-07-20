Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2GTPAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:00:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57977 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2GTPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:00:48 -0400
Date: Fri, 20 Jul 2012 08:00:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] driver-core: dev_to_node() should handle NULL pointers
Message-ID: <20120720150042.GA1996@kroah.com>
References: <20120720065622.GA11710@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720065622.GA11710@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 09:56:23AM +0300, Dan Carpenter wrote:
> What prompted this patch is that in dma_pool_create() we call
> dev_to_node() before checking whether "dev" is NULL.  It looks like
> there are places which call dma_pool_create() with a NULL pointer.  An
> example is in drivers/usb/gadget/amd5536udc.c.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker fix.
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index aa7b3b4..c80e7a8d 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -714,7 +714,9 @@ int dev_set_name(struct device *dev, const char *name, ...);
>  #ifdef CONFIG_NUMA
>  static inline int dev_to_node(struct device *dev)
>  {
> -	return dev->numa_node;
> +	if (dev)
> +		return dev->numa_node;
> +	return -1;

What happens if this function returns -1?  Can the callers properly
handle this?

thanks,

greg k-h
