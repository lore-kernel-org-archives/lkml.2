Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1AGLMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:12:23 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40253 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1AGLMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:12:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O79IvjmToKYv3pJEGf080Bpb6BT5ogp6h0eXzzONmZFoZLA7pnhCRCfp3EodvnTizm
         oqEgCr8cmZMH4f3B/lsCv12sspNvNikQ/enJgk84h9nhpd4TpmOO8O1ykGDZUp7SfTDf
         j4Amot1PInYsNKwqGpy/fmn+ZBmtGf6usHvDo=
MIME-Version: 1.0
In-Reply-To: <20110107101839.GA2312@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294248468-19979-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110106162223.GB1790@polaris.bitmath.org>
	<AANLkTi=xdPJP9okhRL8q-0vL5cVPKniAjve6BQHmB=+p@mail.gmail.com>
	<20110107101839.GA2312@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 12:12:19 +0100
X-Google-Sender-Auth: YTfDJ-d4X4P75FPfJ_7_r-kwdR0
Message-ID: <AANLkTim3WY4yUWMQUBMV0q--w2U6LeVb_CYVgkUL_5tT@mail.gmail.com>
Subject: Re: [RFC v2 01/10] hid: add feature_mapping callback
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

On Fri, Jan 7, 2011 at 11:18 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> >>       struct input_dev *input_dev;
>> >>       int i, j, k;
>> >> -     int max_report_type = HID_OUTPUT_REPORT;
>> >> +     int max_report_type = HID_FEATURE_REPORT;
>> >
>> > Doing it this way conflicts with the HID_QUIRK_SKIP_OUTPUT_REPORTS quirk.
>>
>>
>> Do you agree on this way? (will send the patch in the next version)
>>
>> @@ -834,11 +842,10 @@ int hidinput_connect(struct hid_device *hid,
>> unsigned int force)
>>  {
>>       struct hid_report *report;
>>       struct hid_input *hidinput = NULL;
>>       struct input_dev *input_dev;
>>       int i, j, k;
>> -     int max_report_type = HID_OUTPUT_REPORT;
>>
>>       INIT_LIST_HEAD(&hid->inputs);
>>
>>       if (!force) {
>>               for (i = 0; i < hid->maxcollection; i++) {
>> @@ -851,14 +858,14 @@ int hidinput_connect(struct hid_device *hid,
>> unsigned int force)
>>
>>               if (i == hid->maxcollection)
>>                       return -1;
>>       }
>>
>> -     if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
>> -             max_report_type = HID_INPUT_REPORT;
>> +     for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++)
>> +             if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
>> +                     continue;
>>
>> -     for (k = HID_INPUT_REPORT; k <= max_report_type; k++)
>>               list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
>>
>>                       if (!report->maxfield)
>>                               continue;
>
> Perfect.

Well, in fact, I made 2 big mistakes (forgot the brackets after
for(;;), and test if k==HID_OUTPUT_REPORT...), but the idea is still
the same.

Sorry,
Benjamin
