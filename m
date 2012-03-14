Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030659Ab2CNQhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:37:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27581 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab2CNQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:37:21 -0400
Date: Wed, 14 Mar 2012 12:33:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel <xen-devel@lists.xen.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xenbus: don't free other end details too early
Message-ID: <20120314163308.GE16960@phenom.dumpdata.com>
References: <4F5501D30200007800076707@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5501D30200007800076707@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F60C93B.00AF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:11:31PM +0000, Jan Beulich wrote:
> The individual drivers' remove functions could legitimately attempt to
> access this information (for logging messages if nothing else). Note
> that I did not in fact observe a problem anywhere, but I came across
> this while looking into the reasons for what turned out to need the
> fix at https://lkml.org/lkml/2012/3/5/336 to vsprintf().

applied.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  drivers/xen/xenbus/xenbus_probe.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- 3.3-rc6/drivers/xen/xenbus/xenbus_probe.c
> +++ 3.3-rc6-xenbus-remove-details/drivers/xen/xenbus/xenbus_probe.c
> @@ -257,11 +257,12 @@ int xenbus_dev_remove(struct device *_de
>  	DPRINTK("%s", dev->nodename);
>  
>  	free_otherend_watch(dev);
> -	free_otherend_details(dev);
>  
>  	if (drv->remove)
>  		drv->remove(dev);
>  
> +	free_otherend_details(dev);
> +
>  	xenbus_switch_state(dev, XenbusStateClosed);
>  	return 0;
>  }
> 
> 
> 

> The individual drivers' remove functions could legitimately attempt to
> access this information (for logging messages if nothing else). Note
> that I did not in fact observe a problem anywhere, but I came across
> this while looking into the reasons for what turned out to need the
> fix at https://lkml.org/lkml/2012/3/5/336 to vsprintf().
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  drivers/xen/xenbus/xenbus_probe.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- 3.3-rc6/drivers/xen/xenbus/xenbus_probe.c
> +++ 3.3-rc6-xenbus-remove-details/drivers/xen/xenbus/xenbus_probe.c
> @@ -257,11 +257,12 @@ int xenbus_dev_remove(struct device *_de
>  	DPRINTK("%s", dev->nodename);
>  
>  	free_otherend_watch(dev);
> -	free_otherend_details(dev);
>  
>  	if (drv->remove)
>  		drv->remove(dev);
>  
> +	free_otherend_details(dev);
> +
>  	xenbus_switch_state(dev, XenbusStateClosed);
>  	return 0;
>  }

