Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0ETA2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:28:47 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:58629 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab0ETA2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:28:45 -0400
Message-ID: <4BF48198.4090300@seas.upenn.edu>
Date: Wed, 19 May 2010 20:26:00 -0400
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
       Michael Poole <mdpoole@troilus.org>, rafi@seas.upenn.edu
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>	 <4BF4756C.8030204@seas.upenn.edu> <AANLkTinLNuyDDR0ISjOcXDatdXWEN4RIyuXc-3aSz2b3@mail.gmail.com>
In-Reply-To: <AANLkTinLNuyDDR0ISjOcXDatdXWEN4RIyuXc-3aSz2b3@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/19/10 20:13, Ping Cheng wrote:
> On Wed, May 19, 2010 at 4:34 PM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>> My understanding is that it would be more like
>> +   SYN_MT_SLOT 0
>> +   ABS_MT_POSITION_X x
>> +   ABS_MT_POSITION_Y y
>> +   SYN_REPORT
>> +   SYN_MT_SLOT 0
>> +   ABS_MT_POSITION_X x
>> +   ABS_MT_POSITION_Y y
>> +   SYN_REPORT
>> +   SYN_MT_SLOT 0
>> +   ABS_MT_POSITION_X x
>> +   ABS_MT_POSITION_Y y
>> +   SYN_MT_SLOT 1
>> +   ABS_MT_POSITION_X x
>> +   ABS_MT_POSITION_Y y
>> +   SYN_REPORT
> 
> You are right if one slot only has or is only allowed to have one
> point. My scenario is that one slot can have more than one point.
> Basically, my intention is to utilize the MT_SLOT and MT_TRACKING_ID
> in such a way that it avoids as much overlap as possible.
> 
> And hopefully it makes sesne in the reality too.

Please clarify by what you mean by more than one point.

I may be misunderstanding, but I thought that these slots are basically a
superior replacement to tracking id.

one finger -> one slot

But with slots we can use the filtering that input provides, which we've been
by-passing with the existing MT protocol (at least that's what I think Henrik's
goal is).

Rafi

>> (2 events from 1 finger, followed by 1 event with both).
>>
>>
>> On 05/19/2010 06:43 PM, Ping Cheng wrote:
>>>
>>> Hi Henrik,
>>>
>>> I am trying to link the protocol to the actual multi-touch devices in
>>> my "mind". Hope it helps you to point out the mismatch between my
>>> imagination and the protocol.  Please see details in line.
>>>
>>> Ping
>>>
>>> On Tue, May 18, 2010 at 1:10 PM, Henrik Rydberg<rydberg@euromail.se>
>>>  wrote:
>>>>
>>>> This patch adds documentation for the SYN_MT_SLOT event and
>>>> gives examples of how to use the event slot protocol.
>>>
>>> Am I right in thinking that SYN_MT_SLOT represents to the actual touch
>>> area/finger on the surface? There could be more than one (x,y) (a few
>>> points that form an irregular shape) that represents one finger.  The
>>> following example shows that slot 0 (finger 1) touched three points on
>>> the surface while slot 1 (finger 2) only has one point reported:
>>>
>>> +   SYN_MT_SLOT 0
>>> +   ABS_MT_TRACKING_ID 45
>>> +   ABS_MT_POSITION_X x[0]
>>> +   ABS_MT_POSITION_Y y[0]
>>> +   ABS_MT_TRACKING_ID 46
>>> +   ABS_MT_POSITION_X x[1]
>>> +   ABS_MT_POSITION_Y y[1]
>>> +   ABS_MT_TRACKING_ID 47
>>> +   ABS_MT_POSITION_X x[2]
>>> +   ABS_MT_POSITION_Y y[2]
>>> +   SYN_MT_SLOT 1
>>> +   ABS_MT_TRACKING_ID 30
>>> +   ABS_MT_POSITION_X x[3]
>>> +   ABS_MT_POSITION_Y y[3]
>>> +   SYN_REPORT
>>>
>>> If my assumption is correct, i.e., one slot can have more than one
>>> point, I would think ABS_MT_TRACKING_ID may not have to be a required
>>> entry inside SYN_MT_SLOT.  To the user land clients/drivers,
>>> SYN_MT_SLOT itself could serve as an ID. So, the following case is
>>> also a type B ( we know there are two touch areas. But we don't keep
>>> track of the points inside the areas):
>>>
>>> +   SYN_MT_SLOT 0
>>> +   ABS_MT_POSITION_X x[0]
>>> +   ABS_MT_POSITION_Y y[0]
>>> +   ABS_MT_POSITION_X x[1]
>>> +   ABS_MT_POSITION_Y y[1]
>>> +   ABS_MT_POSITION_X x[2]
>>> +   ABS_MT_POSITION_Y y[2]
>>> +   SYN_MT_SLOT 1
>>> +   ABS_MT_POSITION_X x[3]
>>> +   ABS_MT_POSITION_Y y[3]
>>> +   SYN_REPORT
>>>
>>> So, an EVIO for X driver to retrieve the number of SLOTs would be very
>>> helpful.  Something like the following would do the work:
>>>
>>> input_set_abs_params(input_dev, ABS_MT_SLOT, 0, 12, 0, 0);
>>>
>>> which tells the user land clients that they can expect up to 13 touch
>>> areas.
>>>
>>>> +The main difference between the raw type A protocol and the higher level
>>>> +type B slot protocol lies in the usage of identifiable contacts. The
>>>> slot
>>>> +protocol requires the use of the ABS_MT_TRACKING_ID,
>>>
>>> With what I said above, I think ABS_MT_TRACKING_ID is not the unique
>>> identifier for type B protocol. It is the fact that we can identify
>>> individual touch areas and use ABS_MT_SLOT to report them that makes
>>> it a type B event.
>>>
>>>> ABS_MT_TRACKING_ID, either provided by the
>>>> +hardware of computed from the raw data [5].
>>>
>>>                    ^^ or  (is it?)
>>>
>>> I agree with this ABS_MT_TRACKING_ID definition.  I would think something
>>> like:
>>>
>>> input_set_abs_params(input_dev, ABS_MT_TRACKING_ID, 0, 47, 0, 0);
>>>
>>> which tells the clients that total of 48 points are tracked, would be
>>> helpful.
>>>
>>> Another topic that may be irrelevant to this patch is the filter. With
>>> the use of ABS_MT_TRACKING_ID, a filter can be applied to discard the
>>> useless repeated points or less than a certain number of points
>>> movement.
>>>
>>
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkv0gZgACgkQwuRiAT9o60/v5QCguYH/eGD4R12cIPGc/AF3Xz6Y
RXgAoIfEYSVqekbLRU4NXHo0bnG323vA
=OUmf
-----END PGP SIGNATURE-----
