Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1CURGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:06:54 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:36825 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1CURGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:06:51 -0400
Date: Mon, 21 Mar 2011 18:06:49 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, hjk@hansjkoch.de,
        manut@linutronix.de
Subject: Re: [PATCH v2] uio_netx: Add support for netPLC cards
Message-ID: <20110321170649.GA2750@local>
References: <1300718195.3457.43.camel@ubuntu-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300718195.3457.43.camel@ubuntu-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 03:36:35PM +0100, Daniel Trautmann wrote:
> This patch adds support for Hilscher / IBHsoftec netPLC cards to uio_netx userspace IO driver.
> 
> Changes from v1 -> v2:
> Fixed whitespace errors reported by scripts/checkpatch.pl which were caused by email client.

Looks OK to me.

Thanks for your contribution,
Hans

> 
> Signed-off-by: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>

Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

> ---
>  drivers/uio/uio_netx.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
> index 5ffdb48..a879fd5 100644
> --- a/drivers/uio/uio_netx.c
> +++ b/drivers/uio/uio_netx.c
> @@ -18,6 +18,9 @@
>  
>  #define PCI_VENDOR_ID_HILSCHER		0x15CF
>  #define PCI_DEVICE_ID_HILSCHER_NETX	0x0000
> +#define PCI_DEVICE_ID_HILSCHER_NETPLC	0x0010
> +#define PCI_SUBDEVICE_ID_NETPLC_RAM	0x0000
> +#define PCI_SUBDEVICE_ID_NETPLC_FLASH	0x0001
>  #define PCI_SUBDEVICE_ID_NXSB_PCA	0x3235
>  #define PCI_SUBDEVICE_ID_NXPCA		0x3335
>  
> @@ -66,6 +69,10 @@ static int __devinit netx_pci_probe(struct pci_dev *dev,
>  		bar = 0;
>  		info->name = "netx";
>  		break;
> +	case PCI_DEVICE_ID_HILSCHER_NETPLC:
> +		bar = 0;
> +		info->name = "netplc";
> +		break;
>  	default:
>  		bar = 2;
>  		info->name = "netx_plx";
> @@ -134,6 +141,18 @@ static struct pci_device_id netx_pci_ids[] = {
>  		.subdevice =	0,
>  	},
>  	{
> +		.vendor =       PCI_VENDOR_ID_HILSCHER,
> +		.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
> +		.subvendor =    PCI_VENDOR_ID_HILSCHER,
> +		.subdevice =    PCI_SUBDEVICE_ID_NETPLC_RAM,
> +	},
> +	{
> +		.vendor =       PCI_VENDOR_ID_HILSCHER,
> +		.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
> +		.subvendor =    PCI_VENDOR_ID_HILSCHER,
> +		.subdevice =    PCI_SUBDEVICE_ID_NETPLC_FLASH,
> +	},
> +	{
>  		.vendor =	PCI_VENDOR_ID_PLX,
>  		.device =	PCI_DEVICE_ID_PLX_9030,
>  		.subvendor =	PCI_VENDOR_ID_PLX,
> 
> 
> 
