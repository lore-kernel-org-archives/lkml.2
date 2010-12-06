Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0LFW4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:56:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56154 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0LFW4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <4CFD40CD.1000304@canonical.com>
References: <1291224069-11770-1-git-send-email-rydberg@euromail.se>
	<4CFD2E15.50105@canonical.com>
	<AANLkTingU7pUSwt6myUYzDhMVWg7PqfFpftw_hjsE4iK@mail.gmail.com>
	<4CFD40CD.1000304@canonical.com>
Date: Mon, 6 Dec 2010 16:56:20 -0600
Message-ID: <AANLkTintG5Vbhh7gdWHvUYMSXcRr0k+KDtmnccyHz6j8@mail.gmail.com>
Subject: Re: [PATCH 3/3] input: mt: Move tracking and pointer emulation to
 input-mt (rev2)
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 2:00 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/06/2010 11:52 AM, Chris Bagwell wrote:
>> On Mon, Dec 6, 2010 at 12:40 PM, Chase Douglas
>> <chase.douglas@canonical.com> wrote:
>>> On 12/01/2010 09:21 AM, Henrik Rydberg wrote:
>>>> The drivers using the type B protocol all report tracking information
>>>> the same way. The contact id is semantically equivalent to
>>>> ABS_MT_SLOT, and the handling of ABS_MT_TRACKING_ID only complicates
>>>> the driver. The situation can be improved upon by providing a common
>>>> pointer emulation code, thereby removing the need for the tracking id
>>>> in the driver.  This patch moves all tracking event handling over to
>>>> the input core, simplifying both the existing drivers and the ones
>>>> currently in preparation.
>>>
>>> When two or more fingers are down, one of the fingers controls
>>> ABS_{X,Y}. I think the aim is to emulate current behavior for
>>> synaptics-style touchpads, which average the position in firmware. Thus,
>>> we should be averaging the touch positions to generate the ABS_{X,Y} values.
>>>
>>
>> At least for modern synaptics hardware, it does track to first touch
>> like this patch does.
>>
>> It is maybe a weighted average were its 90% first finger and 10%
>> second finger.  Just moving second finger gives slight movement.
>
> Ok. Does this present any usability issues, or does it seem to work fine
> in your opinion? If it works ok in normal use cases then I'm fine with
> how this is implemented.

Not averaging works fine in normal cases I've come up with.  It works
best with dumbest of apps (those that don't even want to process
DOUBLETAP) as they will not see cursor jumps.  It works fine for apps
that process DOUBLETAP and TRIPLETAP and specifically for tap and
swipe gestures where fingers are moving together anyways.  We can't
reliably detect pinch or rotate motions without exact second fingers
data so not much reason to show 2nd finger movement there.

Click-and-drag on those click-pads are their own topic though.  For
that case, I've tried to come up with something (show 2nd finger
movement by averaging or switch tracking) but either we will get a
cursor jump or else we will be confusing user land by sending a
DOUBLETAP when logically we want them to act as if 1 is touching.  I
think MT is best solution for those.

Chris
