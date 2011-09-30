Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab1I3IC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:02:26 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:47932 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab1I3ICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:02:18 -0400
X-IronPort-AV: E=Sophos;i="4.68,465,1312156800"; 
   d="scan'208";a="8142927"
Subject: Re: [Xen-devel] [PATCH 7/9] xen/xenbus: Check before dereferencing
 it.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Date: Fri, 30 Sep 2011 09:01:21 +0100
In-Reply-To: <1317325971-21603-8-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
	 <1317325971-21603-8-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317369681.26672.218.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> . we do the check whether 'xdev' is NULL - but after we have
> dereferenced it.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xenbus/xenbus_probe_backend.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
> index 60adf91..331589a 100644
> --- a/drivers/xen/xenbus/xenbus_probe_backend.c
> +++ b/drivers/xen/xenbus/xenbus_probe_backend.c
> @@ -103,10 +103,11 @@ static int xenbus_uevent_backend(struct device *dev,
>  		return -ENODEV;
>  
>  	xdev = to_xenbus_device(dev);

to_xenbus_device is just container_of. The only way it would return NULL
is if dev == offsetof(struct xenbus_device, dev), which isn't terribly
likely. A more likely error would be dev == NULL and we just checked
above.

> -	bus = container_of(xdev->dev.bus, struct xen_bus_type, bus);
>  	if (xdev == NULL)
>  		return -ENODEV;
>  
> +	bus = container_of(xdev->dev.bus, struct xen_bus_type, bus);
> +
>  	if (add_uevent_var(env, "MODALIAS=xen-backend:%s", xdev->devicetype))
>  		return -ENOMEM;
>  


