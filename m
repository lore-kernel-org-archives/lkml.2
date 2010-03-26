Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0CZBmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:42:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:38597 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0CZBmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:42:05 -0400
Date: Fri, 26 Mar 2010 10:41:23 +0900
To: ben@decadent.org.uk
Cc: airlied@linux.ie, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1269401628.18314.264.camel@localhost>
References: <1269401628.18314.264.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100326104042T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Mar 2010 10:41:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 03:33:48 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:

> SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
> amd64-agp is apparently preferable since it has workarounds for some
> BIOS misconfigurations that sis-agp doesn't handle.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/char/agp/sis-agp.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)

Looks fine to me. Hopefully, amd64-agp can handle all SIS 760 systems.

Can we confirm that this can fix bugs reported in Debian's bug
tracking system (which you mentioned earlier)?


> diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
> index 6c3837a..95fdd4d 100644
> --- a/drivers/char/agp/sis-agp.c
> +++ b/drivers/char/agp/sis-agp.c
> @@ -415,14 +415,6 @@ static struct pci_device_id agp_sis_pci_table[] = {
>  		.subvendor	= PCI_ANY_ID,
>  		.subdevice	= PCI_ANY_ID,
>  	},
> -	{
> -		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
> -		.class_mask	= ~0,
> -		.vendor		= PCI_VENDOR_ID_SI,
> -		.device		= PCI_DEVICE_ID_SI_760,
> -		.subvendor	= PCI_ANY_ID,
> -		.subdevice	= PCI_ANY_ID,
> -	},
>  	{ }
>  };
>  
> -- 
> 1.7.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
