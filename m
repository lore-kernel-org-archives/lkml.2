Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0EQIda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:33:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:50946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0EQId2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:33:28 -0400
Date: Mon, 17 May 2010 10:33:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Don Prince <dhprince.devel@yahoo.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc7 v3] HID: hid-samsung: add support for Creative
 Desktop Wireless 6000
In-Reply-To: <4BF0531C.40307@yahoo.co.uk>
Message-ID: <alpine.LNX.2.00.1005171031440.28092@pobox.suse.cz>
References: <4BF0531C.40307@yahoo.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010, Don Prince wrote:

> diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> --- a/drivers/hid/hid-core.c	2010-05-15 15:38:23.938711974 +0100
> +++ b/drivers/hid/hid-core.c	2010-05-15 20:43:36.363484676 +0100
> @@ -1343,6 +1343,7 @@ static const struct hid_device_id hid_bl
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },

On my side it seems that your mailer whitespace-damaged the patch somehow. 
Could you please either try to fix up your mailer, or attach the patch as 
an attachment if it doesn't work inline?

> +#define samsung_kbd_mouse_map_key_clear(c) \
> +	hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
> +
> +static int samsung_kbd_mouse_input_mapping(struct hid_device *hdev,
> +	struct hid_input *hi, struct hid_field *field, struct hid_usage *usage,
> +	unsigned long **bit, int *max)
> +{
> +	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
> +	unsigned short ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
> +
> +	if (1 != ifnum || HID_UP_CONSUMER != (usage->hid & HID_USAGE_PAGE))
> +		return 0;
> +
> +	dbg_hid("samsung wireless keyboard/mouse input mapping event [0x%x]\n",
> +		usage->hid & HID_USAGE);
> +
> +	switch (usage->hid & HID_USAGE) {
> +	/* report 2 */
> +	case 0x0b5:
> +		samsung_kbd_mouse_map_key_clear(KEY_NEXTSONG);
> +		break;
> +	case 0x0b6:
> +		samsung_kbd_mouse_map_key_clear(KEY_PREVIOUSSONG);
> +		break;
> +	case 0x0b7:
> +		samsung_kbd_mouse_map_key_clear(KEY_STOPCD);
> +		break;
> +	case 0x0cd:
> +		samsung_kbd_mouse_map_key_clear(KEY_PLAYPAUSE);
> +		break;

Could you please use more compact code look for the mappings (i.e. one 
line per mapping), as done in other drivers and in hid-input itself, so 
that it's consistent?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
