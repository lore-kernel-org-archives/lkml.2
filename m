Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1GYNsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:48:31 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:55635 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GYNs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:48:28 -0400
Subject: Re: [PATCH 2/3] hid-multitouch: Filter collections by application  usage.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <CAN+gG=FAFX-N-3FpAmgkE+im4oT9h657Rk9h3=-17sCBwVx35A@mail.gmail.com>
Date: Mon, 25 Jul 2011 15:48:24 +0200
Cc: jeffbrown@android.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, Jeff Brown <jeffbrown@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E25AA279-4029-40BF-9CB0-873763C53AB4@enac.fr>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com><131154 5261-34067-2-git-send-email-jeffbrown@android.com><13989665-31A9-4C70-B578- 5559987CC9F5@enac.fr> <CAN+gG=FAFX-N-3FpAmgkE+im4oT9h657Rk9h3=-17sCBwVx35A@mail.gmail.com>
To: benjamin.tissoires@gmail.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 25 juil. 2011 à 11:29, benjamin.tissoires@gmail.com a écrit :

> Hi Jeff,
> 
> I like the patch as it partially solves the problems left by
> b84bd27fe70206f9253c395958134e4e4b7e55f0 (fix broken egalax). The
> previous patch mapped buttons but now it should be ok.
> Though, we still have the problem of the distinction between stylus and finger.
> 
> It would worth the effort to know if reverting
> b84bd27fe70206f9253c395958134e4e4b7e55f0 and apply this one instead
> still works for eGalax 480d owners (and mosart too IIRC).
> 
> 
> On Mon, Jul 25, 2011 at 11:16, Stéphane Chatty <chatty@enac.fr> wrote:
>> 
>> Le 25 juil. 2011 à 00:07, jeffbrown@android.com a écrit :
>> 
>>> From: Jeff Brown <jeffbrown@google.com>
>>> 
>>> This change fixes two problems.
>>> 
>>> First, it ensures that the hid-multitouch driver does not incorrectly
>>> map GenericDesktop usages that are intended for other applications,
>>> such as a Mouse.
>>> 
>>> Second, it sets the appropriate input properties so that user-space
>>> can distinguish TouchScreen devices (INPUT_PROP_DIRECT) from
>>> TouchPad devices (INPUT_PROP_POINTER) and configure them accordingly.
>>> 
>>> Signed-off-by: jeffbrown@android.com
>>> ---
>>> drivers/hid/hid-multitouch.c |   10 ++++++++++
>>> 1 files changed, 10 insertions(+), 0 deletions(-)
>>> 
>>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>>> index 58d0e7a..4ee21ac 100644
>>> --- a/drivers/hid/hid-multitouch.c
>>> +++ b/drivers/hid/hid-multitouch.c
>>> @@ -213,6 +213,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>>       struct mt_class *cls = td->mtclass;
>>>       __s32 quirks = cls->quirks;
>>> 
>>> +     /* Only map fields from TouchScreen or TouchPad collections.
>>> +         * We need to ignore fields that belong to other collections
>>> +         * such as Mouse that might have the same GenericDesktop usages. */
>>> +     if (field->application == HID_DG_TOUCHSCREEN)
>>> +             set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
>>> +     else if (field->application == HID_DG_TOUCHPAD)
>>> +             set_bit(INPUT_PROP_POINTER, hi->input->propbit);
>>> +     else
>>> +             return 0;
> 
> Maybe I'm wrong, but 0 means that hid-input will decide what to do.
> Maybe we should return -1 instead, to be sure not handling this part.
> 
>>> +
>>>       switch (usage->hid & HID_USAGE_PAGE) {
>>> 
>>>       case HID_UP_GENDESK:
>>> --
>>> 1.7.0.4
>>> 
>> 
>> 
>> Looks clever to me. Still, in principle we should check that all (or at least most) known devices fill the application field properly. I'll try to have a look at the report descriptors we have here.
> 
> I checked (with some greps) the reports we have, and it seems that all
> the device we know provide this application. So it should be safe, but
> I'm not able to test it.
> Stéphane, if you have the time to test it on our lab's devices that
> would be great.

So far it works fine on our Cypress panel. I'll keep you posted about Lumio and Stantum as soon as we have finished compiling Linux 3.0.

St.

