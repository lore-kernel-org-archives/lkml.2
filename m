Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383Ab0J2OBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:01:12 -0400
Received: from ns1.dataart.com ([195.206.224.40]:49209 "EHLO
	relay1.dataart.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932586Ab0J2OBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:01:10 -0400
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 10:01:10 EDT
From: Anton Chikin <Anton.Chikin@dataart.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "chatty@enac.fr" <chatty@enac.fr>, "spbnick@gmail.com" <spbnick@gmail.com>,
        "anisse@astier.eu" <anisse@astier.eu>,
        "cascardo@holoscopio.com" <cascardo@holoscopio.com>,
        "don@syst.com.br" <don@syst.com.br>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Gregory Burmistrov <grig@dataart.com>,
        Paul Osborn <Paul.Osborn@eu.panasonic.com>
Date: Fri, 29 Oct 2010 17:42:42 +0400
Subject: RE: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite
 Panaboard T-780 and T-880
Thread-Topic: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite
 Panaboard T-780 and T-880
Thread-Index: Act3bPryL0+bqdGLRTSZ0u93gZyQawAAL9Ig
Message-ID: <3BF066A8BAB61C43B779966CEE6D7FA018BC9E19F2@e6.universe.dart.spb>
References: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com>
 <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz>
Accept-Language: ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

Panasonic Elite Panaboard UB-T780 is a touchscreen whiteboard. It uses projector to present PC's screen onto the board. So we need to calibrate it according to the projector's position and apply calibration data inside our driver.

There is no other driver for this device. I'm working directly for Panasonic on this driver.

Is this nice for changelog comment?

With best regards,
Anton Chikin

-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Friday, October 29, 2010 4:55 PM
To: Anton Chikin
Cc: chatty@enac.fr; spbnick@gmail.com; anisse@astier.eu; cascardo@holoscopio.com; don@syst.com.br; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Gregory Burmistrov; Anton Chikin; Anton Chikin
Subject: Re: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite Panaboard T-780 and T-880

On Wed, 27 Oct 2010, Anton Chikin wrote:

> Added Panasonic vendor ID, two device IDs for Panasonic Whiteboard devices and new quirk to ignore
> these devices in hid-core driver.

Could you please be more verbose in the changelog?

Is the generic HID driver not working with these devices at all? Or is the 
functionality only limited, not exploiting all the features the hardware 
provides?

Is there any other driver available for these devices?

Thanks.

> 
> Signed-off-by: Anton Chikin <anton.chikin@dataart.com>
> ---
>  drivers/hid/hid-ids.h           |    4 ++++
>  drivers/hid/usbhid/hid-quirks.c |    2 ++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 3341baa..b5542d3 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -446,6 +446,10 @@
>  #define USB_VENDOR_ID_ORTEK		0x05a4
>  #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
>  
> +#define USB_VENDOR_ID_PANASONIC 	0x04da
> +#define USB_DEVICE_ID_PANASONIC_PANABOARD_T780 	0x1044
> +#define USB_DEVICE_ID_PANASONIC_PANABOARD_T880	0x104d 
> +
>  #define USB_VENDOR_ID_PANJIT		0x134c
>  
>  #define USB_VENDOR_ID_PANTHERLORD	0x0810
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 2c18547..b5788b0 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -65,6 +65,8 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
> +	{ USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T780, HID_QUIRK_IGNORE },
> +	{ USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T880, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
> -- 
> 1.7.0.4
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
