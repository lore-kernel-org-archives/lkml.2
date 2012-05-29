Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab2E2M2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:28:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40285 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2E2M2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:28:02 -0400
Date: Tue, 29 May 2012 07:27:49 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Michael =?utf-8?B?R3LDvHR6bmVy?= <mgruetzn@gmx.de>
Cc: stable@vger.kernel.org, marcel@holtmann.org, gustavo@padovan.org,
        johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>
Subject: [3.0.y, 3.2.y, 3.4.y] Re: [PATCH 1/1] bluetooth: Add support for
 Foxconn/Hon Hai AR5BBU22 0489:E03C
Message-ID: <20120529122749.GA16706@burratino>
References: <1769868.QZY8sEHkp9@dagobah>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1769868.QZY8sEHkp9@dagobah>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben and Greg,

Please consider

  85d59726c5c6 Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

for inclusion if appropriate in the 3.0.y, 3.2.y, and 3.4.y trees.

Michael Grützner wrote:

> Add Foxconn/Hon Hai AR5BBU22 Bluetooth Module( 0x489:0xE03C) to 
> the blacklist of btusb module and add it to the ath3k module to properly load 
> the firmware in Kernel 3.3.4
> The device is integrated in  e.g. some  Acer Aspire 7750G.

I am guessing this is tested by Michael against 3.3.y.

I am wondering about one detail about the patch (please forgive my
ignorance):

[...]
> --- linux-3.3.4-vanilla/drivers/bluetooth/ath3k.c	2012-04-27 19:17:35.000000000 +0200
> +++ linux-3.3.4/drivers/bluetooth/ath3k.c	2012-04-30 01:29:47.081838667 +0200
> @@ -79,6 +79,9 @@ static struct usb_device_id ath3k_table[
>  	/* Atheros AR5BBU12 with sflash firmware */
>  	{ USB_DEVICE(0x0489, 0xE02C) },
>  
> +	/* Atheros AR5BBU22 with sflash firmware */
> +	{ USB_DEVICE(0x0489, 0xE03C) },
> +
>  	{ }	/* Terminating entry */

This part makes sense and seems similar to what is done for other
Atheros bluetooth adaptors that need firmware loaded at run time, like
the AR3011.

>  };
>  
> @@ -95,6 +98,9 @@ static struct usb_device_id ath3k_blist_
>  	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
>  	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
>  
> +	/* Atheros AR5BBU22 with sflash firmware */
> +	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
> +
>  	{ }	/* Terminating entry */

No other chip other than the AR3012 seems to add entries here.  Could
you add a comment explaining why the AR5BBU22 is listed but not e.g.
the AR5BBU12?

> --- linux-3.3.4-vanilla/drivers/bluetooth/btusb.c	2012-04-27 19:17:35.000000000 +0200
> +++ linux-3.3.4/drivers/bluetooth/btusb.c	2012-04-30 01:31:49.302182281 +0200
> @@ -135,6 +135,9 @@ static struct usb_device_id blacklist_ta
>  	/* Atheros AR5BBU12 with sflash firmware */
>  	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
>  
> +	/* Atheros AR5BBU22 with sflash firmware */
> +	{ USB_DEVICE(0x0489, 0xe03c), .driver_info = BTUSB_ATH3012 },
> +

Is the AR5BBU22 an AR3012?

Curious,
Jonathan
