Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab2IROdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:33:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35870 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758115Ab2IROdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:33:49 -0400
Date: Tue, 18 Sep 2012 10:33:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jim Lin <jilin@nvidia.com>
cc: gregkh@linuxfoundation.org, <swarren@wwwdotorg.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] USB: EHCI: Tegra: Fix wrong register definition
In-Reply-To: <1347957737-14191-1-git-send-email-jilin@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1209181024430.2000-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Jim Lin wrote:

> Fix the issue that EHCI registers, hostpc[0] and usbmode_ex,
> are not correctly accessed on Tegra3 platform.
> 
> Signed-off-by: Jim Lin <jilin@nvidia.com>
> ---
>  include/linux/usb/ehci_def.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
> index de4b9ed..134bb4a 100644
> --- a/include/linux/usb/ehci_def.h
> +++ b/include/linux/usb/ehci_def.h
> @@ -171,18 +171,18 @@ struct ehci_regs {
>  #define USBMODE_CM_HC	(3<<0)		/* host controller mode */
>  #define USBMODE_CM_IDLE	(0<<0)		/* idle state */
>  
> -	u32		reserved4[7];
> +	u32		reserved4[6];
>  
>  /* Moorestown has some non-standard registers, partially due to the fact that
>   * its EHCI controller has both TT and LPM support. HOSTPCx are extensions to
>   * PORTSCx
>   */
>  	/* HOSTPC: offset 0x84 */
> -	u32		hostpc[0];	/* HOSTPC extension */
> +	u32		hostpc[1];	/* HOSTPC extension */
>  #define HOSTPC_PHCD	(1<<22)		/* Phy clock disable */
>  #define HOSTPC_PSPD	(3<<25)		/* Port speed detection */
>  
> -	u32		reserved5[17];
> +	u32		reserved5[16];
>  
>  	/* USBMODE_EX: offset 0xc8 */
>  	u32		usbmode_ex;	/* USB Device mode extension */

I was _certain_ this had been done correctly.  Oh well, it just goes to 
show you can't be too careful.  Thanks for fixing the mistake in 
reserved4.

By the way, it is certain that the HOSTPC register will never be used 
on controllers having more than one port?  If that's not certain, you 
should leave the array size of hostpc set to 0.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

