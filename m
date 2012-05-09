Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770Ab2EITNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:13:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34709 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2EITNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120506190322.GB12571@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
	<1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
	<20120506190322.GB12571@polaris.bitmath.org>
Date: Wed, 9 May 2012 21:13:07 +0200
Message-ID: <CAN+gG=HQ_U5dhVvgLu0zfMjv1+SAVB2Rx8fNq8tLX2DUHOMa9A@mail.gmail.com>
Subject: Re: [PATCH 2/5] HID: hid-multitouch: get maxcontacts also from
 logical_max value
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 9:03 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi,
>
>> Win8 devices are required to present the feature "Maximum Contact Number".
>> If the current value is 0, then, the driver can get the actual supported
>> contact count by seeing the logical_max.
>
> And for win7, it is zero?

Well, the truth is that the Win8 specification formally describes the
values here. And to get the certification, hardware makers have to put
the right value in logical_max.
TBH, I don't care that much now with win7 devices. Most of them are a
piece of crap (not true dual fingers, problems in hid reports
descriptors, etc...), but they just work (we made the necessary
things). With the introduction of Win8, hardware makers will have to
*certify* their devices, and thus, the Win8 driver is much less
tolerant. I really think that we are going to see more and more win8
devices, whereas win7 devices will fade out.

I had to add this patch because I have a win8 device that has the
value associated to this field at 0, and it's the first I saw with
this behavior.

Cheers,
Benjamin

>
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/hid/hid-multitouch.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index c6ffb05..e205d1e 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -265,6 +265,8 @@ static void mt_feature_mapping(struct hid_device *hdev,
>>       case HID_DG_CONTACTMAX:
>>               td->maxcontact_report_id = field->report->id;
>>               td->maxcontacts = field->value[0];
>> +             if (!td->maxcontacts)
>> +                     td->maxcontacts = field->logical_maximum;
>>               if (td->mtclass.maxcontacts)
>>                       /* check if the maxcontacts is given by the class */
>>                       td->maxcontacts = td->mtclass.maxcontacts;
>> --
>> 1.7.7.6
>>
>
> Thanks,
> Henrik
