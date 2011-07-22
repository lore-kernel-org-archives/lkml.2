Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1GVWEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:04:04 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38680 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab1GVWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:04:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: [PATCH, RESEND] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam found on HP Mini 5103 netbook
Date: Sat, 23 Jul 2011 00:03:57 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110722144722.GA3717@tugrik.mns.mnsspb.ru>
In-Reply-To: <20110722144722.GA3717@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107230003.59800.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On Friday 22 July 2011 16:47:22 Kirill Smelkov wrote:
>  [ Cc'ing Andrew Morton -- Andrew, could you please pick this patch, in
>    case there is no response from maintainers again? Thanks beforehand. ]
> 
> 
> Hello up there,
> 
> My first posting was 1 month ago, and a reminder ~ 2 weeks ago. All
> without a reply. v3.0 is out and they say the merge window will be
> shorter this time, so in oder not to miss it, I've decided to resend my
> patch on lowering USB periodic bandwidth allocation topic.

I'm very very sorry for missing the patch (and worse, twice :-/).

> Could this simple patch be please applied?

Yes it can. I see that Andrew already applied it to his tree. Mauro, should it 
go through there, or through your tree ? I've pushed it to my tree at 
git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable, so you can already 
pull.

> Thanks,
> Kirill
> 
> 
> P.S.
> 
> Referenced in the description cc62a7eb (USB: EHCI: Allow users to
> override 80% max periodic bandwidth) will be entering the mainline via
> Greg's usb tree.
> 
> ---- 8< ----
> From: Kirill Smelkov <kirr@mns.spb.ru>
> Subject: [PATCH] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam found on HP
> Mini 5103 netbook
> 
> The camera there identifies itself as being manufactured by Cheng Uei
> Precision Industry Co., Ltd (Foxlink), and product is titled as "HP
> Webcam [2 MP Fixed]".

The device isn't listed in the supported devices list. Could you please send 
me its lsusb -v output ?

> I was trying to get 2 USB video capture devices to work simultaneously,
> and noticed that the above mentioned webcam always requires packet size
> = 3072 bytes per micro frame (~= 23.4 MB/s isoc bandwidth), which is far
> more than enough to get standard NTSC 640x480x2x30 = ~17.6 MB/s isoc
> bandwidth.
> 
> As there are alt interfaces with smaller MxPS
> 
>     T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
>     D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
>     P:  Vendor=05c8 ProdID=0403 Rev= 1.06
>     S:  Manufacturer=Foxlink
>     S:  Product=HP Webcam [2 MP Fixed]
>     S:  SerialNumber=200909240102
>     C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
>     A:  FirstIf#= 0 IfCount= 2 Cls=0e(video) Sub=03 Prot=00
>     I:* If#= 0 Alt= 0 #EPs= 1 Cls=0e(video) Sub=01 Prot=00 Driver=uvcvideo
>     E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=4ms
>     I:* If#= 1 Alt= 0 #EPs= 0 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     I:  If#= 1 Alt= 1 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS= 128 Ivl=125us
>     I:  If#= 1 Alt= 2 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS= 512 Ivl=125us
>     I:  If#= 1 Alt= 3 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=1024 Ivl=125us
>     I:  If#= 1 Alt= 4 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=1536 Ivl=125us
>     I:  If#= 1 Alt= 5 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=2048 Ivl=125us
>     I:  If#= 1 Alt= 6 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=2688 Ivl=125us
>     I:  If#= 1 Alt= 7 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=3072 Ivl=125us
> 
> UVC_QUIRK_FIX_BANDWIDTH helps here and NTSC video can be served with
> MxPS=2688 i.e. 20.5 MB/s isoc bandwidth.
> 
> In terms of microframe time allocation, before the quirk NTSC video
> required 60 usecs / microframe and 53 usecs / microframe after.
> 
> 
> P.S.
> 
> Now with tweaked ehci-hcd to allow up to 90% isoc bandwidth (cc62a7eb
> "USB: EHCI: Allow users to override 80% max periodic bandwidth") I can
> capture two video sources -- PAL 720x576 YUV422 @25fps + NTSC 640x480
> YUV422 @30fps simultaneously.  Hooray!
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index b6eae48..f633700 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -2130,6 +2130,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info 		= UVC_QUIRK_PROBE_MINMAX
> 
>  				| UVC_QUIRK_BUILTIN_ISIGHT },
> 
> +	/* Foxlink ("HP Webcam" on HP Mini 5103) */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x05c8,
> +	  .idProduct		= 0x0403,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
>  	/* Genesys Logic USB 2.0 PC Camera */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
Regards,

Laurent Pinchart
