Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2C0RlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:41:24 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50525 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C0RlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:41:19 -0400
Date: Tue, 27 Mar 2012 13:36:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, davem@davemloft.net
Cc: xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com
Subject: Re: [Xen-devel] [PATCH] xen: only check xen_platform_pci_unplug if
 hvm
Message-ID: <20120327173637.GA2982@phenom.dumpdata.com>
References: <1332869468-12617-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332869468-12617-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F71FBB5.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 07:31:08PM +0200, Igor Mammedov wrote:
> commit b9136d207f08
>   xen: initialize platform-pci even if xen_emul_unplug=never
> 
> breaks blkfront/netfront by not loading them because of
> xen_platform_pci_unplug=0 and it is never set for PV guest.

Looks good to me.

If the networking/block maintainers don't object I can push this out to
Linus when rc1 comes out.

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  drivers/block/xen-blkfront.c |    2 +-
>  drivers/net/xen-netfront.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index d5e1ab9..98cbeba 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1475,7 +1475,7 @@ static int __init xlblk_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> -	if (!xen_platform_pci_unplug)
> +	if (xen_hvm_domain() && !xen_platform_pci_unplug)
>  		return -ENODEV;
>  
>  	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 663b32c..0ebbb19 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1965,7 +1965,7 @@ static int __init netif_init(void)
>  	if (xen_initial_domain())
>  		return 0;
>  
> -	if (!xen_platform_pci_unplug)
> +	if (xen_hvm_domain() && !xen_platform_pci_unplug)
>  		return -ENODEV;
>  
>  	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
> -- 
> 1.7.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
