Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab0DHTPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:15:51 -0400
Received: from LION.SEAS.upenn.edu ([158.130.12.194]:41552 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab0DHTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:15:48 -0400
Message-ID: <4BBE2B4D.9040808@seas.upenn.edu>
Date: Thu, 08 Apr 2010 15:15:25 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100316 Thunderbird/3.0.3
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Michael Poole <mdpoole@troilus.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se> <87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se>
In-Reply-To: <4BBDA555.1020003@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 05:43 AM, Henrik Rydberg wrote:
> Michael Poole wrote:
> [...]
>>
>> How would the slot number for a contact be chosen?
>
> The device driver determines how to use the slots. The driver calls
> input_mt_slot(dev, slot), sends the data for the slot, picks another slot, and
> repeats.
>

Is there any particular downside to defaulting to implicit slot ids?

For drivers/hardware that don't handle tracking, SYN_MT_REPORT could 
just result in dev->slot++ and a SYN_REPORT resets dev->slot to 0;

For tracking hardware do you envision waiting for TRACKING_ID before 
selecting a slot?  If so then either with explicit or implicit slot ids, 
we would need to cache event until the tracking id is read, and either 
use SYN_MT_SLOT or some other mechanism to denote known slot id.


I like the idea and am just wondering if we can simplify the burden for 
the drivers (and reduce the potential for mistakes).

>> If the kernel makes
>> that assignment, what should a "slot" correspond to from a computer
>> user's perspective? "Set[s] of identified sources" is a little vague:
>> Does it mean contacts from one hand, contacts in one displayed window
>> (assuming the touch surface is a screen), or something else?  (I assume
>> it would not duplicate the blob or tracking IDs already defined for MT
>> events.)
>
> The slot is only used for data communication. Think of the slot as a combined,
> unique identifier. For example, imagine a device driver dealing with contacts
> labeled with both a USER_ID and a TRACKING_ID. The driver assigns every active
> (USER_ID, TRACKING_ID) contact to a specific slot, and uses it to communicate
> all changes to that contact. When the contact is destroyed (for instance by
> sending a zero ABS_MT_PRESSURE on that slot), the slot is free to be used for
> another contact.
>
>> It seems like those would be important aspects of the protocol
>> to document in Documentation/input/multi-touch-protocol.txt --
>> otherwise, driver implementers or application developers might get it
>> wrong.
>
> Certainly.
>
 > Cheers,
 > Henrik

Please clarify which slots are emitted to userspace.  At some point you 
mentioned that if any are changed all will be emitted, is that still 
your intent?  Have you reconsidered using an explicit event to signify 
the end of a contact/slot?

Rafi
