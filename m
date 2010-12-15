Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0LOVNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:13:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44965 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0LOVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:13:10 -0500
Message-ID: <4D092F61.7000405@canonical.com>
Date: Wed, 15 Dec 2010 16:13:05 -0500
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
References: <4D0897F3.7040500@bitmath.org> <4D08FD74.4060403@canonical.com> <4D0918A8.6080207@bitmath.org>
In-Reply-To: <4D0918A8.6080207@bitmath.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 02:36 PM, Henrik Rydberg wrote:
>>>> I think that presence of pen/touch can be detected by having
> 
>>>> BTN_TOOL_PEN and BTN_TOOL_FINGER. However in this case the tool is
>>>> finger, so I do not think we should introduce BTN_TOOL_ENVELOPE. Maybe
>>>> this is another case where we should employ the proposed device flags?
>>>
>>> Yes. Having something like INPUT_QUIRK_SEMI_MT might be enough, and we could
>>> drop the whole MT_TOOL_ENVELOPE circus. Chase, Peter, Chris, would you be
>>> comfortable with such a solution?
>>
>> That sounds like a good solution to me. I believe it would resolve all
>> the issues I had.
> 
> 
> Sounds good.
> 
> 
>> As I attempted to write up more documentation, I thought of the
>> following. What do you think?
>>
>> With regards to partial MT devices, if the device provides a single
>> valued property, such as pressure and tool type for synaptics, it may
>> only be provided through the traditional property semantics, i.e.
>> ABS_PRESSURE and BTN_TOOL_*. If the device provides multiple values for
>> a property, then ABS_MT_* types may be used as well to provide up to two
>> values, though the client should understand there's no direct
>> correlation between the slot's coordinates and the property. I could see
>> this being used to provide info on multiple tool types or a high and low
>> pressure.
>>
>> Enforcing the above behaviour provides even more information about the
>> capabilities of the device based solely on the evdev codes published.
> 
> 
> Looks good, but I do not think we need to formalize all possibilities here, only
> the usage of MT data for bounding rectangle and ST data for finger count.
> Referring to the patch just sent: whenever INPUT_PROP_SEMI_MT is true, this
> behavior is expected. In the event of new odd hardware, the combination of a new
> property quirk and a documented recipe should do the trick.

Would you feel comfortable stating the above in less concrete terms, as
sort of a best practices guide? I'd like to know for this specific case
if you agree beyond ST finger count data, or if you feel we should do
something else like always provide as much data as possible in MT
properties? It's a real corner case, and I don't care too much one way
or another. I just don't want synaptics implemented one way, elantech
another, etc.

Thanks,

-- Chase
