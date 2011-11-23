Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1KWLcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:32:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63772 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1KWLcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <201111231146.51325.marek.vasut@gmail.com>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
	<1322042074-3759-7-git-send-email-benjamin.tissoires@enac.fr>
	<201111231146.51325.marek.vasut@gmail.com>
Date: Wed, 23 Nov 2011 12:32:49 +0100
X-Google-Sender-Auth: ytQVh6OvelHYI1t4Y-2KaKFSE_U
Message-ID: <CAN+gG=FMJL9EyKXFEF6vcFJe6jrU9bryieKD7+vdu3wp03uhmw@mail.gmail.com>
Subject: Re: [PATCH 6/8] HID-multitouch: Add egalax ID for Acer Iconia W500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:46, Marek Vasut <marek.vasut@gmail.com> wrote:
>> From: Marek Vasut <marek.vasut@gmail.com>
>>
>> This patch adds USB ID for the touchpanel in Acer Iconia W500. The panel
>> supports up to five fingers, therefore the need for a new addition of panel
>> types.
>>
>> originally Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>> CC: Marek Vasut <marek.vasut@gmail.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/hid/hid-core.c       |    1 +
>>  drivers/hid/hid-ids.h        |    1 +
>>  drivers/hid/hid-multitouch.c |    3 +++
>>  3 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index b776bfb..e3c9e61 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1409,6 +1409,7 @@ static const struct hid_device_id
>> hid_have_special_driver[] = { { HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C) }, {
>> HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) }, {
>> HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) }, +       {
>> HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) }, {
>> HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) }, {
>> HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
>> { HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2515) }, diff
>> --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index a9526fd..fc49ab3 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -235,6 +235,7 @@
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C    0x720c
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B    0x726b
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1    0x72a1
>> +#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302    0x7302
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001    0xa001
>>
>>  #define USB_VENDOR_ID_ELECOM         0x056e
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index db39228..8e920cd 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -701,6 +701,9 @@ static const struct hid_device_id mt_devices[] = {
>>                       USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72A1) },
>>       { .driver_data = MT_CLS_EGALAX,
>>               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> +                     USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302) },
>> +     { .driver_data = MT_CLS_EGALAX,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>>                       USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
>>
>>       /* Elo TouchSystems IntelliTouch Plus panel */
>
> It seems good, but how do you detect the number of fingers the panel can handle?
> That's autodetected now?

Yes, I removed the .maxcontact field it in patch 4/8 in the series.

Cheers,
Benjamin

>
> M
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
