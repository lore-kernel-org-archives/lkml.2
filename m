Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1AGRH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:07:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56515 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1AGRH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RG4g3vmInahSmYLKcE7dukZkwmzqdVgKD8XZnhiuwp5rorFBmnkNSIyHFe3+Q4Qgjl
         w3m8FOtfMi/p41mXT5t4D8cFtaDJDAeNvkEXmXo12EU2UAycJkEQXftpBpngWCFyvWx7
         3k9bZajlB+MAeczJiDl1eXzbin/J4HPaaIQfY=
MIME-Version: 1.0
In-Reply-To: <20110107155714.GA506@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294248468-19979-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110106172528.GD1790@polaris.bitmath.org>
	<AANLkTimhk80b+jkqsNrxmFzSgmHX=_wdzbwE09NoFgV1@mail.gmail.com>
	<20110107122338.GB2312@polaris.bitmath.org>
	<AANLkTimYaZcvLyijtEm-iu+PzNXdozcNbFJQ6+PzD4vK@mail.gmail.com>
	<20110107155714.GA506@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 18:07:53 +0100
X-Google-Sender-Auth: h1E2B8Rv8uB652SNxBhZAba1kz0
Message-ID: <AANLkTimZ-VuvY8fEuPz7gzWVFvLHaJHG34gvkOuMMq2O@mail.gmail.com>
Subject: Re: [RFC v2 03/10] hid-multitouch: support for PixCir-based panels
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

On Fri, Jan 7, 2011 at 4:57 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Jan 07, 2011 at 04:12:24PM +0100, Benjamin Tissoires wrote:
>> Hi Henrik,
>>
>> I've made the changes and I pushed them on the git of our lab. I
>> thought it was easier for you to have a look at the changes instead of
>> resending the whole patch. But v3 will be for this afternoon.
>
> Well, it is not really easier, since there is no easy way to comment
> on the code. Also, transparency is lost. Please let the review process
> take its time.
>
>>
>> the repo is at:
>> http://lii-enac.fr/cgi-bin/gitweb.cgi?p=linux-input/enac-drivers.git;a=summary
>> the changes are on the branch "hid-multitouch-dtor" from "Copyright
>> notice" to the head ("hid-input: better way of handling
>> HID_FEATURE_REPORT").
>>
>> To summarize:
>>
>> - I used touch_state and seen_in_this_frame -> I hope the semantic is
>> now clearer. I was able to test it on stantum and cypress device. I
>> should do the test for pixcir as soon as I can have some time in the
>> afternoon, and the test against generaltouch should happend in the
>> beginning of the week.
>
> The code looks clearer, but there are still two more or less identical
> structures in there. Please remove, it just looks silly.

In not a big fan of this idea, but we have to find a compromise -> will do.

>
>> - I integrated fuzz (please check)
>
> But the mt_input_mapped function did not change - needs to change too.

I can not see any differences between mt_input_mapped and those found
in 3m and egalax. Can you point me exactly what I should add please?

>
>> - I re-factorized set_abs (just copied-pasted your code)
>
> Ok.
>
>> - I made other small changes
>>
>> - Concerning the quirks, I am not very in favor ATM: a flag for
>> compute slot will infer a switch of 5 cases in the emit_event, and the
>> idea was to be able to have a constant time access (1) when using
>> specific function.
>> The Quirk MT_QUIRK_NOT_SEEN_MEANS_UP is better (it will speed up a
>> little the code: 1 test against 1 test and 1 affectation) but I don't
>> think it worse the effort for further device additions.
>
> Given everything that happens within a hid packet, this really, really
> does not matter much. And the quirks can be implemented efficiently
> too, if really needed.

Will do.

>
>> - The Egalax problem: I am pretty sure that Stéphane took this driver
>> into account when writing the original patch. BTW I propose to
>> postpone the problem for 2.6.39.
>
> This driver is aiming at engulfing a larger set of drivers, and as
> such, should be prepared sensibly, IMO. Rushing things will only cause
> us grief further down the road.
>

So, have you got any clue (or even better, can you test a solution)
for those devices?

Cheers,
Benjamin
