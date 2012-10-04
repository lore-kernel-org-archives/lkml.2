Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2JDS6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:58:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45970 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752933Ab2JDS6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:58:10 -0400
Date: Thu, 4 Oct 2012 14:58:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/24 v2] USB: EHCI: add no_io_watchdog platform_data
 parameter to ehci-platform
In-Reply-To: <1349363872-27004-7-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210041456310.1441-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Florian Fainelli wrote:

> Enhance the ehci-platform driver to also accept no_io_watchdog as a platform
> data parameter. When no_io_watchdog is set to 1, the ehci controller will set
> ehci->need_io_watchdog to 0. Since most EHCI controllers do need the I/O
> watchdog to be on, only let those which need it to turn the watchdog off.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> Changes since v1:
> - reworked patch to introduce "no_io_watchdog" instead of "need_io_watchdog"
> - reworded commit message accordingly

Very good except for one thing...

> --- a/drivers/usb/host/ehci-platform.c
> +++ b/drivers/usb/host/ehci-platform.c
> @@ -32,6 +32,8 @@ static int ehci_platform_reset(struct usb_hcd *hcd)
>  	ehci->has_synopsys_hc_bug = pdata->has_synopsys_hc_bug;
>  	ehci->big_endian_desc = pdata->big_endian_desc;
>  	ehci->big_endian_mmio = pdata->big_endian_mmio;
> +	if (pdata->no_io_watchdog)
> +		ehci->need_io_watchdog = 0;
>  
>  	ehci->caps = hcd->regs + pdata->caps_offset;
>  	retval = ehci_setup(hcd);

ehci_setup calls ehci_init, which unconditionally sets 
need_io_watchdog.  Your new "if" statement has to come after this call.

Alan Stern

