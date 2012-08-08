Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2HHIiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:38:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854Ab2HHIiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:38:03 -0400
Message-ID: <50222565.5060603@suse.cz>
Date: Wed, 08 Aug 2012 10:37:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, linux-kernel@vger.kernel.org,
        John Hommel <john.hommel@hp.com>
Subject: Re: [PATCH v2] Bluetooth: Another vendor specific ID for BCM20702A0
 [0a5c:21f1]
References: <1343431747.1803.12.camel@aeonflux> <1343742454-28019-1-git-send-email-mmarek@suse.cz> <20120806184047.GD3146@joana>
In-Reply-To: <20120806184047.GD3146@joana>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.8.2012 20:40, Gustavo Padovan wrote:
> Author: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> Date:   Mon Aug 6 15:36:49 2012 -0300
> 
>     Bluetooth: Use USB_VENDOR_AND_INTERFACE_INFO() for Broadcom devices
>     
>     Many Broadcom devices has a vendor specific devices class, with this rule
>     we match all existent and future controllers with this behavior.
>     
>     Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index cef3bac..504231e 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -104,6 +104,9 @@ static struct usb_device_id btusb_table[] = {
>         /* Foxconn - Hon Hai */
>         { USB_DEVICE(0x0489, 0xe033) },
>  
> +       /*Broadcom devices with vendor specific id */
> +       { USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },

Hi Gustavo,

Yes, this works. Well, I don't posses the card personally, but a helpful
person at HP confirmed that the btusb driver with this patch works with
the new card. So you can add

  Tested-by: John Hommel <john.hommel@hp.com>

BTW, the following ID can also be removed after adding the above match:

	{ USB_DEVICE(0x0a5c, 0x21e1) },
	{ USB_DEVICE(0x0a5c, 0x21e3) },
	{ USB_DEVICE(0x0a5c, 0x21e6) },
	{ USB_DEVICE(0x0a5c, 0x21e8) },
	{ USB_DEVICE(0x0a5c, 0x21f3) },

Thanks,
Michal
