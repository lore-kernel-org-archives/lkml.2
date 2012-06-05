Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab2FEStc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:49:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45233 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2FESta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+gG=FSTxE9d8o4O6+kQHmyg9PdJK28x6=Gjpgr+_xppiRVbQ@mail.gmail.com>
References: <CAOY97VZN2a36OBsacQS21P8G70L2tbtbWK5OMWhZYa=D74XO+w@mail.gmail.com>
	<alpine.LNX.2.00.1206051134020.5478@pobox.suse.cz>
	<CAN+gG=FSTxE9d8o4O6+kQHmyg9PdJK28x6=Gjpgr+_xppiRVbQ@mail.gmail.com>
Date: Tue, 5 Jun 2012 11:49:28 -0700
Message-ID: <CAOY97Vbjzbv-=jOwxnKR-eBBtGv33aFWV3G3VQnBMVaxMkQYiQ@mail.gmail.com>
Subject: Re: [PATCH] Add Support for Novatek Touchscreen
From: Austin Hendrix <ahendrix@willowgarage.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry about the line wrapping; I'll make sure my mail client deals with it
properly in the future.

Comments inline.

On Tue, Jun 5, 2012 at 3:52 AM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> Hi Austin, Jiri,
>
> I'm a bit concerned about this patch. Though it's fine for pre-3.5
> kernels, it does not fit into the 3.5 work.
> The thing is that it's easier to backport this patch in it's current
> form, so I don't know exactly the best way to tackle this.

I initially wrote this patch against 3.3, so I guess I'm not surprised that
things have changed a bit since then. I can make another patch against 3.5 if
that's the right thing to do.

>
> See comments inlined.
>
> On Tue, Jun 5, 2012 at 11:34 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Mon, 4 Jun 2012, Austin Hendrix wrote:
>>
>>> Add support for a Novatek touchscreen panel as a generic HID multitouch
>>> panel.
>>>
>>> Signed-off-by: Austin Hendrix <ahendrix@willowgarage.com>
>>> ---
>>>  hid-core.c       |    1 +
>>>  hid-ids.h        |    3 +++
>>>  hid-multitouch.c |    5 +++++
>>>  3 files changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>>> index 8e3a6b2..0d6dde1 100644
>>> --- a/drivers/hid/hid-core.c
>>> +++ b/drivers/hid/hid-core.c
>>> @@ -1605,6 +1605,7 @@ static const struct hid_device_id
>>> hid_have_special_driver[] = {
>>
>> Austin,
>>
>> thanks for the patch. Your mail client is corrupting (line-wrapping)
>> patches. Please fix that for your future submissions.
>>
>> I have now fixed that up manually and applied.
>>
>>>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16) },
>>>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
>>>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
>>> +     { HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_PCT) },
>
> I don't think this should be included in 3.5-rc+ (the whole MT-related
> devices has been removed from this list).
>
>>>       { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
>>>       { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
>>>       { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX,
>>> USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
>>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>>> index 9373f53..734a2b9 100644
>>> --- a/drivers/hid/hid-ids.h
>>> +++ b/drivers/hid/hid-ids.h
>>> @@ -564,6 +564,9 @@
>>>  #define USB_VENDOR_ID_NINTENDO               0x057e
>>>  #define USB_DEVICE_ID_NINTENDO_WIIMOTE       0x0306
>>>
>>> +#define USB_VENDOR_ID_NOVATEK                0x0603
>>> +#define USB_DEVICE_ID_NOVATK_PCT    0x0600
>>> +
>>>  #define USB_VENDOR_ID_NTRIG          0x1b96
>>>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
>>>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1   0x0003
>>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>>> index 6e3332a..fae08df 100644
>>> --- a/drivers/hid/hid-multitouch.c
>>> +++ b/drivers/hid/hid-multitouch.c
>>> @@ -951,6 +951,11 @@ static const struct hid_device_id mt_devices[] = {
>>>               MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
>>>                       USB_DEVICE_ID_PANABOARD_UBT880) },
>>>
>>> +     /* Novatek Panel */
>>> +     { .driver_data = MT_CLS_DEFAULT,
>>> +             HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
>>> +                     USB_DEVICE_ID_NOVATEK_PCT) },
>
> Shouldn't we use MT_USB_DEVICE instead?

That does look like the hip thing to do in 3.5.

-Austin

>
> Cheers,
> Benjamin
>
>>> +
>>>       /* PenMount panels */
>>>       { .driver_data = MT_CLS_CONFIDENCE,
>>>               MT_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
>>>
>>
>> --
>> Jiri Kosina
>> SUSE Labs
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
