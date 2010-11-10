Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0KJCg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:36:59 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43269 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751386Ab0KJCg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:36:58 -0500
Date: Tue, 9 Nov 2010 21:36:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dirk Brandewie <dirk.brandewie@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 6/6] ce4100: Add support for CE4100 EHCI IP block to EHCI
 driver
In-Reply-To: <4CD9C4A7.3060603@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011092134180.14099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Dirk Brandewie wrote:

> In a previous patch in this series GregKH asked that the PCI ID not be added 
> to pci_ids.h for ID's that are only used by a single file.  
> Here is an updated version of the EHCI controller patch.
> 
> Subject: [PATCH] ce4100: Add support for CE4100 EHCI IP block to EHCI driver
> 
> This patch adds support for the EHCI IP block present on the Intel
> CE4100.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> CC: linux-usb@vger.kernel.org
> CC: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/usb/host/ehci-pci.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index a1e8d27..da2b196 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -124,6 +124,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
>  			ehci_info(ehci, "disable lpm for langwell/penwell\n");
>  			ehci->has_lpm = 0;
>  		}
> +		if (pdev->device == 0x2e70) {
> +			hcd->has_tt = 1;
> +			tdi_reset(ehci);
> +		}

I think Greg meant that it's okay to use a symbolic constant for the
PCI ID (it helps tell people what hardware is being handled).  Just
don't add that constant to the pci_ids.h file.

Alan Stern

