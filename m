Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1A1Q7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:59:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab1A1Q7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:59:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KL98c7rZRejy6N5Hs9unUFu3eoH5UfHwJk1XufJI3QYrDkuPNr+rWhBaXNCfCX8Npk
         BZDE+5sDytgPy2+nNzM9nm0gr7woudo+yJvsDUb7BZT1bEsZu2e4G1Y92sb56cMNS4oA
         ZbJuiE5Lgqzm+5DkUMnPPqswn3NCbCndXrxVI=
MIME-Version: 1.0
In-Reply-To: <1296231840.2959.23.camel@hanuta>
References: <1296230680-2871-2-git-send-email-benjamin.tissoires@enac.fr>
	<1296231840.2959.23.camel@hanuta>
Date: Fri, 28 Jan 2011 17:59:40 +0100
X-Google-Sender-Auth: JvcW8k12L9HhEVUpFWRUKMg12t4
Message-ID: <AANLkTinsry1Z6r=ch9-s7BDYOkOd9DeF_UmOJJn_0psd@mail.gmail.com>
Subject: Re: [2/2] hid-multitouch: introduce IrTouch Infrared USB device
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Florian Echtler <floe@butterbrot.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,


On Fri, Jan 28, 2011 at 17:24, Florian Echtler <floe@butterbrot.org> wrote:
> Hello everyone,
>
>> The product id is the 42 inches one. I don't know if they have
>> other product id for the other size, or if it is a per-size product id.
> This is very interesting, I have access to a 65" IrTouch system which
> has VID 0x6615 and PID 0x0C20. I wasn't aware that there are already
> kernel drivers for their systems, I had been playing around with their
> awful binary driver and had done some experiments with libusb. Is there
> a documentation of some kind available?

We just made the analysis of the hid reports that are send. We have no
documentation for this particular device.

>
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index 92a0d61..b1dd7ad 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -333,6 +333,9 @@
>>  #define USB_VENDOR_ID_IMATION                0x0718
>>  #define USB_DEVICE_ID_DISC_STAKKA    0xd000
>>
>> +#define USB_VENDOR_ID_IRTOUCHSYSTEMS 0x6615
>> +#define USB_DEVICE_ID_IRTOUCH_INFRARED_USB   0x0070
> I will test this on our screen next week.
> I assume that I should use the tree from:
> http://git.kernel.org/?p=linux/kernel/git/rydberg/input-mt.git;a=summary

hid-multitouch is schedulded for 2.6.38. So you can also use the stock
2.6.38-rc2:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary


>
> Note: after briefly browsing through hid-multitouch.c, it seems to me
> that there might be issues; the USB interface on our screen doesn't
> report as HID device, but as vendor class (0xFF).

This is more problematic. Hardware makers are forced to push hid aware
firmware to be win7 certified. Maybe they have a new firmware for your
device.

Cheers,
Benjamin
