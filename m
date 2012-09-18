Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2IRQhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:37:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43130 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab2IRQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:37:34 -0400
X-Sasl-enc: ToLvRtzTmrqN5mXhaKxTlM4OOaKvKB5N2r+EP4S2SfiQ 1347986254
Date: Tue, 18 Sep 2012 17:37:32 +0100
From: Greg KH <greg@kroah.com>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB: ezusb: move ezusb.c from drivers/usb/serial to
 drivers/usb/misc
Message-ID: <20120918163732.GA28387@kroah.com>
References: <bb6a1493-77bc-4d4e-ac2a-92cd8dc2f156@shmail0>
 <0db0a2e2-0a19-42c2-a933-b250125e8425@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0db0a2e2-0a19-42c2-a933-b250125e8425@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 09:03:01AM +0200, Rene Buergel wrote:
> This patch moves drivers/usb/serial/ezusb.c to drivers/usb/misc/and
> adapts Makefiles and Kconfigs
> 
> Signed-off-by: René Bürgel <rene.buergel@sohard.de>
> ---
> diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
> index 1bfcd02..1c63b54 100644
> --- a/drivers/usb/misc/Kconfig
> +++ b/drivers/usb/misc/Kconfig
> @@ -244,3 +244,7 @@ config USB_YUREX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called yurex.
>  
> +config USB_EZUSB
> +	bool "Functions for loading firmware on EZUSB chips"

This should be a tristate so the ezusb code can be a module on it's own.

Or I think it should, as it is, I get the following build errors with
this patch applied:

ERROR: "ezusb_fx1_ihex_firmware_download" [drivers/usb/serial/whiteheat.ko] undefined!
ERROR: "ezusb_fx1_ihex_firmware_download" [drivers/usb/serial/keyspan_pda.ko] undefined!
ERROR: "ezusb_fx1_set_reset" [drivers/usb/serial/keyspan_pda.ko] undefined!
ERROR: "ezusb_fx1_ihex_firmware_download" [drivers/usb/serial/keyspan.ko] undefined!

Which is odd, as I thought those functions were exported.

So something is wrong here with this patch, I've applied the first 2, care to
redo this one so it works properly?

thanks,

greg k-h
