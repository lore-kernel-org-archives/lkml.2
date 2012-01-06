Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2AFQfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:35:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48388 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750937Ab2AFQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:35:13 -0500
Date: Fri, 6 Jan 2012 11:35:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alessandro Rubini <rubini@gnudd.com>
cc: linux-kernel@vger.kernel.org, <giancarlo.asnaghi@st.com>,
        <alan@linux.intel.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>, <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 5/6] usb: add support for STA2X11 host driver
In-Reply-To: <2902d4c3eb2e04ca0444393c67e639b4a98eb9e8.1325852059.git.rubini@gnudd.com>
Message-ID: <Pine.LNX.4.44L0.1201061132170.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012, Alessandro Rubini wrote:

> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/usb/host/ehci-pci.c |    6 ++++++
>  drivers/usb/host/ohci-pci.c |    4 ++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index f4b627d..01bb7241d 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -276,6 +276,9 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
>  
>  	/* Serial Bus Release Number is at PCI 0x60 offset */
>  	pci_read_config_byte(pdev, 0x60, &ehci->sbrn);
> +	if (pdev->vendor == PCI_VENDOR_ID_STMICRO
> +	    && pdev->device == PCI_DEVICE_ID_STMICRO_USB_HOST)
> +		ehci->sbrn = 0x20; /* ConneXT has no sbrn register */
>  
>  	/* Keep this around for a while just in case some EHCI
>  	 * implementation uses legacy PCI PM support.  This test
> @@ -526,6 +529,9 @@ static const struct pci_device_id pci_ids [] = { {
>  	/* handle any USB 2.0 EHCI controller */
>  	PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_EHCI, ~0),
>  	.driver_data =	(unsigned long) &ehci_pci_hc_driver,
> +	}, {
> +	PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_USB_HOST),
> +	.driver_data = (unsigned long) &ehci_pci_hc_driver,
>  	},
>  	{ /* end: all zeroes */ }
>  };
> diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
> index 6109810..1843bb6 100644
> --- a/drivers/usb/host/ohci-pci.c
> +++ b/drivers/usb/host/ohci-pci.c
> @@ -397,6 +397,10 @@ static const struct pci_device_id pci_ids [] = { {
>  	/* handle any USB OHCI controller */
>  	PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_OHCI, ~0),
>  	.driver_data =	(unsigned long) &ohci_pci_hc_driver,
> +	}, {
> +	/* The device in the ConneXT I/O hub has no class reg */
> +	PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_USB_OHCI),
> +	.driver_data =	(unsigned long) &ohci_pci_hc_driver,
>  	}, { /* end: all zeroes */ }
>  };
>  MODULE_DEVICE_TABLE (pci, pci_ids);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Why doesn't the ConneXT implement the required PCI registers?

Alan Stern

