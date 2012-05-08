Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2EHA0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:26:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:54838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803Ab2EHA0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141176245"
Date: Mon, 7 May 2012 17:26:40 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: girish verma <girish.gcet@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [patch] xhci: testing sizeof xhci_doorbell_array 2 time
Message-ID: <20120508002640.GA10340@xanatos>
References: <CAMC5Lb4bMfqnWuvzcisGNV-uM08vHJMLt8X+mYmOp0P6RzqtrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMC5Lb4bMfqnWuvzcisGNV-uM08vHJMLt8X+mYmOp0P6RzqtrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Girish,

Although this is a pretty trivial change, can you please Cc the
maintainer of the driver (me, for the xHCI driver) next time?  Either
check the MAINTAINERS file, or run scripts/get_maintainer.pl.

In any case, I see no problem with this patch.  Greg's already taken it
anyway. :)

Thanks,
Sarah Sharp

On Sun, May 06, 2012 at 08:35:13PM +0530, girish verma wrote:
> Testing BUILD_BUG_ON xhci_doorbell_array structure 2 time, redundant statement
> 
> Signed-off-by: Girish Verma <girish.gcet@gmail.com>
> 
>  ---
>  drivers/usb/host/xhci.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 36641a7..cfcf733 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4090,7 +4090,6 @@ static int __init xhci_hcd_init(void)
>  	BUILD_BUG_ON(sizeof(struct xhci_intr_reg) != 8*32/8);
>  	/* xhci_run_regs has eight fields and embeds 128 xhci_intr_regs */
>  	BUILD_BUG_ON(sizeof(struct xhci_run_regs) != (8+8*128)*32/8);
> -	BUILD_BUG_ON(sizeof(struct xhci_doorbell_array) != 256*32/8);
>  	return 0;
>  unreg_pci:
>  	xhci_unregister_pci();
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
