Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0LOUlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:41:49 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:35748 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0LOUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <4D08FD74.4060403@canonical.com>
References: <4D0897F3.7040500@bitmath.org>
	<4D08FD74.4060403@canonical.com>
Date: Wed, 15 Dec 2010 14:41:43 -0600
Message-ID: <AANLkTik4aS4mA_yrEDiG0QRxHx2pJ+KGGMKEWSDep1CB@mail.gmail.com>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:40 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/15/2010 05:26 AM, Henrik Rydberg wrote:
>>>> Ping has touched upon this subject as well, from the pen & touch perspective.
>>>> Generally, some ABS axes are actually enumerations, for which we have no
>>>> direct abstraction. If we had a way to declare the used values for such
>>>> enumerations, it would resolve these and possibly other issues.
>>
>>> I think that presence of pen/touch can be detected by having
>>> BTN_TOOL_PEN and BTN_TOOL_FINGER. However in this case the tool is
>>> finger, so I do not think we should introduce BTN_TOOL_ENVELOPE. Maybe
>>> this is another case where we should employ the proposed device flags?
>>
>> Yes. Having something like INPUT_QUIRK_SEMI_MT might be enough, and we could
>> drop the whole MT_TOOL_ENVELOPE circus. Chase, Peter, Chris, would you be
>> comfortable with such a solution?
>
> That sounds like a good solution to me. I believe it would resolve all
> the issues I had.

Works for me as well.

>
> As I attempted to write up more documentation, I thought of the
> following. What do you think?
>
> With regards to partial MT devices, if the device provides a single
> valued property, such as pressure and tool type for synaptics, it may
> only be provided through the traditional property semantics, i.e.
> ABS_PRESSURE and BTN_TOOL_*. If the device provides multiple values for
> a property, then ABS_MT_* types may be used as well to provide up to two
> values, though the client should understand there's no direct
> correlation between the slot's coordinates and the property. I could see
> this being used to provide info on multiple tool types or a high and low
> pressure.
>
> Enforcing the above behaviour provides even more information about the
> capabilities of the device based solely on the evdev codes published.
>

I meant to mention: once your initial draft gets committed I would
love to help update it some.  I specifically want to show two example
usage.  1) touchpad as 1 to 3 touchs occur and show special
considerations to ABS_* that apps should handle.  2) a touchscreen
that supports a pen as well and show how tool change (finger to pen)
should work.  For both those examples, it would be interesting to
discuss how MT can be used concurrently (does pen in slot 0 and touch
in slot 1 make sense for example).

I think it will be invaluable to document this stuff for driver
writers and apps but I'm not sure yet what level needs to be enforced.

Chris
