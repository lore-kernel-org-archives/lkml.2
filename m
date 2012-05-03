Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2ECKGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:06:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39369 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2ECKGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
	<CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
	<alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
	<CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
Date: Thu, 3 May 2012 12:06:41 +0200
Message-ID: <CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 12:55 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Wed, May 2, 2012 at 10:45 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Wed, 2 May 2012, Benjamin Tissoires wrote:
>>
>>> > It's currently in a shape I would be okay to pushing out for -next and
>>> > scheduling for next merge window, and I will do so tomorrow if nothing
>>> > else pops up during testing or reviews.
>>>
>>> Hi Jiri,
>>>
>>> Well, I'm back in my lab this morning, and I'm testing your branch
>>> against the different devices we have here. I'm observing a strange
>>> problem: when connecting some devices, the first touch is always at
>>> 0,0. If I rmmod and insmod hid_multitouch it seems to work after....
>>>
>>> I'm investigating this bug now. I'll tell you when I'm done. I still
>>> don't now if it's related to Henrik's changes or 3.4-rc4.
>>
>> I see, thanks a lot for the heads-up, I will be waiting for your analysis
>> of this.
>>
>> I have already renamed the branch to 'device-groups' and merged it into
>> branch that goes into next, so please send me any followup patches on top
>> of that queue now.
>
> Ok, I think I understood: nothing related to Henrik's changes. The bug
> is also present in the upstream kernel.
> In the function set_last_slot_field, I was doing a:
> test_bit(usage->hid, hi->input->absbit);
>
> for instance, 0x10030 (X hid field) in the absbit bit field which
> contains only ABS_CNT (0x40) bits.... That's why it was a random bug.
> Now I understood why Ubuntu complained about this test ;-)
>
> I won't have the time to submit the patch right now, I have to give a
> lecture this afternoon. Maybe this evening or tomorrow.
>
> Cheers,
> Benjamin

Hi guys,

I'm currently on the bug fix I told you earlier. However, I found a
more problematic bug in the hid_groups functionality.

Some device, like the Perixx peripad, present several interfaces
(mouse, keyboard and multitouch).
The hid groups functionality detects the HID field Contact ID, and
then forwards all interfaces to hid-multitouch. The point is that
hid-multitouch does not know how to handle mice and keyboards, and
then fails handling the interfaces of the device.

This particular device is then fully broken (as anyone pumped the events).
I also noticed the same problem (but less problematic) with cypress
panels: it presents different vendor interfaces and they are handled
by hid-multitouch.

Sorry for spotting this that late,
Benjamin


>
>>
>> Thanks,
>>
>> --
>> Jiri Kosina
>> SUSE Labs
