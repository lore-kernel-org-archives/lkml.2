Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2IQLEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:04:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab2IQLEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:04:34 -0400
Date: Mon, 17 Sep 2012 13:04:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] HID: roccat: removing devices from blacklist
In-Reply-To: <1347863645.2606.66.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1209171303390.31149@pobox.suse.cz>
References: <1347863645.2606.66.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Stefan Achatz wrote:

> I would suggest to remove the Roccat devices from generic drivers blacklist.
> 
> Some Distros tend to have kernels without the special modules compiled, which
> prevents users of these devices to work with live images or installers.
> 
> The Roccat devices work flawlessly with generic drivers (except the old Kone with a
> small glitch). My modules are only needed when using my tools for configuration
> and extended capabilities. These tools come with udev rules which transfer
> the control from generic driver to externally compiled modules if installed.
> 
> I have to update these udev rules for the change from generic-usb to hid-generic
> anyway, so I would add a rule to also handle the kernel contained modules.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-core.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8bcd168..4f2ba5a 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1627,14 +1627,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_KEYBOARD) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_SAVU) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },

Actually what I am planning to do (hopefully for 3.7) is to put an #ifdef 
around those entries which can function also with the generic driver (only 
with missing features). We are already doing this for logitech and tpkbd.

Could you please rather take this aproach and resubmit the patch?

Thanks,

-- 
Jiri Kosina
SUSE Labs
