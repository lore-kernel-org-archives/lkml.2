Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1AGUe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:34:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43200 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1AGUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:34:54 -0500
Message-ID: <4D2778E7.4000201@canonical.com>
Date: Fri, 07 Jan 2011 15:34:47 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Documentation: Add evdev type and code definitions
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com> <1292361672-2581-3-git-send-email-chase.douglas@canonical.com> <20101215235900.GA4952@salty.local>
In-Reply-To: <20101215235900.GA4952@salty.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 06:59 PM, Peter Hutterer wrote:
> On Tue, Dec 14, 2010 at 01:21:10PM -0800, Chase Douglas wrote:
>> +EV_KEY events take the form KEY_<name> or BTN_<name>. For example, KEY_A is used
>> +to represent the 'A' key on a keyboard. When a key is depressed, an event with
>> +the key's code is emitted with value 1. When the key is depressed, an event is
>> +emitted with value 0. In general, KEY_<name> is used for keyboard keys, and
>> +BTN_<name> is used for other types of momentary switch events.
> 
> repeat keys have value 2, might want to add this here.

Done.

>> +* BTN_TOOL_<name>, BTN_TOUCH:
>> +  - These codes are used in conjunction with input trackpads, tablets, and
>> +    touchscreens. These devices may be used with fingers, pens, or other tools.
>> +    When an event occurs and a tool is used, the corresponding BTN_TOOL_<name>
>> +    code should be set to a value of 1. When the tool is no longer interacting
>> +    with the input device, the BTN_TOOL_<name> code should be reset to 0. All
>> +    trackpads, tablets, and touchscreens should use at least one BTN_TOOL_<name>
>> +    code when events are generated. For non-tablet devices, the tool is usually
>> +    BTN_TOUCH.
> 
> BTN_TOUCH is used as proximity delimiter. e.g. wacom sends BTN_TOOL_PEN when
> the pen comes into proximity and (in addition) BTN_TOUCH when the pen
> actually touches the tablet. synaptics does the same IIRC except that it
> doesn't support hovering, so BTN_TOOL_FINGER and BTN_TOUCH are always
> set/unset in the same EV_SYN frame.

I've added wording for this.

>> +* REL_WHEEL, REL_HWHEEL:
>> +  - These codes are used for vertical and horizontal scroll wheels,
>> +    respectively.
> 
> I'm not sure they're special, other than in X where we still treat them as
> buttons by convention. It's good to describe them here, just in case, but I
> wouldn't call that a "special meaning".

In my mind I thought people may confuse this with a generic knob input
device. I've seen these in the local Apple store, and I believe they are
used primarily for professional a/v editing to go forward and backward
in time. I don't believe such devices should be using either of these
codes, so I defined the codes to be for scroll wheels.

Any objections?

>> +* ABS_PRESSURE:
>> +  - Used to describe the pressure of a touch interaction on an input device.
> 
> again, that's not really special IMO. it pretty much does what it says on
> the box :)

I think I had something in mind for this like the above REL_WHEEL, but I
can't think of it now. After re-reading this description, I don't think
it yields any new information that can't be gleaned from the code name
itself, so I've yanked it from the document.

> fwiw, I know that even though the documentation should be enough as-is,
> having a few simple examples are always really useful to form the picture in
> one's head. especially for newcomers who don't understand the basic concepts
> yet.
> 
> just something like:
> "for example, an absolute device moving to a new position and pressing and
> releasing a button may send events like this:
> code            value
> -----------------------
> ABS_X           10
> ABS_Y           100
> BTN_LEFT        1
> EV_SYN          SYN_REPORT
> BTN_LEFT        0
> EV_SYN          SYN_REPORT
> 
> This immediately makes it obvious that buttons and axes can be mixed in the
> same frame. you may want to also point to a few tools that show the event
> stream (evtest comes to mind as the most widely distributed).

I would like to see this as well, but I think I'll leave the initial
commit to just the protocol documentation. We should add these in a
subsequent commit (and I'm running out of time at the moment :).

Thanks!

-- Chase
