Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2IZVJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:09:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2IZVJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:09:19 -0400
Date: Wed, 26 Sep 2012 14:09:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC/cosmetic] driver base: use available pointer
Message-ID: <20120926210915.GA16674@kroah.com>
References: <Pine.LNX.4.64.1209241145210.11925@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209241145210.11925@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 11:48:28AM +0200, Guennadi Liakhovetski wrote:
> Don't recalculate an available pointer.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index a1a7225..efe9aa9 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -166,8 +166,8 @@ static void platform_device_release(struct device *dev)
>  	struct platform_object *pa = container_of(dev, struct platform_object,
>  						  pdev.dev);
>  
> -	of_device_node_put(&pa->pdev.dev);
> -	kfree(pa->pdev.dev.platform_data);
> +	of_device_node_put(dev);
> +	kfree(dev->platform_data);

If you don't mind, I'll leave it as-is, as it makes it a bit more
obvious as to exactly what we are cleaning up here.

thanks,

greg k-h
