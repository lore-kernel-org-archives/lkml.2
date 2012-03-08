Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2CHWWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:22:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34180 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab2CHWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:39 -0500
Date: Thu, 8 Mar 2012 14:22:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH v4] USB: Support for LPC32xx SoC
Message-ID: <20120308222234.GA25576@kroah.com>
References: <1331244574-32570-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331244574-32570-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 11:09:34PM +0100, Roland Stigge wrote:
> This patch adds OHCI support to the LPC32xx ARM platform
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
>  Applies to v3.3-rc6
> 
>  Since v3, only the machine_is_*() dependencies have been pulled into
>  the machine dependent functions.

Better, but:

>  static void pnx4008_unset_usb_bits(void)
>  {
> -	start_int_mask(SE_USB_OTG_ATX_INT_N);
> -	start_int_mask(SE_USB_OTG_TIMER_INT);
> -	start_int_mask(SE_USB_I2C_INT);
> -	start_int_mask(SE_USB_INT);
> -	start_int_mask(SE_USB_NEED_CLK_INT);
> -	start_int_mask(SE_USB_AHB_NEED_CLK_INT);
> +	if (machine_is_pnx4008()) {

The function is called "pnx4008...", so why would any code path that is
not this hardware call this?

I think there's a disconnect between what you think a pnx4008 machine
is, and what I think it is, or what this code is running on and thinks
it is.

So, should this function just be called something else, for the type of
hardware (lpc32xx?), and then do this check within the function?

Again, consistancy is key.  Note how not all of the pnc4008_*()
functions make this check, which implies that something is not
consistant here...

thanks,

greg k-h
