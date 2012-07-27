Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2G0GOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:14:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:29825 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab2G0GOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="178179653"
Date: Thu, 26 Jul 2012 23:14:30 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Add Etron XHCI quirk to avoid warning spam
Message-ID: <20120727061430.GC11608@xanatos>
References: <1343361824-11417-1-git-send-email-daniel@quora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343361824-11417-1-git-send-email-daniel@quora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

I already have a patch in my queue for this.  However, it keys off the
PCI_DEVICE_ID_ASROCK_P67 PCI device ID.  Do you have another Etron
device with a different device ID that needs this quirk?

Sarah Sharp

On Fri, Jul 27, 2012 at 12:03:44PM +0800, Daniel J Blueman wrote:
> When various USB3 devices with Etron XHCI controllers, we see a bunch of
> warnings:
> xhci_hcd 0000:02:00.0: WARN Successful completion on short TX: needs
> XHCI_TRUST_TX_LENGTH quirk?
> 
> Acknowledge the issue by adding the quirk.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---
>  drivers/usb/host/xhci-pci.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 18b231b..715ad11 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -95,10 +95,13 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
>  		xhci->limit_active_eps = 64;
>  		xhci->quirks |= XHCI_SW_BW_CHECKING;
>  	}
> -	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
> -			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
> -		xhci->quirks |= XHCI_RESET_ON_RESUME;
> -		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
> +	if (pdev->vendor == PCI_VENDOR_ID_ETRON) {
> +		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
> +
> +		if (pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
> +			xhci->quirks |= XHCI_RESET_ON_RESUME;
> +			xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
> +		}
>  	}
>  	if (pdev->vendor == PCI_VENDOR_ID_VIA)
>  		xhci->quirks |= XHCI_RESET_ON_RESUME;
> -- 
> 1.7.9.5
> 
