Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab2IROgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:36:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48428 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933176Ab2IROgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:36:37 -0400
X-Sasl-enc: ZaNaFmSB9wisEU1IYM51odUoD+wwn0xuOW1VLOAk3IX/ 1347978996
Date: Tue, 18 Sep 2012 15:36:35 +0100
From: Greg KH <greg@kroah.com>
To: "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: XHCI Bug discovered in 3.6-RC6 (solution included)
Message-ID: <20120918143635.GF15432@kroah.com>
References: <5057C55D.2060402@dd-wrt.com>
 <5057C5AD.80609@dd-wrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5057C5AD.80609@dd-wrt.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 02:51:57AM +0200, Sebastian Gottschall (DD-WRT) wrote:
> this following function is missing a important NULL check. if DMI is
> not available or not enabled in the kernel config (which is common
> in my case, since its a ARM Platform with XHCI support)
> the xhci-hcd driver will crash due nullpointer access since
> dmi_get_system_info returns always NULL if DMI support is not
> enabled.
> 
> static bool compliance_mode_recovery_timer_quirk_check(void)
> {
>     const char *dmi_product_name, *dmi_sys_vendor;
> 
>     dmi_product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
>     dmi_sys_vendor = dmi_get_system_info(DMI_SYS_VENDOR);
> 
>     if (!(strstr(dmi_sys_vendor, "Hewlett-Packard")))
>         return false;
> 
>     if (strstr(dmi_product_name, "Z420") ||
>             strstr(dmi_product_name, "Z620") ||
>             strstr(dmi_product_name, "Z820"))
>         return true;
> 
>     return false;
> }
> 
> proposed patch: simply add
> 
>  if (!dmi_sys_vendor || !dmi_product_name)
>         return false;
> 
> even better. disable the whole quirk handling for this case if
> CONFIG_DMI is not set

Care to send a patch to fix this up?

thanks,

greg k-h
