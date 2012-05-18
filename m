Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966130Ab2ERRsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:48:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:56103 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965970Ab2ERRsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:48:19 -0400
Message-ID: <4FB68B57.7040404@mev.co.uk>
Date: Fri, 18 May 2012 18:48:07 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: cleanup all the comedi_driver 'detach'
 functions
References: <201205171711.14968.hartleys@visionengravers.com> <4FB6230C.2080604@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698AE1272@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698AE1272@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-18 17:56, H Hartley Sweeten wrote:
> Can you test this patch and let me know what the resulting output
> is? You may need to change the dev_dbg to dev_info or something
> else if you don't have the proper kernel debugging enabled.

> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 1c3d638..d6bb1f9 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -91,11 +91,14 @@ static void cleanup_device(struct comedi_device *dev)
>   static void __comedi_device_detach(struct comedi_device *dev)
>   {
>   	dev->attached = 0;
> -	if (dev->driver)
> +	if (dev->driver) {
>   		dev->driver->detach(dev);
> -	else
> -		printk(KERN_WARNING
> +		dev_dbg(dev->class_dev, "%s detached\n",
> +			dev->driver->driver_name);
> +	} else {
> +		dev_warn(dev->class_dev,
>   		       "BUG: dev->driver=NULL in comedi_device_detach()\n");
> +	}
>   	cleanup_device(dev);
>   }

It works, but I'd prefer dev_info over dev_dbg.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
