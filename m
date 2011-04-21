Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1DUMTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:19:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53579 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1DUMTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LQW9mbMnbYWboaEP/SKeJhJI1h3oMlcT00wBT9brYDE3From7Abw0yobBuvLCIbn6L
         iV5eSx+/a/4cfqp/7OiyrKP9OofCb5N8FrGiMd+say1bwWQcYYxd2sY5hJgaLU6FNmBp
         /kjiAeQJG1rlo3AdrPO+r20qZ3qM6ZAOfy0h0=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1104211417330.12035@pobox.suse.cz>
References: <1303388160-2814-1-git-send-email-benjamin.tissoires@enac.fr>
	<1303388160-2814-3-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1104211417330.12035@pobox.suse.cz>
Date: Thu, 21 Apr 2011 14:19:51 +0200
X-Google-Sender-Auth: Vp-2-U4gzzCotwp13hDzuvQZhfU
Message-ID: <BANLkTikN-KRh4i1u_iuZwuQtWP2gU95Oeg@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: add support for PenMount dual-touch panel
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>,
        PenMount <penmount.touch@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 14:18, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 21 Apr 2011, Benjamin Tissoires wrote:
>
>> Signed-off-by: John Sung <penmount.touch@gmail.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>
> Hi Benjamin,
>
> thanks for respinning the pathes.
>
> This one is though missing
>
> - changelog
> - From: line (I believe we'd like to keep John's authorship)

Yep, sorry for that, I just seen it in my triple check after sending
it (grrr...). Do you want me to resend it, or we wait for John to do
it?

Cheers,
Benjamin

>
> Thanks.
>
>> ---
>>  drivers/hid/hid-core.c       |    1 +
>>  drivers/hid/hid-ids.h        |    3 +++
>>  drivers/hid/hid-multitouch.c |    8 ++++++++
>>  3 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index c3d6626..6e31b9f 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1438,6 +1438,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
>>       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index d485894..252aeba 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -484,6 +484,9 @@
>>  #define USB_VENDOR_ID_PANTHERLORD    0x0810
>>  #define USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK  0x0001
>>
>> +#define USB_VENDOR_ID_PENMOUNT               0x14e1
>> +#define USB_DEVICE_ID_PENMOUNT_PCI   0x3500
>> +
>>  #define USB_VENDOR_ID_PETALYNX               0x18b1
>>  #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE 0x0037
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 6005e78..51b5d27 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -89,6 +89,7 @@ struct mt_class {
>>  #define MT_CLS_EGALAX                                5
>>  #define MT_CLS_STANTUM                               6
>>  #define MT_CLS_3M                            7
>> +#define MT_CLS_CONFIDENCE                    8
>>
>>  #define MT_DEFAULT_MAXCONTACT        10
>>
>> @@ -156,6 +157,8 @@ struct mt_class mt_classes[] = {
>>               .sn_move = 2048,
>>               .sn_width = 128,
>>               .sn_height = 128 },
>> +     { .name = MT_CLS_CONFIDENCE,
>> +             .quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
>>
>>       { }
>>  };
>> @@ -584,6 +587,11 @@ static const struct hid_device_id mt_devices[] = {
>>               HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
>>                       USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
>>
>> +     /* PenMount panels */
>> +     { .driver_data = MT_CLS_CONFIDENCE,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
>> +                     USB_DEVICE_ID_PENMOUNT_PCI) },
>> +
>>       /* PixCir-based panels */
>>       { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
>>               HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
>> --
>> 1.7.4.2
>>
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
