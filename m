Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2DZAlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:41:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932688Ab2DZAlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:41:10 -0400
Date: Thu, 26 Apr 2012 01:41:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>
Message-ID: <20120426004107.GJ3932@decadent.org.uk>
References: <20120424223305.GA7748@kroah.com>
 <20120424223245.832510907@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223245.832510907@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 45/62] usb: musb: omap: fix crash when musb glue (omap) gets
 initialized
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 03:33:26PM -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kishon Vijay Abraham I <kishon@ti.com>
> 
> commit 3006dc8c627d738693e910c159630e4368c9e86c upstream.
> 
> pm_runtime_enable is being called after omap2430_musb_init. Hence
> pm_runtime_get_sync in omap2430_musb_init does not have any effect (does
> not enable clocks) resulting in a crash during register access. It is
> fixed here.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/usb/musb/omap2430.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -451,14 +451,14 @@ static int __init omap2430_probe(struct
>  		goto err2;
>  	}
>  
> +	pm_runtime_enable(&pdev->dev);
> +
>  	ret = platform_device_add(musb);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register musb device\n");

This failure path now needs a call to pm_runtime_disable().

Ben.

>  		goto err2;
>  	}
>  
> -	pm_runtime_enable(&pdev->dev);
> -
>  	return 0;
>  
>  err2:

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
