Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1GLI7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:59:52 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:50761 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1GLI7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:59:50 -0400
Date: Tue, 12 Jul 2011 12:58:52 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam found
	on HP Mini 5103 netbook
Message-ID: <20110712085852.GA12576@tugrik.mns.mnsspb.ru>
References: <1308679663-11431-1-git-send-email-kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308679663-11431-1-git-send-email-kirr@mns.spb.ru>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:07:43PM +0400, Kirill Smelkov wrote:
> The camera there identifeis itself as being manufactured by Cheng Uei
> Precision Industry Co., Ltd (Foxlink), and product is titled as "HP
> Webcam [2 MP Fixed]".
> 
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
> P.S. Now with tweaked ehci-hcd to allow up to 90% isoc bandwith (instead of
> allowed for high speed 80%) I can capture two video sources -- PAL 720x576
> YUV422 @25fps + NTSC 640x480 YUV422 @30fps simultaneously. Hooray!
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>


Silence...  though even the above-mentioned EHCI tweak was merged already:

http://git.kernel.org/?p=linux/kernel/git/gregkh/usb-2.6.git;a=commitdiff;h=cc62a7eb6396e8be95b9a30053ed09191818b99b


Hope this patch is not lost and thanks,
Kirill
