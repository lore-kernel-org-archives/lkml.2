Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1CIJOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab1CIJN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mOoV7vQ054CJ15NKR8dWs5Sg3vgQdvNgXjm2APwyYDmEwdZg3GY+BCdTVc6lukVJk8
         OC9Jex4uo4aHs9vZLck8UfJmCsMJ+OzGpB3SoPsmR2BmgwEgccrcWJugSkOJVhmAYLhX
         6TZJDc9TgeJeiYYS9z5vMNL3caMCdDt8bbD9U=
MIME-Version: 1.0
In-Reply-To: <20110309084645.GB3569@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
	<1299601979-4871-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110309084645.GB3569@polaris.bitmath.org>
Date: Wed, 9 Mar 2011 10:13:55 +0100
X-Google-Sender-Auth: Cx7-AJtt5WkcrFCfwzSbUvMfFIM
Message-ID: <AANLkTi=LHwdvpJOyeVqHrpFjikr5=uKsaa_T3LKgXtDP@mail.gmail.com>
Subject: Re: [PATCH 3/4] hid-multitouch: migrate 3M PCT touch screens to the
 unified driver.
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

Hi Henrik

On Wed, Mar 9, 2011 at 09:46, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
> On Tue, Mar 08, 2011 at 05:32:58PM +0100, Benjamin Tissoires wrote:
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>
> Semms this patch is missing a commit message.

You can copy/paste this point to the other patches as well.

How about:
"3M PCT touch screens can be handled by the unified driver. This will
ease future evolution. So, just move it."

Then I'll copy/paste for the others.

>
> [...]
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index e7a4f83..f32bf46 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -5,6 +5,11 @@
>>   *  Copyright (c) 2010-2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>>   *  Copyright (c) 2010-2011 Ecole Nationale de l'Aviation Civile, France
>>   *
>> + *  based on hid-3m-pct.c copyrighted as follows:
>> + *    Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
>> + *    Copyright (c) 2010      Henrik Rydberg <rydberg@euromail.se>
>> + *    Copyright (c) 2010      Canonical, Ltd.
>> + *
>>   */
>>
>>  /*
>> @@ -74,6 +79,7 @@ struct mt_class {
>>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER    3
>>  #define MT_CLS_CYPRESS                               4
>>  #define MT_CLS_STANTUM                               5
>> +#define MT_CLS_3M                            6
>>
>>  /*
>>   * these device-dependent functions determine what slot corresponds
>> @@ -124,6 +130,11 @@ struct mt_class mt_classes[] = {
>>               .maxcontacts = 10 },
>>       { .name = MT_CLS_STANTUM,
>>               .quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
>> +     { .name = MT_CLS_3M,
>> +             .quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
>> +                     MT_QUIRK_SLOT_IS_CONTACTID,
>> +             .sn_move = 2048,
>> +             .sn_pressure = 128 },
>>
>>       { }
>>  };
>> @@ -479,6 +490,14 @@ static void mt_remove(struct hid_device *hdev)
>>
>>  static const struct hid_device_id mt_devices[] = {
>>
>> +     /* 3M panels */
>> +     { .driver_data = MT_CLS_3M,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_3M,
>> +                     USB_DEVICE_ID_3M1968) },
>> +     { .driver_data = MT_CLS_3M,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_3M,
>> +                     USB_DEVICE_ID_3M2256) },
>> +
>>       /* Cypress panel */
>>       { .driver_data = MT_CLS_CYPRESS,
>>               HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
>
> The touch width correction from the original driver has gone missing
> here. Otherwise, looks good, but will defer testing to the next round.

Oops, it's not missing, it has been transformed into sn_pressure...
Will correct it.

By looking at it, I just saw that we override values for HID_DG_HEIGHT
to the range [0-1].
I'll have to dig into.

For the tests, I've tested it on the 1968.

Thanks,
Benjamin
