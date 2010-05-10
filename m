Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0EJFI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:08:29 -0400
Received: from leo.clearchain.com ([199.73.29.74]:52446 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0EJFIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:08:25 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 01:08:25 EDT
Date: Mon, 10 May 2010 14:50:22 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for eGalax Touchcontroller
Message-ID: <20100510045022.GA31327@barra.bne.redhat.com>
References: <20100202034040.GA16880@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202034040.GA16880@barra.bne.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Mon, 10 May 2010 14:23:17 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Feb 02, 2010 at 01:40:40PM +1000, Peter Hutterer wrote:
> Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
> ---
> I've got one of these devices on my desk and it seems that it suffers from
> the ABS_Z/ABS_RX issue that we've seen in other devices before. This patch
> uses the same reasoning as 9db630b48a99adb4156e205b812fba8959644280.
> 
> Nonetheless, I'm not sure about whether that's the right thing to do. With
> this patch applied, it gives me two devices, one mute, the other one
> announces BTN_PEN and BTN_TOUCH + abs axes, though only BTN_TOUCH is ever
> triggered. Loading usbtouchscreen instead of usbhid for this device makes
> the device look more sane BTN_TOUCH + abs axes but the actual data is
> random. So I'm not quite sure what the fix is supposed to be, any hints are
> appreciated if it's not the patch below.

See https://patchwork.kernel.org/patch/76210/ for the original thread.
This patch never got merged, were you waiting on me or did it just drop
under the table?

I'm getting positive reports from users that this indeed fixes the issues
for their device.
https://bugzilla.redhat.com/show_bug.cgi?id=473144

Cheers,
  Peter

>  drivers/hid/hid-ids.h           |    3 +++
>  drivers/hid/usbhid/hid-quirks.c |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index f5144b8..2e698a2 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -158,6 +158,9 @@
>  
>  #define USB_VENDOR_ID_DRAGONRISE	0x0079
>  
> +#define USB_VENDOR_ID_EGALAX		0x0EEF
> +#define USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER	0x0001
> +
>  #define USB_VENDOR_ID_ELO		0x04E7
>  #define USB_DEVICE_ID_ELO_TS2700	0x0020
>  
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index e987562..dc27d74 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -32,6 +32,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_PREDATOR, HID_QUIRK_BADPAD },
>  	{ USB_VENDOR_ID_ALPS, USB_DEVICE_ID_IBM_GAMEPAD, HID_QUIRK_BADPAD },
>  	{ USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD, HID_QUIRK_BADPAD },
> +	{ USB_VENDOR_ID_EGALAX, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
> -- 
> 1.6.5.2

