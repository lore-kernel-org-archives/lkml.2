Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab1CXTqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:46:00 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43560 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1CXTp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:45:57 -0400
Message-ID: <4D8B9F6F.5010705@canonical.com>
Date: Thu, 24 Mar 2011 15:45:51 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Bagwell <chris@cnpbagwell.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Documentation: Add evdev type and code definitions
References: <1300988652-25353-1-git-send-email-chase.douglas@canonical.com> <AANLkTimv3ZVQmgB-tbMthCYdEsK3Spk0WY9Vs9VLQEVs@mail.gmail.com>
In-Reply-To: <AANLkTimv3ZVQmgB-tbMthCYdEsK3Spk0WY9Vs9VLQEVs@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 02:44 PM, Chris Bagwell wrote:
> Looking good.  Minor comments at end.
> 
> On Thu, Mar 24, 2011 at 12:44 PM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>> +Touchscreens:
>> +----------
>> +ABS_{X,Y} must be reported with the location of the touch. BTN_TOUCH must be
>> +used to report when a touch is active on the screen.
>> +BTN_{MOUSE,LEFT,MIDDLE,RIGHT} must not be reported. BTN_TOOL_<name> events
>> +should be reported where possible.
> 
> Does the real button event restriction solve something?  I know
> majority of touchscreens are not sending a button today but usually
> there is a button on the touchscreen frame that I'd image at least
> some devices hooking it up to touchscreen interface.
>
> stylus+touchscreen combo devices are surely going to want to do this.

Perhaps this should be more clearly for touchscreen-only devices (not
tablets or a mix). The problem we end up seeing is drivers who use
BTN_LEFT because they want a touch to generate a primary button press in
X. I want to prevent people from doing this.

I believe mixed devices are hard to detect between tablets and
stylus+touchscreen right now, as evidenced by the X evdev driver not
handling the former by default while wacom is often used for the latter.
However, with the device properties a userspace driver should be able to
tell the two apart.

I'll rename this guideline: Touchscreens without stylus tools. Any issues?

>> +
>> +Trackpads:
>> +----------
>> +Legacy trackpads that only provide relative position information must report
>> +events like mice described above.
>> +
>> +Trackpads that provide absolute touch position must report ABS_{X,Y} for the
>> +location of the touch. BTN_TOUCH should be used to report when a touch is active
>> +on the trackpad. Where multi-finger support is available, BTN_TOOL_<name> should
>> +be used to report the number of touches active on the trackpad.
> 
> How about a Tablet?
> 
> Something like:
> 
> Tablets:
> --------
> 
> BTN_TOOL_<name> events must be reported when a stylus or other tool is
> active on tablet.  ABS_{X,Y} must be reported with the location of the
> tool. BTN_TOUCH should be used to report when the tool is in contact
> with the tablet. BTN_{STYLUS,STLUS2} should be used to report buttons
> on tool itself and BTN_{LEFT,MIDDLE,RIGHT,1,2,etc} should be used to
> report buttons on tablet.

Thanks for the addition! I'll add it in and add you on a SOB line if
that's alright with you.

> Some tablets send ABS_PRESSURE with no BTN_TOUCH (why I said should
> instead of must).  Probably this is not worth mentioning here?

Yeah, I'd leave that off as I think we want to set the guidelines to use
BTN_TOUCH.

Thanks,

-- Chase
