Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2KMSI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:08:58 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:46296 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KMSI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:08:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121113180453.GA3622@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
	<1352306256-12180-12-git-send-email-benjamin.tissoires@gmail.com>
	<20121113164239.GA712@polaris.bitmath.org>
	<CAN+gG=EbAdfOG_vwt2uamV+JcAKLFqM=zTo9oRQ9RLayrpdsoA@mail.gmail.com>
	<20121113180453.GA3622@polaris.bitmath.org>
Date: Tue, 13 Nov 2012 19:08:55 +0100
Message-ID: <CAN+gG=HyDrr7mWsYGFue_xuzX0xm45n1EDpsDgU1RKJ8SkuP9Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] HID: hid-multitouch: support for hovering devices
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 7:04 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> > Why [-1,1] here?
>>
>> At first, I only used [0,1]. However, it's still the same problem with
>> the information being kept between the touches:
>> if you start an application after having touched your device, you
>> normally have to ask for the different per-touche states to get x, y,
>> distance, pressure, etc...
>> However, this is not much mandatory because the protocol in its
>> current form ensures that you will get the new states of the axes when
>> a new touch occurs.
>
> Right, the stateful communication requires a full state read after
> opening the deivce, although in most cases this is not really
> necessary. This is no different for ABS_MT_DISTANCE, of course.
>
>> ABS_MT_DISTANCE is a little bit different here because the protocol
>> guarantees that once you get the "not in range" state through
>> tracking_id == -1, distance should be 1.
>> When the new touch of the very same slot occurs, you also have the
>> guarantee that distance is at 1 too.
>
> ABS_MT_DISTANCE is just another attribute of the slot, so it really is
> no different.
>
>> So basically, if you don't ask for the slot states, you will never get
>> that very first distance.
>
> Which will not be important either; as long as the slot is unused, it
> does not matter what the attributes of that slot are.

And if the slot is unused, but has been used since the plug of the
device, the state is kept between the touch.

>
>> I know that it's a user-space problem, but honestly, I don't want to
>> fix several user-space problems when we could fix it through the
>> protocol.
>>
>> I can see 2 solutions:
>> - set the range to: [0,1] and still sending -1 (or 2) for the invalid
>> distance value (if it's not clamped)
>> - set the range to: [0,2] and having: 0 for touch, 1 for hovering, and
>> 2 for not in range
>>
>> Does that make sense?
>
> I just do not see what problem you want to solve here.

I just intend to force the update of the distance value at the
beginning of the touch.
This is just to send a coherent state when the finger goes in range,
and to make sure that user-space application do not rely on the
undefined value (0) whereas the kernel thought it was set to 1.

Cheers,
Benjamin

>
> Thanks,
> Henrik
