Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2AIJvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:51:03 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:61028 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2AIJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:51:00 -0500
X-IronPort-AV: E=Sophos;i="4.71,479,1320624000"; 
   d="scan'208";a="9890838"
Subject: Re: [Xen-devel] [PATCH 4/5] xen/pciback: Expand the warning message
 to include domain id.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Mon, 9 Jan 2012 09:50:57 +0000
In-Reply-To: <20120106221927.GA10248@phenom.dumpdata.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
	 <1325724403-29642-5-git-send-email-konrad.wilk@oracle.com>
	 <4F06C101020000780006AC32@nat28.tlf.novell.com>
	 <20120106150338.GB5855@phenom.dumpdata.com>
	 <1325865086.25206.512.camel@zakaz.uk.xensource.com>
	 <20120106160011.GD6125@phenom.dumpdata.com>
	 <20120106221927.GA10248@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1326102657.17210.11.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 22:19 +0000, Konrad Rzeszutek Wilk wrote:
> > > I suppose you might want "Overriding ownership to dom%d".
> > 
> > OK. To the point and potentially can fit in 80 lines :-).
> 
> how about this?
> > 
> From a3d4a80cdfd4274016522572148a89260b3f3de6 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 4 Jan 2012 14:16:45 -0500
> Subject: [PATCH] xen/pciback: Expand the warning message to include domain
>  id.
> 
> When a PCI device is transferred to another domain and it is still
> in usage (from the internal perspective), mention which other
> domain is using it to aid in debugging.
> 
> [v2: Truncate the verbose message per Jan Beulich suggestion]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xen-pciback/xenbus.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
> index 474d52e..2405a24 100644
> --- a/drivers/xen/xen-pciback/xenbus.c
> +++ b/drivers/xen/xen-pciback/xenbus.c
> @@ -243,8 +243,8 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
>  	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
>  	if (xen_register_device_domain_owner(dev,
>  					     pdev->xdev->otherend_id) != 0) {
> -		dev_err(&dev->dev, "device has been assigned to another " \
> -			"domain! Over-writting the ownership, but beware.\n");
> +		dev_err(&dev->dev, "Overriding ownership to dom%d.\n",
> +			xen_find_device_domain_owner(dev));

That sounds like you are going to be assigning the ownership to that
dom, but xen_find_device_domain_owner so aren't you actually steeling
ownership from that domain?

>  		xen_unregister_device_domain_owner(dev);
>  		xen_register_device_domain_owner(dev, pdev->xdev->otherend_id);
>  	}


