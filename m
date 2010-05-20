Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0ETBFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:05:21 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:44309 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0ETBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:05:19 -0400
Message-ID: <4BF48A4E.4060807@seas.upenn.edu>
Date: Wed, 19 May 2010 21:03:10 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>	 <4BF4756C.8030204@seas.upenn.edu>	 <AANLkTinLNuyDDR0ISjOcXDatdXWEN4RIyuXc-3aSz2b3@mail.gmail.com>	 <4BF48198.4090300@seas.upenn.edu> <AANLkTik3wNaTCh5JBI7A69QWh9RXvZo0UcuoZ-rQTDlz@mail.gmail.com>
In-Reply-To: <AANLkTik3wNaTCh5JBI7A69QWh9RXvZo0UcuoZ-rQTDlz@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/19/10 20:51, Ping Cheng wrote:
> On Wed, May 19, 2010 at 5:26 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 05/19/10 20:13, Ping Cheng wrote:
>>> On Wed, May 19, 2010 at 4:34 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>>>> My understanding is that it would be more like
>>>> +   SYN_MT_SLOT 0
>>>> +   ABS_MT_POSITION_X x
>>>> +   ABS_MT_POSITION_Y y
>>>> +   SYN_REPORT
>>>> +   SYN_MT_SLOT 0
>>>> +   ABS_MT_POSITION_X x
>>>> +   ABS_MT_POSITION_Y y
>>>> +   SYN_REPORT
>>>> +   SYN_MT_SLOT 0
>>>> +   ABS_MT_POSITION_X x
>>>> +   ABS_MT_POSITION_Y y
>>>> +   SYN_MT_SLOT 1
>>>> +   ABS_MT_POSITION_X x
>>>> +   ABS_MT_POSITION_Y y
>>>> +   SYN_REPORT
>>>
>>> You are right if one slot only has or is only allowed to have one
>>> point. My scenario is that one slot can have more than one point.
>>> Basically, my intention is to utilize the MT_SLOT and MT_TRACKING_ID
>>> in such a way that it avoids as much overlap as possible.
>>>
>>> And hopefully it makes sesne in the reality too.
>>
>> Please clarify by what you mean by more than one point.
> 
> I might have been confused myself by ABS_MT_BLOB_ID and SYN_MT_SLOT
> here.  What I meant by "more than one point" is a contact (or touch, I
> am not sure which one is the right term :) is represented by a few
> (x,y) coordinates. Maybe we should use SYN_MT_SLOT for my case?
> 
>> I may be misunderstanding, but I thought that these slots are basically a
>> superior replacement to tracking id.
>>
>> one finger -> one slot
> 
> This is what I needed to understand. Is slot for one (x,y) only or can
> it also be used for more than one set of (x,y)?
> 
>> But with slots we can use the filtering that input provides, which we've been
>> by-passing with the existing MT protocol (at least that's what I think Henrik's
>> goal is).
> 
> Good to know that filtering has already been considered. I know I must
> be out of sync with Henrik's goal.  That's why I wanted to show my
> ignorance :).
> 
> Ping
> 

Hey, sometimes Mark Twain's old advice is good, and sometimes its not.

It's better to keep your mouth shut and be thought a fool than to open it and
leave no doubt. --Mark Twain


I think this is definitely a case where he's wrong.  We need to sync up so that
we're all implementing the same protocol, and can move on to the next
interesting problem.

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkv0ik4ACgkQwuRiAT9o608XmQCdFiTOymC+OEVyQ+atbEdpCiDd
RRYAoIsNpOZpI0Yxr4BG1uEj7Fja2Fyo
=lK01
-----END PGP SIGNATURE-----
