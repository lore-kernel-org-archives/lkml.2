Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224Ab2HHPex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:34:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52559 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964822Ab2HHPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:34:49 -0400
Date: Wed, 8 Aug 2012 11:34:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, <arm@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/11] usb/ohci-omap: remove unused variable
In-Reply-To: <1344437248-20560-4-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1208081134350.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Arnd Bergmann wrote:

> Commit c2e935a7d "USB: move transceiver from ehci_hcd and ohci_hcd to
> hcd and rename it as phy" removed the last use of the "ohci" variable
> in the usb_hcd_omap_remove function, but left the variable in place
> unused.
> 
> Without this patch, building omap1_defconfig results in:
> 
> In file included from drivers/usb/host/ohci-hcd.c:1013:0:
> drivers/usb/host/ohci-omap.c: In function 'usb_hcd_omap_remove':
> drivers/usb/host/ohci-omap.c:406:19: warning: unused variable 'ohci' [-Wunused-variable]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Richard Zhao <richard.zhao@freescale.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/host/ohci-omap.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
> index e7d75d2..f8b2d91 100644
> --- a/drivers/usb/host/ohci-omap.c
> +++ b/drivers/usb/host/ohci-omap.c
> @@ -403,8 +403,6 @@ err0:
>  static inline void
>  usb_hcd_omap_remove (struct usb_hcd *hcd, struct platform_device *pdev)
>  {
> -	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
> -
>  	usb_remove_hcd(hcd);
>  	if (!IS_ERR_OR_NULL(hcd->phy)) {
>  		(void) otg_set_host(hcd->phy->otg, 0);
> 

Acked-by: Alan Stern <stern@rowland.harvard.edu>

