Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2HFSk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:40:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59418 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2HFSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:40:55 -0400
Date: Mon, 6 Aug 2012 15:40:47 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bluetooth: Another vendor specific ID for BCM20702A0
 [0a5c:21f1]
Message-ID: <20120806184047.GD3146@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Michal Marek <mmarek@suse.cz>, linux-bluetooth@vger.kernel.org,
	marcel@holtmann.org, linux-kernel@vger.kernel.org
References: <1343431747.1803.12.camel@aeonflux>
 <1343742454-28019-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343742454-28019-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

* Michal Marek <mmarek@suse.cz> [2012-07-31 15:47:34 +0200]:

> T:  Bus=02 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  3 Spd=12   MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0a5c ProdID=21f1 Rev= 1.12
> S:  Manufacturer=Broadcom Corp
> S:  Product=BCM20702A0
> S:  SerialNumber=9CB70DCFF833
> C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 file changed, 1 insertion(+)

Can you try the following patch on 3.6-rc1? It should fix this by matching
vendor and inteface info.

	Gustavo

---

Author: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date:   Mon Aug 6 15:36:49 2012 -0300

    Bluetooth: Use USB_VENDOR_AND_INTERFACE_INFO() for Broadcom devices
    
    Many Broadcom devices has a vendor specific devices class, with this rule
    we match all existent and future controllers with this behavior.
    
    Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index cef3bac..504231e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -104,6 +104,9 @@ static struct usb_device_id btusb_table[] = {
        /* Foxconn - Hon Hai */
        { USB_DEVICE(0x0489, 0xe033) },
 
+       /*Broadcom devices with vendor specific id */
+       { USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },
+
        { }     /* Terminating entry */
 };
