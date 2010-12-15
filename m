Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0LORbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:31:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56835 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0LORbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:31:22 -0500
Message-ID: <4D08FB61.6000404@canonical.com>
Date: Wed, 15 Dec 2010 12:31:13 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com> <20101214221241.GA11519@core.coreip.homeip.net> <4D080A13.6050601@canonical.com> <4D081BF2.7000202@euromail.se> <20101215072528.GB11867@core.coreip.homeip.net>
In-Reply-To: <20101215072528.GB11867@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 02:25 AM, Dmitry Torokhov wrote:
> On Wed, Dec 15, 2010 at 02:37:54AM +0100, Henrik Rydberg wrote:
>> Hi Chase,
>>
>>>
>>
>>> I gave this some more thought, and I was close to accepting it with
>>> documentation of the above restrictions. Then I thought of how the
>>> following two devices would be presented to userspace:
>>>
>>> 1. A real MT device supporting up to 2 touches (e.g. a bamboo touch)
>>>   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
>>>   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
>>>
>>> 2. A partial MT device using MT_TOOL_ENVELOPE (e.g. synaptics MT)
>>>   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
>>>   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
>>>
>>> Note that they are identical! The range of values for each axis would be
>>> identical too. The only way to tell the two apart would be to watch for
>>> the ABS_MT_TOOL_TYPE axis.
> 
> Question: does the driver really need to know this data beforehand?  I'd
> expect MT-aware driver simply having handlers for both styles and then
> doing the best it can with the data stream it gets... There should not
> be ambiguity as to what event is - I believe we should be sending
> BTN_TOOL_ENVELOPE even for the single/first contact for devices that do
> not do full MT tracking.

In XI 2.1 with MT, I would envision a partial MT device having different
axis labels. We don't want to push an implementation specific
abstraction, as MT_TOOL_ENVELOPE is, through the X protocol and require
clients to watch the tool type. It should be readily apparent by the
axis labels of the position valuators whether they represent true MT
coordinates or a bounding rectangle of touches.

As for whether clients will want to know if the device is real or
partial MT, I think we should design a protocol that allows for a client
to know. Maybe the application gives visual feedback on how to perform
gestures depending on the device type?

Thanks,

-- Chase
