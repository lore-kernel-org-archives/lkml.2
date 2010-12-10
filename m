Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0LJUBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:01:55 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:59541 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0LJUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:01:53 -0500
Message-ID: <4D02871E.6060204@euromail.se>
Date: Fri, 10 Dec 2010 21:01:34 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se>	<AANLkTi=mqMY_VG=0RdN5O0fDh6wpTRb5Z59L6440hvX6@mail.gmail.com>	<4D026DB1.8070100@euromail.se> <AANLkTinctPSxGt36HCdyoWYH7TBznzY0CejLP3uALkV3@mail.gmail.com>
In-Reply-To: <AANLkTinctPSxGt36HCdyoWYH7TBznzY0CejLP3uALkV3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PR99y-0004Sl-C9.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PR99y-0004Sl-C9 11de5f42d6714a150640538d4f58b247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 08:00 PM, Ping Cheng wrote:

> On Fri, Dec 10, 2010 at 10:13 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>>> Can we make MT_TOOL_ENVELOPE cover a bit more cases by:
>>>
>>> 1. Removing ", and is only used for legacy hardware";
>>> 2. Adding "Or the number of contacts inside the bounding rectangle is
>>> reported if hardware provides the number but not the real contact
>>> positions" to the end of the paragraph.
>>
>> You might disagree, but "old" is still somewhat apt in this situation.
> 
> It's ok if we say the new type was inspired by legacy hardware. But
> saying that it "is only used for legacy hardware" closes the door for
> future development. That's not what we are trying to do, right?


Well, in a sense we are. I would agree that data aiming to provide gestures as a
2D transformation matrix can be handled quite well with two tracked points and a
finger count. However, a multitouch interface where users manipulate different
objects on the screen simultaneously is a different story.

> 
>> How would you suggest we report the number of fingers?
> 
> I guess if we want to make it generic, we could have something like
> ABS_MT_NUM_CONTACTS to go with MT_TOOL_ENVELOPE. Clients, such as
> synaptics touchpads, that only care about the number of contacts
> inside the envelope don't need to process the contact positions even
> when they are reported. This also resolve the potential that
> BTN_TOOL_QUADTAP is not enough to tell us how many contacts are on the
> surface.


I really would like to avoid adding a new way to solve an old problem, in
particular given the statement above. Adding something like BTN_TOOL_QUINTAP
would hurt a little bit, but not nearly as much.

> 
> Maybe we should also tell the clients whether they are going to get
> the contact positions or not.


I may not understand what you mean here, but if you are referring to an up-front
declaration of what MT_TOOL types are to be expected, we did discuss this
before, without any conclusion. Perhaps it is relevant to outline why this would
be important.

Thanks,
Henrik
