Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab2HOElU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 00:41:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61826 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2HOElS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 00:41:18 -0400
Date: Wed, 15 Aug 2012 01:41:11 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: aborigines <7aborigines7@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add support bluetooth usb 0489:e046 Foxconn / Hon Hai
Message-ID: <20120815044111.GG3344@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	aborigines <7aborigines7@gmail.com>, marcel@holtmann.org,
	padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1344757304-11555-1-git-send-email-7aborigines7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344757304-11555-1-git-send-email-7aborigines7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* aborigines <7aborigines7@gmail.com> [2012-08-12 14:41:44 +0700]:

> $ usb-deveices
> T: Bus=01 Lev=02 Prnt=02 Port=02 Cnt=03 Dev#= 5 Spd=12 MxCh= 0
> D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=0489 ProdID=e046 Rev=01.12
> S: Manufacturer=Broadcom Corp
> S: Product=BCM20702A0
> S: SerialNumber=C01885F67F9E
> C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> $ lsusb
> Bus 001 Device 005: ID 0489:e046 Foxconn / Hon Hai
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index fc4bcd6..fb54c70 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -110,6 +110,7 @@ static struct usb_device_id btusb_table[] = {
>  
>  	/* Foxconn - Hon Hai */
>  	{ USB_DEVICE(0x0489, 0xe033) },
> +	{ USB_DEVICE(0x0489, 0xe046) },
>  
>  	{ }	/* Terminating entry */
>  };

Can you try the following patch and see if it works for you.

	Gustavo

---
commit 8d2952f43af434f0aa5d109a9ae50c5886a9322c (HEAD, master)
Author: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date:   Wed Aug 15 01:38:11 2012 -0300

    Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn
    
    Foxconn devices has a vendor specific class of device, we will match them
    differently now.
    
    Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f637c25..f077f4d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -101,7 +101,7 @@ static struct usb_device_id btusb_table[] = {
        { USB_DEVICE(0x413c, 0x8197) },
 
        /* Foxconn - Hon Hai */
-       { USB_DEVICE(0x0489, 0xe033) },
+       { USB_VENDOR_AND_INTERFACE_INFO(0x0489, 0xff, 0x01, 0x01) },
 
        { }     /* Terminating entry */
 };

