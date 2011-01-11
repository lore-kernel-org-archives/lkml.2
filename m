Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1AKPKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:10:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41991 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1AKPK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jPBYDLriHLx3Lld+qECRNJGVWIIWWuhTkLYrjtr04tqdkS+bOi679Fq2lb8v4KcRXo
         ZX+62xSuqMtRnK368tfFje86oHG12UernXj92OyZ+L9BZqA/UTXb34KAz3dlRVPrCLH2
         /MqiYxii5vWTpJcpKby93UWEf2Z6F9we02SNc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikqApgrHEh90dvw+8zUne1HA3FmDQYGeEnqZ2W6@mail.gmail.com>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294425762-29730-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110107194918.GB29913@polaris.bitmath.org>
	<AANLkTin8tHO5x2SBugSaEQ6mJ-7upS2YX9OANK1phmdM@mail.gmail.com>
	<20110111130055.GB1961@polaris.bitmath.org>
	<AANLkTikqApgrHEh90dvw+8zUne1HA3FmDQYGeEnqZ2W6@mail.gmail.com>
Date: Tue, 11 Jan 2011 16:10:28 +0100
X-Google-Sender-Auth: P5OV57WP42eRreBvdIKSP6RwGIY
Message-ID: <AANLkTikZs5eiN7LWP_LK9imGbdvUdw6mPqd_b__Qg3La@mail.gmail.com>
Subject: Re: [RFC v3 3/5] hid-multitouch: support for PixCir-based panels
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 2:53 PM, Benjamin Tissoires
<benjamin.tissoires@enac.fr> wrote:
> On Tue, Jan 11, 2011 at 2:00 PM, Henrik Rydberg <rydberg@bitmath.org> wrote:
>>> >> [...]
>>
>>> >> +                     if (value)
>>> >> +                             td->num_expected = value - 1;
>>> >
>>> > The - 1 should be dropped here.
>>>
>>> Here is the really tricky one:
>>>
>>> if I drop -1,
>>>
>>> the test below will be:
>>>  if (field->index == td->last_field_index
>>>       && td->num_received >= td->num_expected)
>>>
>>> but during the init of the device, the kernel receive 1 event though
>>> the driver is not ready.
>>
>> So the current code really needs to also check whether the driver is
>> ready to events. Adding a state for it would be appropriate. As it
>> stands, an unrelated syntatic oddity is covering up this fact.
>>
>>>
>>> During this time, num_expected is at 0, and when we receive the
>>> last_field_index: segfault!
>>>
>>> To sum up, no, we can't.
>>
>> Yes we can. :-)
>
> I'll look into it but I promise nothing.
>

Hehe, I found the bug:

My tests aginst last field in slot and last field in report were not
guarded by (hid->claimed & HID_CLAIMED_INPUT).
Now it works without the -1.

Cheers,
Benjamin


>>> >> +     if (field->index == td->last_field_index
>>> >> +             && td->num_received > td->num_expected)
>>> >
>>> > A ">=" here.
>>
>> still applies then.
>>
>> Thanks,
>> Henrik
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
