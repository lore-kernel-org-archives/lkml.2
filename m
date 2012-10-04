Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2JDTHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:07:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45979 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752113Ab2JDTHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:07:45 -0400
Date: Thu, 4 Oct 2012 15:07:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/24] USB: ohci: move ohci_pci_{suspend,resume} to
 ohci-hcd.c
In-Reply-To: <1349363872-27004-13-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210041505090.1441-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Florian Fainelli wrote:

> As suggested by Alan Stern, move the ohci-pci.c ohci_pci_{suspend,resume}
> routines to ohci-hcd.c. Due to their move, also rename them to
> ohci_{suspend,resume} to make it clear they operate on ohci_hcd. Since they
> are not necessarily called, annotate them with __maybe_unused.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  drivers/usb/host/ohci-hcd.c |   39 +++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/ohci-pci.c |   43 ++-----------------------------------------
>  2 files changed, 41 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> index 2b1e8d8..0cba8d6 100644
> --- a/drivers/usb/host/ohci-hcd.c
> +++ b/drivers/usb/host/ohci-hcd.c
> @@ -981,6 +981,45 @@ static int ohci_restart (struct ohci_hcd *ohci)
>  	return 0;
>  }
>  
> +static int __maybe_unused ohci_suspend(struct usb_hcd *hcd, bool do_wakeup)
> +{

...

> +	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
> +}
> +
>  #endif

How about putting these new routines _after_ this #endif?

> --- a/drivers/usb/host/ohci-pci.c
> +++ b/drivers/usb/host/ohci-pci.c
> @@ -298,45 +298,6 @@ static int __devinit ohci_pci_start (struct usb_hcd *hcd)
>  
>  #ifdef	CONFIG_PM
>  
> -static int ohci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
> -{

...

> -}
> -
>  #endif	/* CONFIG_PM */

And then moving these #ifdef and #endif lines along with them?

The point is that one condition is

	#if defined(CONFIG_PM) || defined(CONFIG_PCI)

whereas the other is just

	#ifdef CONFIG_PM

so they aren't really the same.

Alan Stern

