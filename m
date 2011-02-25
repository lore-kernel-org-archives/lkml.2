Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1BYLSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:18:08 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54792 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1BYLSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UAabRFNlDI4NqI/0I4ZpSE9F/FH+es/DeIbCbRWeTm/RzJ5WtXSCfNvxWJWrdYeQLy
         GdIuSoL6y1V1m/qYJrFYKvOd86qGclcSAnT1C4PLFykhEfQZ7MpdkKsHsnQAc9jn/DwS
         jnuhXipoyULjCh9xO3lzqOLseN3BWyS+lxKd8=
MIME-Version: 1.0
In-Reply-To: <20110224204300.GA2423@polaris.bitmath.org>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
	<AANLkTi=VfSbbV5xwpacC+8yDUfjR3-S8OW47YPvtZwFX@mail.gmail.com>
	<20110224204300.GA2423@polaris.bitmath.org>
Date: Fri, 25 Feb 2011 12:18:00 +0100
X-Google-Sender-Auth: 73sehwuvBpkucUzaqXRj9xj58-Y
Message-ID: <AANLkTi=YBYrgf66Md_G2Cas7t__BDD2nozvidYDj0p9W@mail.gmail.com>
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

after some quick tests, I can deal with our two options (changing
feature_mapping signature or not, and so calling feature_mapping
before or after input_mapping).

So, my questions are:
- do we really need to change feature_mapping signature?
- is feature_mapping tied to an input or to a device?

Cheers,
Benjamin

On Thu, Feb 24, 2011 at 21:43, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Thu, Feb 24, 2011 at 08:50:55PM +0100, Benjamin Tissoires wrote:
>> Hi Henrik,
>>
>> Thanks for spotting this. BTW, I'm not happy with your solution.
>>
>> You are sending the feature report before creating the struct
>> hid_input. To be consistent with the rest, we have to keep the same
>> signature. Today, the code does not make any use of it. But I use it
>> in my devel branch to auto-detect the maximum contact count of the
>> device. This was the safest place to call input_mt_init_slots.
>
> Well, the whole point is "which input device". It would only be
> well-defined when the hid device has a single input device. The
> feature callback could be called last, however, if that helps.
>
>> How about adding hidinput as an argument to report_features
>>
>> and calling it after the " for (k = HID_INPUT_REPORT; k <=
>> HID_OUTPUT_REPORT; k++) {" loop with
>>
>> list_for_each_entry_safe(hidinput, next, &hid->inputs, list)
>>     report_features(hid, hidinput);
>>
>> I did not even try to compile it right now (I don't have any
>> multitouch device right now) but I'll be able to make further tests
>> tomorrow.
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
