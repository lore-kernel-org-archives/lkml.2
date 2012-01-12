Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2ALP4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:56:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45505 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753872Ab2ALP4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:56:02 -0500
Date: Thu, 12 Jan 2012 10:56:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] USB: EHCI: Don't use NO_IRQ in xilinx ehci driver
In-Reply-To: <1326356777-24135-1-git-send-email-monstr@monstr.eu>
Message-ID: <Pine.LNX.4.44L0.1201121055370.1384-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012, Michal Simek wrote:

> Drivers shouldn't use NO_IRQ. This driver is used
> by Microblaze and PPC. PPC defines NO_IRQ as 0
> and Microblaze has removed it.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Alan Stern <stern@rowland.harvard.edu>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: linux-usb@vger.kernel.org
> CC: devicetree-discuss@lists.ozlabs.org
> ---
>  drivers/usb/host/ehci-xilinx-of.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> index 32793ce..9c2cc46 100644
> --- a/drivers/usb/host/ehci-xilinx-of.c
> +++ b/drivers/usb/host/ehci-xilinx-of.c
> @@ -183,7 +183,7 @@ static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
>  	}
>  
>  	irq = irq_of_parse_and_map(dn, 0);
> -	if (irq == NO_IRQ) {
> +	if (!irq) {
>  		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
>  		rv = -EBUSY;
>  		goto err_irq;

Acked-by: Alan Stern <stern@rowland.harvard.edu>

