Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2GWOqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:46:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35088 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2GWOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:46:43 -0400
Message-ID: <500D6375.1070102@mvista.com>
Date: Mon, 23 Jul 2012 18:45:09 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Denis Turischev <denis@compulab.co.il>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] xhci: provide usb_disable_xhci_ports function for
 Intel chipsets.
References: <5004454E.9030903@compulab.co.il> <20120717045416.GJ7599@xanatos> <50065E5A.2040103@compulab.co.il> <20120718165916.GA30828@xanatos> <500D398E.1060000@compulab.co.il>
In-Reply-To: <500D398E.1060000@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/23/2012 03:46 PM, Denis Turischev wrote:

> Some devices with Intel Panther Point chipset may require switchover
> usb ports from XHCI back to EHCI controller before shutdown.
> Overwise various BIOS bugs related to power management may be
> triggered.

> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/usb/host/pci-quirks.c |   14 ++++++++++++++
>  drivers/usb/host/pci-quirks.h |    1 +
>  2 files changed, 15 insertions(+)

> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index df0828c..b19a84a 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -800,6 +800,20 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>  }
>  EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);
> 
> +void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
> +{
> +	u32		ports_available;
> +
> +	ports_available = 0x0;

   Why not make it an initializer? And why do you need the variable at all?

> +
> +	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN,
> +			cpu_to_le32(ports_available));

   cpu_to_le32() not needed.

> +
> +	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
> +			cpu_to_le32(ports_available));
> +}
> +EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
> +
>  /**
>   * PCI Quirks for xHCI.
>   *

WBR, Sergei

