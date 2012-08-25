Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2HYTEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:04:15 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:48950 "EHLO
	homiemail-a83.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756687Ab2HYTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=nbD6YghBYfOzHL6w5RU9ckf1Ufez09d+gX2lruKUcdXxW09y7/mX2WIwZNT5T
	BmCWKnHfGPX0oFavxJvub5nOPYbjHuZFUib4pg20VRRBcxvzhaSoZloF/jcP1GqX
	oWtyFnnw8emHAx6H5DEECkKtgU3nTYNByqeeFZpn+IQQUg=
Message-ID: <503921AB.6060104@shealevy.com>
Date: Sat, 25 Aug 2012 15:04:11 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120703 Thunderbird/11.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2012 01:28 PM, Henrik Rydberg wrote:
> As pointed out by Gustavo and Marcel, all Apple-specific Broadcom
> devices seen so far have the same interface class, subclass and
> protocol numbers. This patch adds an entry which matches all of them,
> using the new USB_VENDOR_AND_INTERFACE_INFO() macro.
>
> In particular, this patch adds support for the MacBook Pro Retina
> (05ac:8286), which is not in the present list.
>
> Signed-off-by: Henrik Rydberg<rydberg@euromail.se>
> ---
> Hi Gustavo,
>
> here is a patch for the Apple devices, utilizing commit d81a5d19, for
> 3.6. Tested on the MacBookPro10,1 (Retina). If you want, I can
> follow-up with a patch for 3.7 which removes the specific entries. I
> have verified the lsusb output of all of them, except MacMini5,1.
>
> Thanks,
> Henrik
>
>   drivers/bluetooth/btusb.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 12075ad..1fae607 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -52,6 +52,9 @@ static struct usb_device_id btusb_table[] = {
>   	/* Generic Bluetooth USB device */
>   	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
>
> +	/* Apple-specific (Broadcom) devices */
> +	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
> +
>   	/* Broadcom SoftSailing reporting vendor specific */
>   	{ USB_DEVICE(0x0a5c, 0x21e1) },
>

Tested on my Macbook Pro 9,2, usb-devices output:

T:  Bus=04 Lev=04 Prnt=04 Port=02 Cnt=01 Dev#=  9 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=821d Rev=00.86
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

So:

Tested-by: Shea Levy <shea@shealevy.com>
