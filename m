Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2BHV2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:28:01 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:39673 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab2BHV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:27:59 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH 37/50] usbnet: set addr_assign_type if random_ether_addr() used
Date: Wed, 8 Feb 2012 22:30:19 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Danny Kukawka <dkukawka@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-38-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1328735457-29986-38-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202082230.19936.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 8. Februar 2012, 22:10:44 schrieb Danny Kukawka:
> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> a random MAC address was generated and assigned to the netdevice.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/net/usb/usbnet.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index fae0fbd..7bd07d7 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1365,6 +1365,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	dev->net = net;
>  	strcpy (net->name, "usb%d");
>  	memcpy (net->dev_addr, node_id, sizeof node_id);
> +	net->addr_assign_type |= NET_ADDR_RANDOM;
>  
>  	/* rx and tx sides can use different message sizes;
>  	 * bind() should set rx_urb_size in that case.

Don't you set the flag too early here? By that time we don't know
whether the device provides a real MAC, do we?

	Regards
		Oliver
