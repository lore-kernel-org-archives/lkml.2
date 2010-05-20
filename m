Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0ETESq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 00:18:46 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:44030 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0ETESo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 00:18:44 -0400
X-Greylist: delayed 14710 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 00:18:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tzElgjZxur/7X0gP+d8Ve7E5ejW6lP86wOxew2npEqB4RdxyFp7YxyWzcVL94LkHl0
         3DBTs0myJ/ZXIVceH3znIPk0m4VK4/NmYVNG7+pz2+wU9MQJhli70HAFnHx9kKx291Qv
         RLF15Ndd9XOmKnLQ5FCYRbUYhBIHFlsGkyWew=
MIME-Version: 1.0
In-Reply-To: <4BF48A4E.4060807@seas.upenn.edu>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
	 <4BF4756C.8030204@seas.upenn.edu>
	 <AANLkTinLNuyDDR0ISjOcXDatdXWEN4RIyuXc-3aSz2b3@mail.gmail.com>
	 <4BF48198.4090300@seas.upenn.edu>
	 <AANLkTik3wNaTCh5JBI7A69QWh9RXvZo0UcuoZ-rQTDlz@mail.gmail.com>
	 <4BF48A4E.4060807@seas.upenn.edu>
Date: Wed, 19 May 2010 21:18:36 -0700
Message-ID: <AANLkTinAQ4ygkcX_4D_Lbi-eLbbghdSXlLzH3HZBhDou@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 6:03 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 05/19/10 20:51, Ping Cheng wrote:
>> On Wed, May 19, 2010 at 5:26 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> On 05/19/10 20:13, Ping Cheng wrote:
>>>> On Wed, May 19, 2010 at 4:34 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>>>>> My understanding is that it would be more like
>>>>> +   SYN_MT_SLOT 0
>>>>> +   ABS_MT_POSITION_X x
>>>>> +   ABS_MT_POSITION_Y y
>>>>> +   SYN_REPORT
>>>>> +   SYN_MT_SLOT 0
>>>>> +   ABS_MT_POSITION_X x
>>>>> +   ABS_MT_POSITION_Y y
>>>>> +   SYN_REPORT
>>>>> +   SYN_MT_SLOT 0
>>>>> +   ABS_MT_POSITION_X x
>>>>> +   ABS_MT_POSITION_Y y
>>>>> +   SYN_MT_SLOT 1
>>>>> +   ABS_MT_POSITION_X x
>>>>> +   ABS_MT_POSITION_Y y
>>>>> +   SYN_REPORT
>>>>
>>>> You are right if one slot only has or is only allowed to have one
>>>> point. My scenario is that one slot can have more than one point.
>>>> Basically, my intention is to utilize the MT_SLOT and MT_TRACKING_ID
>>>> in such a way that it avoids as much overlap as possible.
>>>>
>>>> And hopefully it makes sesne in the reality too.
>>>
>>> Please clarify by what you mean by more than one point.
>>
>> I might have been confused myself by ABS_MT_BLOB_ID and SYN_MT_SLOT
>> here.  What I meant by "more than one point" is a contact (or touch, I
>> am not sure which one is the right term :) is represented by a few
>> (x,y) coordinates. Maybe we should use SYN_MT_SLOT for my case?

The last sentence above should be "Maybe we should NOT use SYN_MT_SLOT
for my case?" or "Maybe I should use MT_BLOB_ID for that case?". A
typical typo for those whose hands are slower than their brains :).

>>> I may be misunderstanding, but I thought that these slots are basically a
>>> superior replacement to tracking id.
>>>
>>> one finger -> one slot
>>
>> This is what I needed to understand. Is slot for one (x,y) only or can
>> it also be used for more than one set of (x,y)?
>>
>>> But with slots we can use the filtering that input provides, which we've been
>>> by-passing with the existing MT protocol (at least that's what I think Henrik's
>>> goal is).
>>
>> Good to know that filtering has already been considered. I know I must
>> be out of sync with Henrik's goal.  That's why I wanted to show my
>> ignorance :).
>>
>> Ping
>>
>
> Hey, sometimes Mark Twain's old advice is good, and sometimes its not.
>
> It's better to keep your mouth shut and be thought a fool than to open it and
> leave no doubt. --Mark Twain
>
>
> I think this is definitely a case where he's wrong.  We need to sync up so that
> we're all implementing the same protocol, and can move on to the next
> interesting problem.

I hope this is the common goal for everyone who has been involved in
the _MT_ support.

Ping
