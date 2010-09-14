Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0INJLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:11:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:53773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0INJK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:10:57 -0400
Date: Tue, 14 Sep 2010 11:10:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bradley Chen <bradley7213@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hid: prevent ILITEK multi-touch devices from being
 handled by usbhid
In-Reply-To: <AANLkTimFwHASfChvQUPzjQKu-sstrAYTtgXvxA3mdJu9@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009141109280.26813@pobox.suse.cz>
References: <AANLkTimFwHASfChvQUPzjQKu-sstrAYTtgXvxA3mdJu9@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010, Bradley Chen wrote:

> From: Bradley Chen <bradley_chen@ilitek.com>
> 
> The ILITEK multi-touch devices are incorrectly handled by the generic 
> USB driver(usbhid). This patch puts the IDs of ILITEK and its 
> multi-touch devices into hid_blacklist in order to have the products be 
> handled by specific drivers.
> 
> Signed-off-by: Bradley Chen <bradley_chen@ilitek.com>
> ---
> diff -uprN -X linux-2.6.35.4-vanilla/Documentation/dontdiff linux-2.6.35.4-vanilla/drivers/hid/hid-core.c linux-2.6.35.4/drivers/hid
> /hid-core.c
> --- linux-2.6.35.4-vanilla/drivers/hid/hid-core.c	2010-09-11 16:12:25.295859677 +0800
> +++ linux-2.6.35.4/drivers/hid/hid-core.c	2010-08-27 07:47:12.000000000 +0800
> @@ -1302,7 +1302,6 @@ static const struct hid_device_id hid_bl
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_ILITEK, USB_DEVICE_ID_ILITEK_MT2101) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
> diff -uprN -X linux-2.6.35.4-vanilla/Documentation/dontdiff linux-2.6.35.4-vanilla/drivers/hid/hid-ids.h linux-2.6.35.4/drivers/hid/
> hid-ids.h
> --- linux-2.6.35.4-vanilla/drivers/hid/hid-ids.h	2010-09-11 16:10:37.704360067 +0800
> +++ linux-2.6.35.4/drivers/hid/hid-ids.h	2010-08-27 07:47:12.000000000 +0800
> @@ -290,9 +290,6 @@
>  #define USB_DEVICE_ID_UGCI_FLYING	0x0020
>  #define USB_DEVICE_ID_UGCI_FIGHTING	0x0030
>  
> -#define USB_VENDOR_ID_ILITEK		0x222a
> -#define USB_DEVICE_ID_ILITEK_MT2101 	0x0001
> -
>  #define USB_VENDOR_ID_IMATION		0x0718
>  #define USB_DEVICE_ID_DISC_STAKKA	0xd000

Hi Bradley,

first, it seems that the patch is actually doing quite the reverse of what 
you wanted to do, right? (it's removing lines that have never been in 
kernel).

Second, what are the specific drivers? Are they going to be posted for 
upstream kernel inclusion?
How does the device behave with USB HID driver? It doesn't work at all, or 
it's just that it only providing basic HID capabilities without any 
vendor-specific extensions?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
