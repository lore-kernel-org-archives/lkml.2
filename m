Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2BIG6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:58:12 -0500
Received: from canardo.mork.no ([148.122.252.1]:53070 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab2BIG6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:58:01 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Oliver Neukum <oliver@neukum.org>
Cc: Danny Kukawka <danny.kukawka@bisect.de>, Danny Kukawka <dkukawka@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 37/50] usbnet: set addr_assign_type if random_ether_addr() used
Organization: m
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
	<1328735457-29986-38-git-send-email-danny.kukawka@bisect.de>
	<201202082230.19936.oliver@neukum.org>
Date: Thu, 09 Feb 2012 07:57:42 +0100
In-Reply-To: <201202082230.19936.oliver@neukum.org> (Oliver Neukum's message
	of "Wed, 8 Feb 2012 22:30:19 +0100")
Message-ID: <874nv07au1.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oliver@neukum.org> writes:

> Am Mittwoch, 8. Februar 2012, 22:10:44 schrieb Danny Kukawka:
>> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
>> a random MAC address was generated and assigned to the netdevice.
>> 
>> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>> ---
>>  drivers/net/usb/usbnet.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>> index fae0fbd..7bd07d7 100644
>> --- a/drivers/net/usb/usbnet.c
>> +++ b/drivers/net/usb/usbnet.c
>> @@ -1365,6 +1365,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>>  	dev->net = net;
>>  	strcpy (net->name, "usb%d");
>>  	memcpy (net->dev_addr, node_id, sizeof node_id);
>> +	net->addr_assign_type |= NET_ADDR_RANDOM;
>>  
>>  	/* rx and tx sides can use different message sizes;
>>  	 * bind() should set rx_urb_size in that case.
>
> Don't you set the flag too early here? By that time we don't know
> whether the device provides a real MAC, do we?

Maybe it makes sense to set it here anyway since usbnet provides this
default random address, and let the minidrivers which set a real mac
also clear the flag?  But in that case the patch need to clear the flag
everywhere a minidriver currently updates the address.


Bjørn
