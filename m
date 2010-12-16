Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0LPO5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:57:02 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:62087 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0LPO47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:56:59 -0500
MIME-Version: 1.0
In-Reply-To: <20101215235900.GA4952@salty.local>
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
	<1292361672-2581-3-git-send-email-chase.douglas@canonical.com>
	<20101215235900.GA4952@salty.local>
Date: Thu, 16 Dec 2010 08:56:58 -0600
Message-ID: <AANLkTinjHuOv=sd_C-e1OLXuH_AS0YU_Hfj77zien27F@mail.gmail.com>
Subject: Re: [PATCH 2/4] Documentation: Add evdev type and code definitions
From: Chris Bagwell <chris@cnpbagwell.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 5:59 PM, Peter Hutterer
<peter.hutterer@who-t.net> wrote:
> On Tue, Dec 14, 2010 at 01:21:10PM -0800, Chase Douglas wrote:
>> This commit adds the file Documentation/input/evdev-codes.txt.
>>
>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> ---
>>  Documentation/input/evdev-codes.txt |  160 +++++++++++++++++++++++++++++++++++
>>  1 files changed, 160 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/input/evdev-codes.txt
>>
>> diff --git a/Documentation/input/evdev-codes.txt b/Documentation/input/evdev-codes.txt
>> new file mode 100644
>> index 0000000..69c810f
>> --- /dev/null
>> +++ b/Documentation/input/evdev-codes.txt
>> @@ -0,0 +1,160 @@
>> +The evdev protocol uses a map of types and codes to express input device values
>> +to userspace. This document describes the types and codes and how and when they
>> +may be used.
>> +
>> +Types:
>> +==========
>> +Types are groupings of codes under a logical input construct. Each type has a
>> +set of applicable codes to be used in generating events. See the Codes section
>> +for details on valid codes for each type.
>> +
>> +* EV_SYN:
>> +  - Used as markers to separate events. Events may be separated in time or in
>> +    space, such as with the multitouch protocol.
>> +* EV_KEY:
>> +  - Used to describe keyboard and other key-like input events.
>> +* EV_REL:
>> +  - Used to describe relative input events, e.g. moving the mouse 5 units to the
>> +    left.
>> +* EV_ABS:
>> +  - Used to describe absolute input events, e.g. describing the coordinates of a
>> +    touch on a touchscreen.
>> +* EV_MSC:
>> +  - Used to describe miscellaneous input events that do not fit into other
>> +    types.
>> +* EV_SW:
>> +  - Used to describe binary state input switches.
>> +* EV_LED:
>> +  - Used to turn LEDs on devices on and off.
>> +* EV_SND:
>> +  - Used to output sound to devices.
>> +* EV_REP:
>> +  - Used for autorepeating devices.
>> +* EV_FF:
>> +  - Used to send force feedback commands to an input device.
>> +* EV_PWR:
>> +  - A special type for power button and switch input.
>> +* EV_FF_STATUS:
>> +  - Used to receive force feedback device status.
>> +
>> +Codes:
>> +==========
>> +Codes define the precise type of event.
>> +
>> +EV_SYN Codes:
>> +----------
>> +EV_SYN event values are undefined. Their usage is
>> +defined only by when they are sent in the evdev event stream.
>> +
>> +* SYN_REPORT:
>> +  - Used to synchronize and separate events in time. For example, motion of a
>> +    mouse may set the REL_X and REL_Y values for one motion, then emit a
>> +    SYN_REPORT. The next motion will emit more REL_X and REL_Y values and send
>> +    another SYN_REPORT.
>> +* SYN_CONFIG:
>> +  - TBD
>> +* SYN_MT_REPORT:
>> +  - Used to synchronize and separate touch events. See the
>> +    multi-touch-protocol.txt document for more information.
>> +
>> +EV_KEY:
>> +----------
>> +EV_KEY events take the form KEY_<name> or BTN_<name>. For example, KEY_A is used
>> +to represent the 'A' key on a keyboard. When a key is depressed, an event with
>> +the key's code is emitted with value 1. When the key is depressed, an event is
>> +emitted with value 0. In general, KEY_<name> is used for keyboard keys, and
>> +BTN_<name> is used for other types of momentary switch events.
>
> repeat keys have value 2, might want to add this here.
>
>> +
>> +A few EV_KEY codes have special meanings:
>> +
>> +* BTN_TOOL_<name>, BTN_TOUCH:
>> +  - These codes are used in conjunction with input trackpads, tablets, and
>> +    touchscreens. These devices may be used with fingers, pens, or other tools.
>> +    When an event occurs and a tool is used, the corresponding BTN_TOOL_<name>
>> +    code should be set to a value of 1. When the tool is no longer interacting
>> +    with the input device, the BTN_TOOL_<name> code should be reset to 0. All
>> +    trackpads, tablets, and touchscreens should use at least one BTN_TOOL_<name>
>> +    code when events are generated. For non-tablet devices, the tool is usually
>> +    BTN_TOUCH.
>
> BTN_TOUCH is used as proximity delimiter. e.g. wacom sends BTN_TOOL_PEN when
> the pen comes into proximity and (in addition) BTN_TOUCH when the pen
> actually touches the tablet. synaptics does the same IIRC except that it
> doesn't support hovering, so BTN_TOOL_FINGER and BTN_TOUCH are always
> set/unset in the same EV_SYN frame.

This area is where most special cases are so somehow I think it
deserves extra attention.  Either in paragraphs or in sample events.

There is the special historical case of touchscreen were
BTN_TOOL_FINGER is not sent; which mostly works because most
touchscreens do not support proximity/hover concepts.  It can
recommend not to use this approach and to use new ioctl() to convey
touchscreen vs. touchpad information.

Just an FYI: Synaptics is only sending BTN_TOUCH when pressure is >30
for what ever historical reason (and duplicating logic in
xf86-input-synaptics) so it usually won't be in same sync window as
BTN_TOOL_FINGER.  I think its only touchpad left doing this so I think
we may want to recommend best practice is to have BTN_TOOL_FINGER/*TAP
and BTN_TOUCH track each other when hover is not supported.

>
>
>> +
>> +* BTN_TOOL_FINGER, BTN_TOOL_DOUBLETAP, BTN_TOOL_TRIPLETAP, BTN_TOOL_QUADTAP:
>> +  - These codes denote one, two, three, and four finger interaction on a
>> +    trackpad or touchscreen. For example, if the user uses two fingers and moves
>> +    them on the touchpad in an effort to scroll content on screen,
>> +    BTN_TOOL_DOUBLETAP should be set to value 1 for the duration of the motion.
>> +    Note that these codes and the BTN_TOOL_<name> and BTN_TOUCH codes are
>> +    orthogonal in purpose. A trackpad event generated by finger touches should
>> +    generate events for one code from each group.

We should probably recommend a best practice here.  Almost all drivers
today send only 1 of BTN_TOOL_FINGER/*TAP today.  For example, if 1
touch then BTN_TOOL_FINGER=1 and BTN_TOOL_DOUBLETAP=0 and during 2
touch then BTN_TOOL_FINGER=0 and BTN_TOOL_DOUBLETAP=1.

I think at least 1 driver sends them concurrently today and you must
look for highest finger count tool.  I'm pretty sure historically a
lot of the drivers sent them concurrently as well.

>> +
>> +* KEY_SUSPEND, KEY_POWER:
>> +  - These codes are reserved for the EV_PWR type.
>> +
>> +EV_REL:
>> +----------
>> +EV_REL events describe relative changes in a property. For example, a mouse may
>> +move to the left by a certain number of units, but its absolute position in
>> +space is unknown. If the absolute position is known, EV_ABS codes should be used
>> +instead of EV_REL codes.
>> +
>> +A few EV_REL codes have special meanings:
>> +
>> +* REL_WHEEL, REL_HWHEEL:
>> +  - These codes are used for vertical and horizontal scroll wheels,
>> +    respectively.
>
> I'm not sure they're special, other than in X where we still treat them as
> buttons by convention. It's good to describe them here, just in case, but I
> wouldn't call that a "special meaning".
>
>> +
>> +EV_ABS:
>> +----------
>> +EV_ABS events describe absolute changes in a property. For example, a touchpad
>> +may emit coordinates for a touch location.
>> +
>> +A few EV_ABS codes have special meanings:
>> +
>> +* ABS_PRESSURE:
>> +  - Used to describe the pressure of a touch interaction on an input device.
>
> again, that's not really special IMO. it pretty much does what it says on
> the box :)

:-)

It may be worth noting though that this is optional event.  When it
doesn't exist then BTN_TOUCH indicates touch.  When it does exist then
this is preferred indication of touch and should be used to debounced
touches because of fact that majority of touchpad/touchscreen will
start detecting contact while hovering.  But then that leads to
optional ABS_DISTANCE...

Chris

>
> fwiw, I know that even though the documentation should be enough as-is,
> having a few simple examples are always really useful to form the picture in
> one's head. especially for newcomers who don't understand the basic concepts
> yet.
>
> just something like:
> "for example, an absolute device moving to a new position and pressing and
> releasing a button may send events like this:
> code            value
> -----------------------
> ABS_X           10
> ABS_Y           100
> BTN_LEFT        1
> EV_SYN          SYN_REPORT
> BTN_LEFT        0
> EV_SYN          SYN_REPORT
>
> This immediately makes it obvious that buttons and axes can be mixed in the
> same frame. you may want to also point to a few tools that show the event
> stream (evtest comes to mind as the most widely distributed).
>
> Cheers,
>  Peter
>
>> +* ABS_DISTANCE:
>> +  - Used to describe the distance of a tool from an interaction surface. This
>> +    should only be used while the tool is in close proximity of the device. If
>> +    the input device may be used freely in three dimensions, consider ABS_Z
>> +    instead.
>> +* ABS_MT_<name>:
>> +  - Used to describe multitouch input events. Please see
>> +    multi-touch-protocol.txt for details.
>> +
>> +EV_SW:
>> +----------
>> +EV_SW events describe stateful binary switches. For example, the SW_LID code is
>> +used to denote when a laptop lid is closed.
>> +
>> +EV_MSC:
>> +----------
>> +EV_MSC events are used for input and output events that do not fall under other
>> +categories.
>> +
>> +EV_LED:
>> +----------
>> +EV_LED events are used for input and output to set and query the state of
>> +various LEDs on devices.
>> +
>> +EV_REP:
>> +----------
>> +EV_REP events are used for specifying autorepeating events.
>> +
>> +EV_SND:
>> +----------
>> +EV_SND events are used for sending sound commands to simple sound output
>> +devices.
>> +
>> +EV_FF:
>> +----------
>> +EV_FF events are used to initialize a force feedback capable device and to cause
>> +such device to feedback.
>> +
>> +EV_PWR:
>> +----------
>> +EV_PWR events are a special type of key event used specifically for monitoring
>> +power buttons and switches. The two codes in use are:
>> +
>> +* KEY_POWER:
>> +  - Used to denote a power button event.
>> +* KEY_SUSPEND:
>> +  - Used to denote a suspend button event.
>> --
>> 1.7.1
>
