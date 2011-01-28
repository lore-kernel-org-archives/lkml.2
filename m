Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1A1R7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:59:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39592 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1A1R7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ceXIpJH6UpxLBcJ+OS7rSxeRMHrKuPhNmQ+l7mrU17oXvTh/cLGaxNb3oXCH5KdnRt
         A6GfZRV/oNwOZQ6TsgnPRO1AbEkHDu2FYLdJRGE4gAjpCn4Q7gtSkb+r9hXOFswS+WRE
         lagDcfcMSCUPNkR2Ltc1TksgeKYvizzOyLNO0=
MIME-Version: 1.0
In-Reply-To: <20110128172139.GB2586@polaris.bitmath.org>
References: <1296230680-2871-1-git-send-email-benjamin.tissoires@enac.fr>
	<1296230680-2871-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110128172139.GB2586@polaris.bitmath.org>
Date: Fri, 28 Jan 2011 18:59:13 +0100
X-Google-Sender-Auth: Qw5n0csKnJCURstAQsHtR2-mDyg
Message-ID: <AANLkTi=XKTdOBGcG8oo49=yPvSnsH5CpCsfhwwedm0eT@mail.gmail.com>
Subject: Re: [PATCH 2/2] hid-multitouch: introduce IrTouch Infrared USB device
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 18:21, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Jan 28, 2011 at 05:04:40PM +0100, Benjamin Tissoires wrote:
>> The product id is the 42 inches one. I don't know if they have
>> other product id for the other size, or if it is a per-size product id.
>>
>> Tested-by: Victor Zhuk <v.zhuk@acs-ltd.ru>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>
> The canonical patch description presents the reason for the change,
> and what the patch does (not necessarily how).

It was just to keep trace of the kind of display it was. As Florian
told the 63" does not have the same PID but not also the same
protocol.
Otherwise, we can also change the name of the define, but I'm not sure
on the rule to apply here.

Thanks,
Benjamin

>
>>  drivers/hid/Kconfig          |    1 +
>>  drivers/hid/hid-ids.h        |    3 +++
>>  drivers/hid/hid-multitouch.c |    5 +++++
>>  3 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 24cca2f..a0b117d 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -304,6 +304,7 @@ config HID_MULTITOUCH
>>         Say Y here if you have one of the following devices:
>>         - Cypress TrueTouch panels
>>         - Hanvon dual touch panels
>> +       - IrTouch Infrared USB panels
>>         - Pixcir dual touch panels
>>         - 'Sensing Win7-TwoFinger' panel by GeneralTouch
>>
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
>> +
>>  #define USB_VENDOR_ID_JESS           0x0c45
>>  #define USB_DEVICE_ID_JESS_YUREX     0x1010
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index ffe2a76..1629296 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -475,6 +475,11 @@ static const struct hid_device_id mt_devices[] = {
>>               HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
>>                       USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
>>
>> +     /* IRTOUCH panels */
>> +     { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
>> +                     USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
>> +
>>       /* PixCir-based panels */
>>       { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
>>               HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
>> --
>> 1.7.3.4
>>
>
> Thanks,
> Henrik
>
