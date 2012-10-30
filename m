Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab2J3KJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:09:49 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62038 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2J3KJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <20121029192558.GA15061@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-4-git-send-email-benjamin.tissoires@gmail.com>
	<20121029192558.GA15061@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:09:46 +0100
Message-ID: <CAN+gG=HLmCszdxgdcmt5AgzNyt08HamCdd2BjzCaTB5k7wYcnQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] HID: hid-input: add usage_index argument in
 input_mapping and event.
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 8:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Currently, there is no way to know the index of the current field
>> in the .input_mapping and .event callbacks  when this field is inside
>> an array of HID fields.
>> This patch forwards this index to the input_mapping and event
>> callbacks.
>
> I agree with the idea, but the function argument list is becoming
> ridiculously long... Could we remove the usage pointer argument, at
> least?

yeah, totally agree. Let me just check whether it will not introduce
more problems than it solves for my driver.

>
>         int (*event)(struct hid_device *hdev, struct hid_field *field,
>                         unsigned int usage_index, __s32 value);
>
>
>> @@ -1071,19 +1072,24 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
>>       for (n = 0; n < count; n++) {
>>
>>               if (HID_MAIN_ITEM_VARIABLE & field->flags) {
>> -                     hid_process_event(hid, field, &field->usage[n], value[n], interrupt);
>> +                     hid_process_event(hid, field, &field->usage[n], n,
>> +                             value[n], interrupt);
>>                       continue;
>>               }
>>
>>               if (field->value[n] >= min && field->value[n] <= max
>>                       && field->usage[field->value[n] - min].hid
>>                       && search(value, field->value[n], count))
>> -                             hid_process_event(hid, field, &field->usage[field->value[n] - min], 0, interrupt);
>> +                             hid_process_event(hid, field,
>> +                                     &field->usage[field->value[n] - min], n,
>> +                                     0, interrupt);
>
> Wrong index?

oops, I'll have to check that.

Thanks,
Benjamin

>
>>
>>               if (value[n] >= min && value[n] <= max
>>                       && field->usage[value[n] - min].hid
>>                       && search(field->value, value[n], count))
>> -                             hid_process_event(hid, field, &field->usage[value[n] - min], 1, interrupt);
>> +                             hid_process_event(hid, field,
>> +                                     &field->usage[value[n] - min], n,
>> +                                     1, interrupt);
>
> Wrong index?
>
>>       }
>>
>>       memcpy(field->value, value, count * sizeof(__s32));
>
> Thanks,
> Henrik
