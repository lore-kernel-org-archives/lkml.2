Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2DEOGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:06:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42196 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752779Ab2DEOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:06:29 -0400
Date: Thu, 5 Apr 2012 10:06:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: re-arranging ehci functions
In-Reply-To: <1333605536-5792-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1204051004350.1361-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Venu Byravarasu wrote:

> Re-arranged standard and tegra specific ehci functions
> into two separate groups, for more readability
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/usb/host/ehci-tegra.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 3de48a2..96c942c 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -552,31 +552,32 @@ static const struct hc_driver tegra_ehci_hc_driver = {
>  	.description		= hcd_name,
>  	.product_desc		= "Tegra EHCI Host Controller",
>  	.hcd_priv_size		= sizeof(struct ehci_hcd),
> -
>  	.flags			= HCD_USB2 | HCD_MEMORY,
>  
> -	.reset			= tegra_ehci_setup,
> -	.irq			= ehci_irq,
> -
> +	/* standard ehci functions */
>  	.start			= ehci_run,
>  	.stop			= ehci_stop,
> -	.shutdown		= tegra_ehci_shutdown,
> -	.urb_enqueue		= ehci_urb_enqueue,
>  	.urb_dequeue		= ehci_urb_dequeue,
> -	.map_urb_for_dma	= tegra_ehci_map_urb_for_dma,
> -	.unmap_urb_for_dma	= tegra_ehci_unmap_urb_for_dma,
>  	.endpoint_disable	= ehci_endpoint_disable,
>  	.endpoint_reset		= ehci_endpoint_reset,
>  	.get_frame_number	= ehci_get_frame,
>  	.hub_status_data	= ehci_hub_status_data,
> -	.hub_control		= tegra_ehci_hub_control,
>  	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
> +	.relinquish_port	= ehci_relinquish_port,
> +	.port_handed_over	= ehci_port_handed_over,
> +
> +	/* modified ehci functions for tegra */
> +	.reset			= tegra_ehci_setup,
> +	.irq			= tegra_ehci_irq,

What happened here?  This patch is supposed to rearrange the entries, 
not change them.

> +	.shutdown		= tegra_ehci_shutdown,
> +	.map_urb_for_dma	= tegra_ehci_map_urb_for_dma,
> +	.unmap_urb_for_dma	= tegra_ehci_unmap_urb_for_dma,
> +	.hub_control		= tegra_ehci_hub_control,
> +	.urb_enqueue		= tegra_ehci_urb_enqueue,

Same here.

>  #ifdef CONFIG_PM
>  	.bus_suspend		= tegra_ehci_bus_suspend,
>  	.bus_resume		= tegra_ehci_bus_resume,
>  #endif
> -	.relinquish_port	= ehci_relinquish_port,
> -	.port_handed_over	= ehci_port_handed_over,
>  };

Alan Stern

