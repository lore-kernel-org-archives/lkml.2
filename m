Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2LEKK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:10:59 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39127 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2LEKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:10:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121204224205.58420e3f@endymion.delvare>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-3-git-send-email-benjamin.tissoires@gmail.com>
	<20121204224205.58420e3f@endymion.delvare>
Date: Wed, 5 Dec 2012 11:10:54 +0100
Message-ID: <CAN+gG=Hk+BCexxUif2Eqt9sQ4-_K1dfiUx5xD52-Hj2k5hUPug@mail.gmail.com>
Subject: Re: [PATCH 02/14] HID: i2c-hid: fix memory corruption due to missing
 hid declaration
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 10:42 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue,  4 Dec 2012 16:27:43 +0100, Benjamin Tissoires wrote:
>> HID descriptors contains 4 bytes of reserved field.
>> The previous implementation was overriding the next fields in struct i2c_hid.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/i2c-hid/i2c-hid.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> index 0fbb229..ad771a7 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> @@ -68,6 +68,7 @@ struct i2c_hid_desc {
>>       __le16 wVendorID;
>>       __le16 wProductID;
>>       __le16 wVersionID;
>> +     __le32 reserved;
>>  } __packed;
>>
>>  struct i2c_hid_cmd {
>> @@ -778,7 +779,7 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
>>       }
>>
>>       dsize = le16_to_cpu(hdesc->wHIDDescLength);
>> -     if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
>> +     if (!dsize || dsize > sizeof(struct i2c_hid_desc)) {
>
> Shouldn't !dsize rather be dsize < 4? You're reading hdesc->bcdVersion,
> which is only defined if dsize >= 4 if I understand the code correctly.

Yes, you are right. Thanks.

Jiri, this patch is a prerequisite for "[PATCH 10/14] HID: i2c-hid:
reorder allocation/free of buffers".
could you please what for a v2 before applying 10/14?

Cheers,
Benjamin

>
>>               dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
>>                       dsize);
>>               return -ENODEV;
>
>
> --
> Jean Delvare
