Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab1KPOC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:02:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58667 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab1KPOCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1111161457110.15187@pobox.suse.cz>
References: <1321439992-5221-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1111161457110.15187@pobox.suse.cz>
Date: Wed, 16 Nov 2011 15:02:23 +0100
Message-ID: <CAN+gG=GceWC95Yc-mdpX+H-Lf_jgWd6uAYDa7Xoq=EaoRXBnPA@mail.gmail.com>
Subject: Re: [PATCH] HID: Correct General touch PID
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 14:57, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 16 Nov 2011, Benjamin Tissoires wrote:
>
>> Genera Touch told us that 0001 is their single point device
>> and 0003 is the multitouch one. Apparently, we made the tests
>> someone having a prototype, and not the final product.
>> They said it should be safe to do the switch.
>>
>> this partially revert 5572da08a784621f2ab4fdc8dc65471261871795
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/hid/hid-core.c |    2 +-
>>  drivers/hid/hid-ids.h  |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 6780796..5278f1f 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1727,8 +1727,8 @@ static const struct hid_device_id hid_ignore_list[] = {
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0001) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0002) },
>> -     { HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0003) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0004) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GLAB, USB_DEVICE_ID_4_PHIDGETSERVO_30) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GLAB, USB_DEVICE_ID_1_PHIDGETSERVO_30) },
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index 0a541a9..75062c3 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -256,7 +256,7 @@
>>  #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR       0x0002
>>
>>  #define USB_VENDOR_ID_GENERAL_TOUCH  0x0dfc
>> -#define USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS 0x0001
>> +#define USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS 0x0003
>>
>>  #define USB_VENDOR_ID_GLAB           0x06c2
>>  #define USB_DEVICE_ID_4_PHIDGETSERVO_30      0x0038
>
> Thanks Benjamin, applied. I guess you'd like to have that one in 3.2
> still, right?

right ;-)

thanks a lot Jiri,
Benjamin

>
> --
> Jiri Kosina
> SUSE Labs
>
