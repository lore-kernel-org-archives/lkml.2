Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0FGGwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:52:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51668 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0FGGwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VbC6O0TLTd3LhEclFjVyTRnxN8lwfpQPzLdw3TVCcGxQ4KL0MHqSMoGW3YdQDWkjPs
         ap9icD9Tko+gbmoS5HyD+/I7bYu7RR23MsW0yZ96UA+aDQkRQaw/WCw6EoOF5BsYH+IB
         D6XdPUE0ELuqrlGkTPU6P8HUsAnFQNe+Lg5Fc=
MIME-Version: 1.0
In-Reply-To: <AANLkTilJYxYHc7yBsCATQviYmfeAkmEk4LK-ZGJHpMsx@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<AANLkTilD2n0QQrdN814XKAjDl5a_AbaRIZ0LUAOhKksL@mail.gmail.com>
	<AANLkTimdQJGXt3_7B47FNB3_1cTq9NazWZxR4HdShogj@mail.gmail.com>
	<AANLkTil-1OgnnzgL7U0PNQi4G8B2QFDa6BEH4mWqdkhL@mail.gmail.com>
	<AANLkTimjxjINEtM3rIHVk_prI-_UTgkpIVhgbQ0V6rG4@mail.gmail.com>
	<AANLkTilJYxYHc7yBsCATQviYmfeAkmEk4LK-ZGJHpMsx@mail.gmail.com>
Date: Mon, 7 Jun 2010 16:52:21 +1000
Message-ID: <AANLkTimbsgJ4BKIiwE-D1McBOIuxyQ14Qq-IUZR6aTmv@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Dave Airlie <airlied@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 4:32 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, Jun 7, 2010 at 2:22 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Mon, Jun 7, 2010 at 4:09 PM, Torsten Kaiser
>> <just.for.lkml@googlemail.com> wrote:
>>> On Mon, Jun 7, 2010 at 7:58 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>>> On Sun, Jun 6, 2010 at 11:04 AM, Torsten Kaiser
>>>> <just.for.lkml@googlemail.com> wrote:
>>>>> [CC:Jeff+Tejun not removed, because you might want to look at the
>>>>> attached dmesgs]
>>>>>
>>>>> On Sun, Jun 6, 2010 at 4:19 PM, Linus Torvalds
>>>>> <torvalds@linux-foundation.org> wrote:
>>>>>> On Sun, 6 Jun 2010, Torsten Kaiser wrote:
>>>>>>>
>>>>>>> The first problem that shows up is, that after the KMS switches to the
>>>>>>> correct video mode (1280x1024 for an DVI attached LCD), the display
>>>>>>> begins to flicker. Every 1..2 seconds (guesstimated) the display turns
>>>>>>> off and on again. Something in the new powersaving?
>>>>>>
>>>>>> Or maybe a borderline display timing that the display has trouble syncing
>>>>>> up with?
>>>>>
>>>>> With 2.6.34 and any previous KMS kernels the output was always stable.
>>>>> (I think, I switch to the radeon KMS on 2.6.32)
>>>>> The onscreen menu of the monitor showed 1280x1024@60.2Hz for
>>>>> 2.6.35-rc2, if I recall correctly.
>>>>> Now back on 2.6.34 its 1280x1024@59.9Hz.
>>>>
>>>> The pm code shouldn't have any affect as your system only has one
>>>> power state, so it never kicks in.  It sounds like a display pll
>>>> problem, but there haven't been any changes to that code since 2.6.34.
>>>>  Any chance you could bisect it?
>>>
>>> Not really. -rc1 did not boot for me (although if I disable v4l that
>>> might work), and there is this memory corruption error.
>>>
>>> Regarding the PLLs, did you see this mail? It contains the
>>> drm.debug=15 output from 2.6.34 and 2.6.35-rc2.
>>> http://lkml.org/lkml/2010/6/6/126
>>>
>>> The debug output from radeon_set_pll looks identical. But in 2.6.35 a
>>> call to [drm:radeon_legacy_tmds_int_dpms], seems new.
>>>
>>> The switchoff intervall is ~10 seconds, not 1..2 as I guessed in the first mail.
>>> Any idea if there is something in the KMS code that triggers at this intervall?
>>
>> The new mode probing code happens every 10 seconds, though we
>> shouldn't be turning anything on or off with it.
>>
>> So I suspect the DAC detection table might be doing bad things on your
>> hardware, we have had a problem where the dac detect table on one DAC
>> would turn the other one off which clearly wasn't what we wanted to
>> see.
>> ,
>
> The x300 is a non-atom card, so it uses the legacy load detection
> routines which do mess with some of the crtc regs.
>

Okay I see it now, I'm amazed that I was seeing this issue last week
and blaming it on something complete different and only seeing it on
one card.

I expect its the same problem I'll try and track down a proper fix for
it tomorrow.

Dave.
