Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab2KFLCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:02:35 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50761 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2KFLCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:02:34 -0500
Date: Tue, 6 Nov 2012 12:02:29 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: Marcos Chaparro <marcos@mrkindustries.com.ar>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath3k: Add support for VAIO VPCEH [0489:e027]
Message-ID: <20121106110229.GA26682@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Marcos Chaparro <marcos@mrkindustries.com.ar>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201211012138.20988.marcos@mrkindustries.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211012138.20988.marcos@mrkindustries.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcos, 

* Marcos Chaparro <marcos@mrkindustries.com.ar> [2012-11-01 21:38:20 -0300]:

> Added Atheros AR3011 internal bluetooth device found in Sony VAIO VPCEH to the 
> devices list.
> Before this, the bluetooth module was identified as an Foxconn / Hai bluetooth 
> device [0489:e027], now it claims to be an AtherosAR3011 Bluetooth 
> [0cf3:3005].
> 
> # cat /sys/kernel/debug/usb/devices
> T:  Bus=01 Lev=02 Prnt=02 Port=04 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0489 ProdID=e027 Rev= 0.01
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> 
> Signed-off by: Marcos A Chaparro <marcos@mrkindustries.com.ar>
> ---
> 
> Updated usb /sys/kernel/debug/usb/devices output. A complete powercycle flushed 
> the device firmware.
> 
> diff --git a/linux-3.7-rc3.orig/drivers/bluetooth/ath3k.c b/linux-3.7-
> rc3.new/drivers/bluetooth/ath3k.c
> index fc2de55..b00000e 100644
> --- a/linux-3.7-rc3.orig/drivers/bluetooth/ath3k.c
> +++ b/linux-3.7-rc3.new/drivers/bluetooth/ath3k.c
> @@ -67,6 +67,7 @@ static struct usb_device_id ath3k_table[] = {
>         { USB_DEVICE(0x13d3, 0x3304) },
>         { USB_DEVICE(0x0930, 0x0215) },
>         { USB_DEVICE(0x0489, 0xE03D) },
> +       { USB_DEVICE(0x0489, 0xE027) },
>  
>         /* Atheros AR9285 Malbec with sflash firmware */
>         { USB_DEVICE(0x03F0, 0x311D) },
> diff --git a/linux-3.7-rc3.orig/drivers/bluetooth/btusb.c b/linux-3.7-
> rc3.new/drivers/bluetooth/btusb.c
> index debda27..ee82f2f 100644
> --- a/linux-3.7-rc3.orig/drivers/bluetooth/btusb.c
> +++ b/linux-3.7-rc3.new/drivers/bluetooth/btusb.c
> @@ -124,6 +124,7 @@ static struct usb_device_id blacklist_table[] = {
>         { USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
>         { USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
>         { USB_DEVICE(0x0489, 0xe03d), .driver_info = BTUSB_IGNORE },
> +       { USB_DEVICE(0x0489, 0xe027), .driver_info = BTUSB_IGNORE },
>  
>         /* Atheros AR9285 Malbec with sflash firmware */
>         { USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },

Please generate your patch with git format-patch. It is currently not applying
because your patch has a few wrong information. Then use git send-email to
send your patch.

	Gustavo
