Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2AXOjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:39:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54261 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2AXOjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:39:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120120161956.GB18530@polaris.bitmath.org>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
	<1326887468-5148-3-git-send-email-benjamin.tissoires@enac.fr>
	<20120120161956.GB18530@polaris.bitmath.org>
Date: Tue, 24 Jan 2012 15:39:09 +0100
X-Google-Sender-Auth: vThFHrlbMVanhilFyM7w393rhfU
Message-ID: <CAN+gG=ERwqDgydj-LLnv2GPLSiW8cC4QZS2f7shxxnNLzJY+xg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] HID: multitouch: add control of the feature
 "Maximum Contact Number"
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Jan 20, 2012 at 17:19, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> If the programmer fills the field maxcontacts in the mt_class,
>> then the driver will set the feature to this value. It is safe
>> for current drivers as the feature is read/right in the HID norm
>
> read/write, I presume.

you're right... ;-)

>
>> @@ -609,6 +612,36 @@ static void mt_set_input_mode(struct hid_device *hdev)
>>       }
>>  }
>>
>> +static void mt_set_maxcontacts(struct hid_device *hdev)
>> +{
>> +     struct mt_device *td = hid_get_drvdata(hdev);
>> +     struct hid_report *r;
>> +     struct hid_report_enum *re;
>> +     int fieldmax, max;
>> +
>> +     if (td->maxcontact_report_id < 0)
>> +             return;
>> +
>> +     if (!td->mtclass.maxcontacts)
>> +             return;
>> +
>> +     re = &(hdev->report_enum[HID_FEATURE_REPORT]);
>
> Why parenthesis here?

ok

>
>> +     r = re->report_id_hash[td->maxcontact_report_id];
>> +     if (r) {
>> +             max = td->mtclass.maxcontacts;
>> +             fieldmax = r->field[0]->logical_maximum;
>> +             hid_info(hdev, "%s: value = %d / %d / %d\n", __func__,
>> +                     r->field[0]->value[0],
>> +                     td->mtclass.maxcontacts,
>> +                     fieldmax);
>
> Looks like debug information, please downplay or remove.

I can remove them if you need.

>
>> +             max = fieldmax < max ? fieldmax : max;
>
> There are kernel variants of min/max functions to consider here.

I'll look for them.

>
>> +             if (r->field[0]->value[0] != max) {
>> +                     r->field[0]->value[0] = max;
>> +                     usbhid_submit_report(hdev, r, USB_DIR_OUT);
>> +             }
>
> So the report is in fact only set when different... Do we know for
> which current devices this is true?

Currently, I've got only the Perixx touchpad that needs this feature
to be set. The initial value is 0 whereas it should be 2.

Maybe some drivers that used the DUAL_MT_CLS_* can handle more, but I
have no idea has I don't have many of them.

Cheers,
Benjamin

>
> Thanks,
> Henrik
