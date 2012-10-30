Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2J3KLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:11:10 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:51307 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2J3KLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121029214925.GA15400@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-5-git-send-email-benjamin.tissoires@gmail.com>
	<20121029214925.GA15400@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:11:04 +0100
Message-ID: <CAN+gG=EkjM9pi99CxoxEwuLFt_=SL08HLjYYCkVwEnv2Z9gGzw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] HID: hid-multitouch: support arrays for the
 split of the touches in a report
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Oct 29, 2012 at 10:49 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Win8 certification introduced the ability to transmit two X and two Y per
>> touch. The specification precises that it must be in an array, with a
>> report count == 2.
>
> The number two never really enters the patch, so maybe it should be
> dropped to avoid confusion. It probably makes more sense to comment on
> in a later patch, when the reports are actually used.

Yep, it seems that the commit message is not good. I'll rewrite it in v3.

>
>>
>> This test guarantees that we split the touches on the last element
>> in this array.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/hid/hid-multitouch.c | 16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 725d155..95562d8 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -577,12 +577,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>                       return 0;
>>               }
>>
>> -             if (usage->hid == td->last_slot_field)
>> -                     mt_complete_slot(td, field->hidinput->input);
>> -
>> -             if (field->index == td->last_field_index
>> -                     && td->num_received >= td->num_expected)
>> -                     mt_sync_frame(td, field->hidinput->input);
>> +             if (usage_index + 1 == field->report_count) {
>> +                     /* we only take into account the last report
>> +                      * of a field if report_count > 1 */
>
> Seems we could drop "of a field if report_count > 1" here, and be even
> more correct.

oops ;-)

Cheers,
Benjamin

>
>> +                     if (usage->hid == td->last_slot_field)
>> +                             mt_complete_slot(td, field->hidinput->input);
>> +
>> +                     if (field->index == td->last_field_index
>> +                             && td->num_received >= td->num_expected)
>> +                             mt_sync_frame(td, field->hidinput->input);
>> +             }
>>
>>       }
>>
>> --
>> 1.7.11.7
>
> Thanks,
> Henrik
