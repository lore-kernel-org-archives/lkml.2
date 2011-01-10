Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1AJTNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:13:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42039 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1AJTNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hhIM2gv0I378PNt3NPplplY5iYvU0v86RM3dg1I7jslY54E6nkh35FJqNqPo7SMemA
         6xcK3+QRSUNO1zefvlMJm/qkW6M8IDCTGjrkw/2pSdQoYkMm3PRZpqE4MckcjL/Xy/zx
         veLkabr9aVoprxm7JNWRpc3EBf5x+9zhuoLVM=
MIME-Version: 1.0
In-Reply-To: <20110107200014.GC29913@polaris.bitmath.org>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294425762-29730-5-git-send-email-benjamin.tissoires@enac.fr>
	<20110107200014.GC29913@polaris.bitmath.org>
Date: Mon, 10 Jan 2011 20:13:41 +0100
X-Google-Sender-Auth: Z7_RDu7Ptq0bKPFVnQ7GI_Dz_eY
Message-ID: <AANLkTi=CL=7Aax1dfBHUzszR8KdrJaE0nCHg2tNFAqqJ@mail.gmail.com>
Subject: Re: [RFC v3 4/5] hid-multitouch: added support for Cypress TrueTouch panels
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 9:00 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Jan 07, 2011 at 07:42:41PM +0100, Benjamin Tissoires wrote:
>> Added support for Cypress TrueTouch panels, which detect up to 10 fingers
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> Signed-off-by: Stéphane Chatty <chatty@enac.fr>
>> ---
>
> Hi, just minor things.
>
>>  drivers/hid/Kconfig          |    1 +
>>  drivers/hid/hid-core.c       |    1 +
>>  drivers/hid/hid-ids.h        |    1 +
>>  drivers/hid/hid-multitouch.c |   19 +++++++++++++++++++
>>  4 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 511554d..de31d75 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -293,6 +293,7 @@ config HID_MULTITOUCH
>>
>>         Say Y here if you have one of the following devices:
>>         - PixCir touchscreen
>> +       - Cypress TrueTouch
>>
>>  config HID_NTRIG
>>       tristate "N-Trig touch screen"
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 2b4d9b9..e6a86bf 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1298,6 +1298,7 @@ static const struct hid_device_id hid_blacklist[] = {
>>       { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_3) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, 0x0006) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH1) },
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index 17b444b..c258c42 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -180,6 +180,7 @@
>>  #define USB_DEVICE_ID_CYPRESS_BARCODE_1      0xde61
>>  #define USB_DEVICE_ID_CYPRESS_BARCODE_2      0xde64
>>  #define USB_DEVICE_ID_CYPRESS_BARCODE_3      0xbca1
>> +#define USB_DEVICE_ID_CYPRESS_TRUETOUCH      0xc001
>>
>>  #define USB_VENDOR_ID_DEALEXTREAME   0x10c5
>>  #define USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701      0x819a
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 3b05dfe..7af9f71 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -32,6 +32,7 @@ MODULE_LICENSE("GPL");
>>  /* quirks to control the device */
>>  #define MT_QUIRK_NOT_SEEN_MEANS_UP   (1 << 0)
>>  #define MT_QUIRK_SLOT_IS_CONTACTID   (1 << 1)
>> +#define MT_QUIRK_CYPRESS     (1 << 2)
>
> Missing tab.

Ok

>
>>
>>  struct mt_slot {
>>       __s32 x, y, p, w, h;
>> @@ -62,6 +63,7 @@ struct mt_class {
>>  /* classes of device behavior */
>>  #define MT_CLS_DEFAULT 0
>>  #define MT_CLS_DUAL1 1
>> +#define MT_CLS_CYPRESS 2
>
> Missing tabs... goes for the previous patch as well, coming to think of it.

ok and ok

>
> It does seem slightly complicated, doesn't it. How about dropping
> these, and referring to explicit static structures instead?

I don't want people to place those static structures anywhere in the code.

In v4, I've added a field .name and I retrieve it in the mt_probe function.

>
>>
>>  /*
>>   * these device-dependent functions determine what slot corresponds
>> @@ -73,6 +75,14 @@ static int slot_is_contactid(struct mt_device *td)
>>       return td->curdata.contactid;
>>  }
>>
>> +static int cypress_compute_slot(struct mt_device *td)
>> +{
>> +     if (td->curdata.contactid != 0 || td->num_received == 0)
>> +             return td->curdata.contactid;
>> +     else
>> +             return -1;
>> +}
>> +
>>  static int find_slot_from_contactid(struct mt_device *td)
>>  {
>>       int i;
>> @@ -95,6 +105,7 @@ static int find_slot_from_contactid(struct mt_device *td)
>>  struct mt_class mt_classes[] = {
>>       { 0, 0, 0, 10 },                             /* MT_CLS_DEFAULT */
>>       { MT_QUIRK_SLOT_IS_CONTACTID, 0, 0, 2 },     /* MT_CLS_DUAL1 */
>> +     { MT_QUIRK_CYPRESS | MT_QUIRK_NOT_SEEN_MEANS_UP, 0, 0, 10 }, /* MT_CLS_CYPRESS */
>>  };
>
> These could be named structs instead of an array, e.g.,
>
> static const struct mt_class mt_cls_dual1 = {
>       .quirks = MT_QUIRK_SLOT_IS_CONTACTID,
>       .max_contacts = 2,
> };
>
>>
>>  static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
>> @@ -223,6 +234,9 @@ static int mt_compute_slot(struct mt_device *td)
>>       if (cls->quirks & MT_QUIRK_SLOT_IS_CONTACTID)
>>               return slot_is_contactid(td);
>>
>> +     if (cls->quirks & MT_QUIRK_CYPRESS)
>> +             return cypress_compute_slot(td);
>> +
>>       return find_slot_from_contactid(td);
>>  }
>>
>> @@ -422,6 +436,11 @@ static void mt_remove(struct hid_device *hdev)
>>
>>  static const struct hid_device_id mt_devices[] = {
>>
>> +     /* Cypress panel */
>> +     { .driver_data = MT_CLS_CYPRESS,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
>> +                     USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
>> +
>>       /* PixCir-based panels */
>>       { .driver_data = MT_CLS_DUAL1,
>>               HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
>
> Could use pointers here instead.
>
> Thanks!
> Henrik


Thanks,
Benjamin
