Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1AGWD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:03:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40803 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1AGWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:03:56 -0500
Message-ID: <4D278DC6.7070209@canonical.com>
Date: Fri, 07 Jan 2011 17:03:50 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com> <20110107215353.GF28875@core.coreip.homeip.net>
In-Reply-To: <20110107215353.GF28875@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 04:53 PM, Dmitry Torokhov wrote:
> Hi Chase,
> 
> On Fri, Jan 07, 2011 at 04:28:15PM -0500, Chase Douglas wrote:
>> +
>> +* KEY_SUSPEND, KEY_POWER:
>> +  - These codes are reserved for the EV_PWR type.
>> +
> 
> This is not correct, KEY_SUSPEND and KEY_POWER are valid events for
> EV_KEY type. We need to figure out what to do with drivers who like to do
> EV_PWR/KEY_PWR though.
> 
> The whole EV_PWR business is iffy. IIRC/IIUC it was envisioned to semd
> powwer events _to_ the devices to implement device-level PM. We'll have
> to revisit it at some point.

Ahh. Ok, I'll remove this tidbit.

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
>> +  - These codes are used for vertical and horizontal scroll wheels,
>> +    respectively.
>> +
>> +EV_ABS:
>> +----------
>> +EV_ABS events describe absolute changes in a property. For example, a touchpad
>> +may emit coordinates for a touch location.
>> +
>> +A few EV_ABS codes have special meanings:
>> +
>> +* ABS_DISTANCE:
>> +  - Used to describe the distance of a tool from an interaction surface. This
>> +    should only be used while the tool is hovering, meaning in close proximity
>> +    of the device. If the input device may be used freely in three dimensions,
>> +    consider ABS_Z instead.
>> +
>> +* ABS_MT_<name>:
>> +  - Used to describe multitouch input events. Please see
>> +    multi-touch-protocol.txt for details.
>> +
>> +EV_SW:
>> +----------
>> +EV_SW events describe stateful binary switches. For example, the SW_LID code is
>> +used to denote when a laptop lid is closed.
> 
> Please add that drivers should refresh switch state upon binding to a
> device and also upon resume.

I've not written any switch evdev drivers, can you clarify what you
mean, maybe give me something to paste in?

Are you meaning that the switch state may have physically changed, and
that the driver should query the physical state to be sure, or do you
mean that the driver must send a new event even if the state has not
changed?

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
>> +  - Used to denote a power button event.
>> +
>> +* KEY_SUSPEND:
>> +  - Used to denote a suspend button event.
> 
> Just replace this with TBA for now.

Will do.

Thanks!

-- Chase
