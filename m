Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2AXOeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:34:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2AXOeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:34:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120120164849.GA6520@core.coreip.homeip.net>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
	<1326887468-5148-2-git-send-email-benjamin.tissoires@enac.fr>
	<20120120160948.GA18530@polaris.bitmath.org>
	<20120120164849.GA6520@core.coreip.homeip.net>
Date: Tue, 24 Jan 2012 15:34:12 +0100
X-Google-Sender-Auth: ydqbeNenzFBOlguZbuIlDLpkHgI
Message-ID: <CAN+gG=HsiGyCMVHbWm1ri5q5_s8L0Af76B9R8gJVHhKMa8t1FQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hid-multitouch: add support for trackpads
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry and Henrik,

Thanks Dmitry for the comment.

I'll do the change as you mentioned and will also remove the
input_mt_report_finger_count call.

Cheers,
Benjamin

On Fri, Jan 20, 2012 at 17:48, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Jan 20, 2012 at 05:09:48PM +0100, Henrik Rydberg wrote:
>> Hi Benjamin,
>>
>> > @@ -389,9 +404,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>> >                             td->last_field_index = field->index;
>> >                     return -1;
>> >             }
>> > +           case HID_DG_TOUCH:
>> > +                   /* Legacy devices use TIPSWITCH and not TOUCH.
>> > +                    * Let's just ignore this field. */
>> > +                   return -1;
>> >             /* let hid-input decide for the others */
>> >             return 0;
>> >
>> > +   case HID_UP_BUTTON:
>> > +           code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;
>>
>> Why '+' here instead of '|' is  beyond me...
>
> Because it is an offset for the range. The fact that it is on power 2
> boundary and we can use "|" is purely coincidential here.
>
> Maybe we should even write it as:
>
>                code = BTN_MOUSE + ((usage->hid - 1) & HID_USAGE);
>
> Thanks,
> Dmitry
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
