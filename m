Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0IMLXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:23:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:34327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab0IMLXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:23:52 -0400
Date: Mon, 13 Sep 2010 13:23:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Lech Perczak <lech.perczak@multivision.pl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1] hid: Fix for A4Tech RP-649 horizontal scrollwheel
In-Reply-To: <4C891E9F.3040006@multivision.pl>
Message-ID: <alpine.LNX.2.00.1009131323040.26813@pobox.suse.cz>
References: <4C891E9F.3040006@multivision.pl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Lech Perczak wrote:

>  From: Lech Perczak <lech.perczak@multivision.pl>
> 
> - Barely add USB device ID of A4Tech RF mouse receiver (09da:001a) used with
> RP-649(Z) mice to enable fix for their horizontal scroll wheel behaviour, and
> associate it with B8 hack.
> 
> Signed-off-by: Lech Perczak<lech.perczak@multivision.pl>
> ---
> diff -up hid/hid-a4tech.c.orig hid/hid-a4tech.c
> --- hid/hid-a4tech.c.orig	2010-08-02 00:11:14.000000000 +0200
> +++ hid/hid-a4tech.c	2010-09-09 17:51:23.000000000 +0200
> @@ -133,6 +133,8 @@
>  		.driver_data = A4_2WHEEL_MOUSE_HACK_7 },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D),
>  		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649),
> +		.driver_data = A4_2WHEEL_MOUSE_HACK_B8 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(hid, a4_devices);
> diff -up hid/hid-ids.h.orig hid/hid-ids.h
> --- hid/hid-ids.h.orig	2010-09-09 17:48:28.000000000 +0200
> +++ hid/hid-ids.h	2010-09-09 17:41:09.000000000 +0200
> @@ -25,6 +25,7 @@
>  #define USB_VENDOR_ID_A4TECH		0x09da
>  #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
>  #define USB_DEVICE_ID_A4TECH_X5_005D	0x000a
> +#define USB_DEVICE_ID_A4TECH_RP_649	0x001a
> 
>  #define USB_VENDOR_ID_AASHIMA		0x06d6
>  #define USB_DEVICE_ID_AASHIMA_GAMEPAD	0x0025

You'd also need to add this device to hid_blacklist[] in hid-core.c, 
otherwise hid-a4tech driver wouldn't automatically bind to the device.

Could you please fix that up in your patch and resend it to me?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
