Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0EEXss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:48:48 -0400
Received: from kroah.org ([198.145.64.141]:60418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0EEXsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:48:46 -0400
Date: Wed, 5 May 2010 16:42:06 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4.1 5/8] USB: g_ffs: the FunctionFS gadget driver
Message-ID: <20100505234206.GA10165@kroah.com>
References: <cover.1273054944.git.mina86@mina86.com>
 <11f2d7a2b97b514b33b0f92d9456d0c6e1d7501e.1273054945.git.mina86@mina86.com>
 <4a74b9dde6495da76354f8caca267a57cf440a12.1273054945.git.mina86@mina86.com>
 <989d26541d5d1ef75f71576f6f295796dcaf0af8.1273054945.git.mina86@mina86.com>
 <81b16ab751d2b6075ec6358e355909f6087f4d23.1273054945.git.mina86@mina86.com>
 <19153ae5a33bfe27dd66f83ff1ea88cfd039fba7.1273054945.git.mina86@mina86.com>
 <2dfc60eedd6b15c55c33d462db51f775657e8120.1273061972.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dfc60eedd6b15c55c33d462db51f775657e8120.1273061972.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:25:55PM +0200, Michal Nazarewicz wrote:
> The Function Filesystem (FunctioFS) lets one create USB
> composite functions in user space in the same way as GadgetFS
> lets one create USB gadgets in user space.  This allows
> creation of composite gadgets such that some of the functions
> are implemented in kernel space (for instance Ethernet, serial
> or mass storage) and other are implemented in user space.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> There was a trivial bug in my previous patch.  The delta is:
> 
> diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
> index bed3641..4b0e4a0 100644
> --- a/drivers/usb/gadget/g_ffs.c
> +++ b/drivers/usb/gadget/g_ffs.c
> @@ -369,9 +369,8 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
>  
>  
>  static int __gfs_do_config(struct usb_configuration *c,
> -			   int (*eth)(struct usb_configuration *c,
> -				      u8 ethaddr[ETH_ALEN]),
> -			   u8 ethaddr[ETH_ALEN])
> +			   int (*eth)(struct usb_configuration *c, u8 *ethaddr),
> +			   u8 *ethaddr)
>  {
>  	int ret;
> 
> ETH_ALEN is not defined if g_ffs is configured not to include ECM nor RNDIS.
> 
> Sorry about the confusion.

No problem, I merged it with the previous patch.

thanks,

greg k-h
