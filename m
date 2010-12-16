Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0LPOli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:41:38 -0500
Received: from csmtp1.one.com ([195.47.247.21]:49271 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0LPOle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:41:34 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 09:41:34 EST
Message-ID: <4D0A251D.8060803@bitmath.org>
Date: Thu, 16 Dec 2010 15:41:33 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <4D0897F3.7040500@bitmath.org> <4D08FD74.4060403@canonical.com> <4D0918A8.6080207@bitmath.org> <4D092F61.7000405@canonical.com>
In-Reply-To: <4D092F61.7000405@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>

>>> With regards to partial MT devices, if the device provides a single
>>> valued property, such as pressure and tool type for synaptics, it may
>>> only be provided through the traditional property semantics, i.e.
>>> ABS_PRESSURE and BTN_TOOL_*. If the device provides multiple values for
>>> a property, then ABS_MT_* types may be used as well to provide up to two
>>> values, though the client should understand there's no direct
>>> correlation between the slot's coordinates and the property. I could see
>>> this being used to provide info on multiple tool types or a high and low
>>> pressure.
>>>
>>> Enforcing the above behaviour provides even more information about the
>>> capabilities of the device based solely on the evdev codes published.
>>
>>
>> Looks good, but I do not think we need to formalize all possibilities here, only
>> the usage of MT data for bounding rectangle and ST data for finger count.
>> Referring to the patch just sent: whenever INPUT_PROP_SEMI_MT is true, this
>> behavior is expected. In the event of new odd hardware, the combination of a new
>> property quirk and a documented recipe should do the trick.
> 
> Would you feel comfortable stating the above in less concrete terms, as
> sort of a best practices guide? I'd like to know for this specific case
> if you agree beyond ST finger count data, or if you feel we should do
> something else like always provide as much data as possible in MT
> properties? It's a real corner case, and I don't care too much one way
> or another. I just don't want synaptics implemented one way, elantech
> another, etc.


A driver can still choose to report ABS_MT_PRESSURE for instance, in which case
it is assumed to make sense for individual fingers/corners. For semi-mt devices,
it seems reasonable to go to the ST variants to collect information not provided
via the MT protocol. I see no immediate reason to specify beyond that point.

Thanks,
Henrik
