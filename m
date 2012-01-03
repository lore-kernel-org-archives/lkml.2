Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2ACPFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:05:22 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:34376 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab2ACPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:05:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-uvc-devel@lists.sourceforge.net
Subject: Re: [Linux-uvc-devel] 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
Date: Tue, 3 Jan 2012 16:05:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.4; x86_64; ; )
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com>
In-Reply-To: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201031605.31117.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

(The linux-uvc-devel mailing list has been moved to SourceForge, I've CC'ed 
the new list)

On Tuesday 03 January 2012 15:21:02 Justin Piszcz wrote:
> Hello,
> 
> Using an Acer 7551-7442 here with the following built-in webcam:
> Bus 002 Device 004: ID 0402:9665 ALi Corp. Gateway Webcam
> 
> It seems motion locks up every day or so and I see this in the kernel logs:
> [378982.724053] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724066] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724079] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724090] uvcvideo: Failed to resubmit video URB (-27).
> [378982.724101] uvcvideo: Failed to resubmit video URB (-27).
> [489148.723367] uvcvideo: Failed to resubmit video URB (-27).
> [489148.723379] uvcvideo: Failed to resubmit video URB (-27).
> [489148.723391] uvcvideo: Failed to resubmit video URB (-27).
> [489148.723403] uvcvideo: Failed to resubmit video URB (-27).
> [489148.723414] uvcvideo: Failed to resubmit video URB (-27).
>
> If I restart motion, it will usually start working again, I do not
> have this problem on other (retail) Logitech webcams, was curious if
> this a bug with the webcam (quirk?) or a problem in uvcvideo?

-27 is -EFBIG. As the uvcvideo driver set the ASAP isochronous scheduling flag 
when submitting URBs, this most probably results from a bug in the USB host 
controller hardware, from a bug in the USB host controller driver, or from a 
driver that blocks interrupts for several tens of milliseconds.

Which kernel version are you using ? An isochronous scheduling regression has 
been fixed recently between v3.2-rc3 and v3.2-rc5. You might want to try v3.2 
when it will be released.

> The camera is built-into the laptop screen at the top in the middle.
> 
> lsusb verbose:
> 
> Bus 002 Device 004: ID 0402:9665 ALi Corp. Gateway Webcam
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x0402 ALi Corp.
>   idProduct          0x9665 Gateway Webcam
>   bcdDevice            0.09
>   iManufacturer           3 XPB3L1K44
>   iProduct                1 1.3M WebCam
>   iSerial                 0
>   bNumConfigurations      1

Could you please send me the complete lsusb -v output for the device ? I'll 
then add it to the supported devices list.

-- 
Regards,

Laurent Pinchart
