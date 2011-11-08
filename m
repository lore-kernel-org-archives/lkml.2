Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab1KHSlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:41:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1KHSlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:41:31 -0500
MIME-Version: 1.0
In-Reply-To: <87sjlz80gy.fsf@emc.com.tw>
References: <1320666890-29615-1-git-send-email-jj_ding@emc.com.tw>
	<20111108035930.GC21927@core.coreip.homeip.net>
	<20111108062800.GA1837@core.coreip.homeip.net>
	<87vcqv838n.fsf@emc.com.tw>
	<87sjlz80gy.fsf@emc.com.tw>
Date: Tue, 8 Nov 2011 10:41:29 -0800
Message-ID: <CAKdAkRR+kmxBzmhBJ80F4pMTbf_oQWiUh-hXaG2tQMRynmWP3A@mail.gmail.com>
Subject: Re: [PATCH v2] Input: convert obsolete strict_strtox to kstrtox
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 12:47 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
> On Tue, 08 Nov 2011 15:47:36 +0800, JJ Ding <jj_ding@emc.com.tw> wrote:
>> On Mon, 7 Nov 2011 22:28:01 -0800, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> > On Mon, Nov 07, 2011 at 07:59:30PM -0800, Dmitry Torokhov wrote:
>> > >
>> > > Applied, thanks JJ.
>> > >
>> >
>> > Sorry, I take it back...
>> >
>> > > -       if (strict_strtoul(buf, 10, &value) || value > 1)
>> > > +       if (kstrtouint(buf, 10, &value) || value > 1)
>> > >                 return -EINVAL;
>> >
>> > This mangles error condition from kstrtouint and reporting conditions
>> > beside -EINVAL was the reason for introducing new API IIRC. The proper
>> > conversion should be:
>> >
>> >     err = kstrtouint(buf, 10, &value);
>> >     if (err)
>> >             return err;
>> >
>> >     if (value > 1)
>> >             return -EINVAL;
>> >
>> > Thanks.
>> >
>>
>> Thanks, I get it. I'll fix and resend.
>>
>> jj
>>
>
> Thinking a bit more about your suggestion, and looking at the code more
> closely, some uses of these conversions really want a u8, and some want a
> bool. I think I should check the data type where these converted values
> are really used, and use a more appropriate kstrtox.

If some really want full u8 range then yes, I agree, kstrtou8 is best. For
ones where we have just a few valid values I think we should stick with
conversing to unsigned int and then validate the range manually.

>
> And for those that just need a bool, do you think using strtobool
> introduced in commit d0f1fed29e6e73d9d17f4c91a5896a4ce3938d45 OK?
> That way the user may even type [NnYy01].

I do not like strtobool because it is sloppy. It will also accept 10, yoda, nada
and similar inputs as correct.

Thanks.

-- 
Dmitry
