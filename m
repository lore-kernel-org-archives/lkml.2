Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0LORsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:48:09 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60229 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0LORsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:48:06 -0500
Message-ID: <4D08FF4F.1020307@canonical.com>
Date: Wed, 15 Dec 2010 12:47:59 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - add multitouch packet support
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se> <4D06A7B1.6060609@canonical.com> <4D06A90C.90009@euromail.se> <4D07E38C.4020201@canonical.com> <4D08CEE8.9080804@euromail.se>
In-Reply-To: <4D08CEE8.9080804@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 09:21 AM, Henrik Rydberg wrote:
>> After some testing this is mostly fine,
> 
>  but I have one of those terrible
>> "integrated buttons" (or whatever we call it) trackpads. When switching
>> to multitouch mode, the cursor will sometimes jump when I go to push the
>> button.
>>
>> Take the following sequence:
>>
>> 1. Touch in top right corner of pad to position cursor
>> 2. Touch in bottom left corner over button
>> 3. Press button, but finger moves a little
>>
>> Step 3 causes the primary coordinates in the synaptics MT protocol to
>> flip to the button-pressing touch. This causes a cursor jump. *Many*
>> times I have gone to press an "Ok" dialog button and found that I
>> accidentally launched an application from my dock :).
> 
> 
> I see - the behavior of the primary coordinates seems to vary between models,
> then. On the other hand, if you point and click with the same finger, one could
> possibly go around this problem, even though it means less precision. On my MT
> laptop, I can click at the very edge of the pad without the cursor moving.

Because of the mechanical properties of my particular touchpad, it's
nearly impossible to click without dragging. My touchpad isn't one of
the new clickpads where the entire pad hinges. On a clickpad, I would
hope depress without movement is easy. On my trackpad, the buttons are
somewhat stiff and flex non-uniformly, causing the unwanted movement.

So, in Ubuntu we mask out the area of the touchpad where the buttons
are. Any movement in that area is discarded. Thus, the only way to be
sure of a click is to position with one touch, then lift the touch, then
click one of the buttons. Annoying :).

>> I think we should perform some rudimentary touch tracking to ensure the
>> same touch is always used for reporting ABS_X/ABS_Y. A simple distance
>> comparison between the two touches, as I implemented in one of my other
>> patches, would suffice.
> 
> 
> One can certainly decide on the "best" coordinates when putting down the second
> finger, as we tried for elantech. However, after some movement, when the second
> finger is lifted, chances are you get a jump then instead.

Chris, isn't this filtered out in xf86-input-synaptics based on the
change in the number of touches?

>> What do you think?
> 
> 
> The general approach we have taken for the kernel is to provide a left button
> for both the macbooks and these clickpads, and in addition provide enough
> information (read mt data) to solve this problem in userspace. In other words,
> one should probably see what additions are needed in the common X drivers to
> make the experience a pleasant one.

I think we're confusing clickpads and my "integrated buttons" trackpad
(I know we settled on a different name, but I can't remember it now :).
I believe my issue is purely due to the primary coordinates switching
back and forth between two touches as I position and click with two fingers.

Also, I have been told by an OEM partner that my trackpad will *never*
be used again :). We could consider quirking it if what makes this
trackpad work is detrimental to other trackpads.

Thanks,

-- Chase
