Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1GRQoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:44:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:53834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1GRQoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,223,1309762800"; 
   d="scan'208";a="29006896"
Date: Mon, 18 Jul 2011 09:44:10 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: xhci: fix OS want to own HC
Message-ID: <20110718164410.GA4879@xanatos>
References: <20110716110419.726be2b0@ustc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716110419.726be2b0@ustc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 11:04:19AM +0800, JiSheng Zhang wrote:
> Software should set XHCI_HC_OS_OWNED bit to request ownership of xHC

Good catch!  I'll queue this up to my for-usb-linus branch and send it
out to Greg later today.

Greg, do you think it's too late to get this into 3.0?  Shall I just
add it to usb-next and mark it for stable?

Sarah Sharp

> Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
> ---
>  drivers/usb/host/pci-quirks.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index fd93061..1a73004 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -775,7 +775,7 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
>  
>  	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
>  	if (val & XHCI_HC_BIOS_OWNED) {
> -		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
> +		writel(val | XHCI_HC_OS_OWNED, base + ext_cap_offset);
>  
>  		/* Wait for 5 seconds with 10 microsecond polling interval */
>  		timeout = handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,
> -- 
> 1.7.5.4
> 
