Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2HGBpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:45:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41031 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2HGBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:45:14 -0400
Date: Mon, 6 Aug 2012 18:45:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 1/2] hid: Blacklist new eBeam classic device
Message-ID: <20120807014510.GB21477@core.coreip.homeip.net>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
 <1344288104-20731-2-git-send-email-yann.cantin@laposte.net>
 <20120806214340.GA30355@kroah.com>
 <1975621.3ErbANJ9at@dtor-d630.eng.vmware.com>
 <50206DA9.1070503@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50206DA9.1070503@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 03:21:45AM +0200, Yann Cantin wrote:
> Le 07/08/2012 00:07, Dmitry Torokhov a écrit :
> > On Monday, August 06, 2012 02:43:40 PM Greg KH wrote:
> >> On Mon, Aug 06, 2012 at 11:21:43PM +0200, Yann Cantin wrote:
> >>> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> >>> ---
> >>>
> >>>  drivers/hid/hid-core.c |    3 +++
> >>>  drivers/hid/hid-ids.h  |    3 +++
> >>>  2 files changed, 6 insertions(+)
> >>>
> >>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> >>> index 60ea284..b1ed8ee 100644
> >>> --- a/drivers/hid/hid-core.c
> >>> +++ b/drivers/hid/hid-core.c
> >>> @@ -1908,6 +1908,9 @@ static const struct hid_device_id hid_ignore_list[]
> >>> = {> 
> >>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20)
> >>>  	},
> >>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
> >>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
> >>>
> >>> +#if defined(CONFIG_INPUT_EBEAM_USB)
> >>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_CLASSIC) },
> >>> +#endif
> >>
> >> Why is this #if in here?  Just always do it, how could it not be
> >> defined?
> > 
> > User might disable the driver and CONFIG_INPUT_EBEAM_USB will not be
> > set. But I agree, since the device is unusable with generic HID driver
> > there is no point in doing this conditionally.
> 
> There's a closed-source user-space stack (libusb based daemon + xorg driver
> + wine apps) provided for some distro (Ubuntu 10.04, works on mandriva 2010,
> maybe others but break on recent xorg).
> 
> I don't know exactly what to do : i don't want to break hypothetical support,
> even proprietary.
> Leaving the choice at kernel compile time seems to be safer, no ?

If they are using libusb that means that they use userspace solution and
do not require HID or any other in-kernel driver. They should still be
able to claim the port even if your driver is in use.

Thanks.

-- 
Dmitry
