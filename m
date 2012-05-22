Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2EVSlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:41:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48039 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2EVSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:41:14 -0400
Date: Tue, 22 May 2012 14:34:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Marek Marczykowski <marmarek@invisiblethingslab.com>, davem@davemloft.net
Cc: xen-devel@lists.xen.org, virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: do not disable netfront in dom0
Message-ID: <20120522183433.GB24107@phenom.dumpdata.com>
References: <20120522130558.D828E6C7@duch.mimuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522130558.D828E6C7@duch.mimuw.edu.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 01:45:10PM +0200, Marek Marczykowski wrote:
> Netfront driver can be also useful in dom0, eg when all NICs are assigned to
> some domU (aka driver domain). Then using netback in domU and netfront in dom0
> is the only way to get network access in dom0.
> 
> Signed-off-by: Marek Marczykowski <marmarek@invisiblethingslab.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


> ---
>  drivers/net/xen-netfront.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 698b905..e31ebff 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1953,9 +1953,6 @@ static int __init netif_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> -	if (xen_initial_domain())
> -		return 0;
> -
>  	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
>  
>  	return xenbus_register_frontend(&netfront_driver);
> @@ -1965,9 +1962,6 @@ module_init(netif_init);
>  
>  static void __exit netif_exit(void)
>  {
> -	if (xen_initial_domain())
> -		return;
> -
>  	xenbus_unregister_driver(&netfront_driver);
>  }
>  module_exit(netif_exit);
> -- 
> 1.7.4.4
