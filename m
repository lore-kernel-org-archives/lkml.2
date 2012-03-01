Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2CAULz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:11:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:39317 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab2CAULx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:11:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113583069"
Date: Thu, 1 Mar 2012 12:10:50 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] usb, PCI: remove disable/enable device with
 non-xhci quirk
Message-ID: <20120301201050.GC5155@xanatos>
References: <1330629843-6027-1-git-send-email-yinghai@kernel.org>
 <1330629843-6027-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330629843-6027-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 11:24:02AM -0800, Yinghai Lu wrote:
> | commit cab928ee1f221c9cc48d6615070fefe2e444384a
> |    USB: Fix handoff when BIOS disables host PCI device.
> 
> mention only need to do disable/enable for xhci controller.
> 
> So just remove that for non-xhci controller and restore old behavior for them.

As I said, we do need to do the enable/disable for all USB hosts.  Jesse
Barnes confirms that the PCI core doesn't do that for us, so we can't
rely on the BIOS always enabling the PCI device.  I don't think we need
this patch, because we should always be doing the enable/disable for all
USB hosts.  We just never had a BIOS that caused this bug to be
discovered until the xHCI BIOS for the Intel system in question.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/usb/host/pci-quirks.c |   18 ------------------
>  1 file changed, 18 deletions(-)
> 
> Index: linux-2.6/drivers/usb/host/pci-quirks.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/host/pci-quirks.c
> +++ linux-2.6/drivers/usb/host/pci-quirks.c
> @@ -889,13 +889,7 @@ static void __devinit quirk_usb_early_ha
>  	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
>  		return;
>  
> -	if (pci_enable_device(pdev) < 0) {
> -		dev_warn(&pdev->dev, "Can't enable PCI device, "
> -				"BIOS handoff failed.\n");
> -		return;
> -	}
>  	quirk_usb_handoff_uhci(pdev);
> -	pci_disable_device(pdev);
>  }
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
>  		PCI_CLASS_SERIAL_USB_UHCI, 0, quirk_usb_early_handoff_uhci);
> @@ -908,13 +902,7 @@ static void __devinit quirk_usb_early_ha
>  	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
>  		return;
>  
> -	if (pci_enable_device(pdev) < 0) {
> -		dev_warn(&pdev->dev, "Can't enable PCI device, "
> -				"BIOS handoff failed.\n");
> -		return;
> -	}
>  	quirk_usb_handoff_ohci(pdev);
> -	pci_disable_device(pdev);
>  }
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
>  		PCI_CLASS_SERIAL_USB_OHCI, 0, quirk_usb_early_handoff_ohci);
> @@ -924,13 +912,7 @@ static void __devinit quirk_usb_early_ha
>  	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
>  		return;
>  
> -	if (pci_enable_device(pdev) < 0) {
> -		dev_warn(&pdev->dev, "Can't enable PCI device, "
> -				"BIOS handoff failed.\n");
> -		return;
> -	}
>  	quirk_usb_handoff_ehci(pdev);
> -	pci_disable_device(pdev);
>  }
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
>  		PCI_CLASS_SERIAL_USB_EHCI, 0, quirk_usb_early_handoff_ehci);
