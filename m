Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1A2Igr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:36:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51022 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1A2Igp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:36:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Eogx1c7JOmGivJNUxfcW25MkzlSSc6qmtWGU0FVToydBPkPLJRAeEVyUiHikmu3GXp
         +X1uXbbRbVHM2QuPzp4sIVxRwhI84X2DIG4cn/BaAm4rU/bedguS+/JiqTxYH8maivBI
         D6sWjnWb1yDVB8GVXP46nL7L25MKDg/Hfd+7U=
Date: Sat, 29 Jan 2011 00:36:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robin Theunis <robint91@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB HID plug and play, hardware developer frustration
Message-ID: <20110129083638.GD26915@core.coreip.homeip.net>
References: <AANLkTinytMpW8-7eEDg1O+vUP=C6-MHc8H8yssRbbxUc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinytMpW8-7eEDg1O+vUP=C6-MHc8H8yssRbbxUc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ho Robin,

On Sat, Jan 29, 2011 at 09:15:11AM +0100, Robin Theunis wrote:
> Hi Devs,
> 
> Currently I am design a USB product, and in that process I also look
> if almost every OS supports my device.
> The device is just only a HID digitizer or touch tablet thingy. It
> reports it self also as HID device. This is to have it
> work PLUG and PLAY. But I gotten a cold shower when trying this on my
> linux pcs. It doesn't work!
> I did some investigation and found that the linux (kernel) only
> support mouses and keyboard, all the other usage pages
> that are included in the USB HID specs aren't implemented.
> http://www.usb.org/developers/devclass_docs/Hut1_11.pdf
> 
> Is there a reason why they aren't implemented? especially the
> digitizer thingies because of all the new tablets?

Linux HID driver does have code to handle digitizers, please take a look
at drivers/hid/hid-input.c::hidinput_configure_usage().

> Is it difficult
> to make a driver to support my device?

It should not be. You might need to tweak usage mappings a bit by the
way of writing small HID sub-driver. Look for examples in
drivers/hid/hid-<vendor>.c

If you need additional help I'd recommend asking on
linux-input@vger.kernel.org

> I have seen that there are a
> lot of wacom drivers, I think doing all the same thing.
>

Wacoms are quite different since they are not HID devices but handler by
a completely separate driver.

Thanks.

-- 
Dmitry
