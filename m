Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab0LORkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:40:11 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53246 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0LORkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:40:09 -0500
Message-ID: <4D08FD74.4060403@canonical.com>
Date: Wed, 15 Dec 2010 12:40:04 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@bitmath.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <4D0897F3.7040500@bitmath.org>
In-Reply-To: <4D0897F3.7040500@bitmath.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 05:26 AM, Henrik Rydberg wrote:
>>> Ping has touched upon this subject as well, from the pen & touch perspective.
>>> Generally, some ABS axes are actually enumerations, for which we have no
>>> direct abstraction. If we had a way to declare the used values for such
>>> enumerations, it would resolve these and possibly other issues.
> 
>> I think that presence of pen/touch can be detected by having
>> BTN_TOOL_PEN and BTN_TOOL_FINGER. However in this case the tool is
>> finger, so I do not think we should introduce BTN_TOOL_ENVELOPE. Maybe
>> this is another case where we should employ the proposed device flags?
> 
> Yes. Having something like INPUT_QUIRK_SEMI_MT might be enough, and we could
> drop the whole MT_TOOL_ENVELOPE circus. Chase, Peter, Chris, would you be
> comfortable with such a solution?

That sounds like a good solution to me. I believe it would resolve all
the issues I had.

As I attempted to write up more documentation, I thought of the
following. What do you think?

With regards to partial MT devices, if the device provides a single
valued property, such as pressure and tool type for synaptics, it may
only be provided through the traditional property semantics, i.e.
ABS_PRESSURE and BTN_TOOL_*. If the device provides multiple values for
a property, then ABS_MT_* types may be used as well to provide up to two
values, though the client should understand there's no direct
correlation between the slot's coordinates and the property. I could see
this being used to provide info on multiple tool types or a high and low
pressure.

Enforcing the above behaviour provides even more information about the
capabilities of the device based solely on the evdev codes published.

Thanks,

-- Chase
