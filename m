Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0LOUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:25:29 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:37427 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab0LOUZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:25:26 -0500
MIME-Version: 1.0
In-Reply-To: <4D08FB61.6000404@canonical.com>
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
	<20101214221241.GA11519@core.coreip.homeip.net>
	<4D080A13.6050601@canonical.com>
	<4D081BF2.7000202@euromail.se>
	<20101215072528.GB11867@core.coreip.homeip.net>
	<4D08FB61.6000404@canonical.com>
Date: Wed, 15 Dec 2010 14:25:25 -0600
Message-ID: <AANLkTinhadm_-Ms0gCJrabmQJOdoxxgEcxa=b0u9heML@mail.gmail.com>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:31 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/15/2010 02:25 AM, Dmitry Torokhov wrote:
>> On Wed, Dec 15, 2010 at 02:37:54AM +0100, Henrik Rydberg wrote:
>>> Hi Chase,
>>>
>>>>
>>>
>>>> I gave this some more thought, and I was close to accepting it with
>>>> documentation of the above restrictions. Then I thought of how the
>>>> following two devices would be presented to userspace:
>>>>
>>>> 1. A real MT device supporting up to 2 touches (e.g. a bamboo touch)
>>>>   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
>>>>   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
>>>>
>>>> 2. A partial MT device using MT_TOOL_ENVELOPE (e.g. synaptics MT)
>>>>   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
>>>>   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
>>>>
>>>> Note that they are identical! The range of values for each axis would be
>>>> identical too. The only way to tell the two apart would be to watch for
>>>> the ABS_MT_TOOL_TYPE axis.
>>
>> Question: does the driver really need to know this data beforehand?  I'd
>> expect MT-aware driver simply having handlers for both styles and then
>> doing the best it can with the data stream it gets... There should not
>> be ambiguity as to what event is - I believe we should be sending
>> BTN_TOOL_ENVELOPE even for the single/first contact for devices that do
>> not do full MT tracking.
>
> In XI 2.1 with MT, I would envision a partial MT device having different
> axis labels. We don't want to push an implementation specific
> abstraction, as MT_TOOL_ENVELOPE is, through the X protocol and require
> clients to watch the tool type. It should be readily apparent by the
> axis labels of the position valuators whether they represent true MT
> coordinates or a bounding rectangle of touches.
>
> As for whether clients will want to know if the device is real or
> partial MT, I think we should design a protocol that allows for a client
> to know. Maybe the application gives visual feedback on how to perform
> gestures depending on the device type?
>

Agree with these points.  From a configuration GUI perspective, I'd
want to show a subset of gestures can be performed on these partial
MT... or at least show a different video on how gesture must be
performed to be recognized.

So I think we do need to expose up front.

Chris
