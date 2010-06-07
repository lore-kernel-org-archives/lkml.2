Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0FGF66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:58:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59650 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0FGF6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LBoSGM7OslfbDyiWexvm/i2PdnEOSxKh+khQlmBsiP15sR09B6HCdgjLK59moIeWo4
         BY5StdmNZeOJ4Ii3TpasLTOF+YWRhNOHAHdcZ3GRhYA+okPL4M8ppyOXKYvDkzXqRaFh
         gV4t4Dt/6Mv7S+ErPZ5yS2LaifeEmOOoDYwX8=
MIME-Version: 1.0
In-Reply-To: <AANLkTilD2n0QQrdN814XKAjDl5a_AbaRIZ0LUAOhKksL@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<AANLkTilD2n0QQrdN814XKAjDl5a_AbaRIZ0LUAOhKksL@mail.gmail.com>
Date: Mon, 7 Jun 2010 01:58:53 -0400
Message-ID: <AANLkTimdQJGXt3_7B47FNB3_1cTq9NazWZxR4HdShogj@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Alex Deucher <alexdeucher@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 11:04 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> [CC:Jeff+Tejun not removed, because you might want to look at the
> attached dmesgs]
>
> On Sun, Jun 6, 2010 at 4:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Sun, 6 Jun 2010, Torsten Kaiser wrote:
>>>
>>> The first problem that shows up is, that after the KMS switches to the
>>> correct video mode (1280x1024 for an DVI attached LCD), the display
>>> begins to flicker. Every 1..2 seconds (guesstimated) the display turns
>>> off and on again. Something in the new powersaving?
>>
>> Or maybe a borderline display timing that the display has trouble syncing
>> up with?
>
> With 2.6.34 and any previous KMS kernels the output was always stable.
> (I think, I switch to the radeon KMS on 2.6.32)
> The onscreen menu of the monitor showed 1280x1024@60.2Hz for
> 2.6.35-rc2, if I recall correctly.
> Now back on 2.6.34 its 1280x1024@59.9Hz.

The pm code shouldn't have any affect as your system only has one
power state, so it never kicks in.  It sounds like a display pll
problem, but there haven't been any changes to that code since 2.6.34.
 Any chance you could bisect it?

>
> Comparing the DRM output from 2.6.34 and 2.6.35-rc2 I see the
> following differences:
> On 2.6.35-rc2 this block is missing:
> [    1.907716] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
> [    1.913403] [drm] 1 Power State(s)
> [    1.916810] [drm] State 0 Default (default)
> [    1.921017] [drm]    16 PCIE Lanes
> [    1.924255] [drm]    1 Clock Mode(s)
> [    1.927662] [drm]            0 engine/memory: 325000/200000
> [    1.932496] [drm] radeon: power management initialized
> New on 2.6.35: [    1.951340] [TTM] Initializing pool allocator.
> Only on 2.6.34: [    2.011963] [drm] radeon: cp idle (0x10000C03)
> Only on 2.6.34: [    2.020478] platform radeon_cp.0: firmware: using
> built-in firmware radeon/R300_cp.bin
>
> On 2.6.34 the output for connector 1 is:
> [    2.090935] [drm] Connector 1:
> [    2.094002] [drm]   DVI-I
> [    2.096629] [drm]   HPD1
> [    2.099174] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
> [    2.105210] [drm]   Encoders:
> [    2.108189] [drm]     CRT2: INTERNAL_DAC2
> [    2.112222] [drm]     DFP1: INTERNAL_TMDS1
> With 2.6.35-rc2 the line 'HPD1' switches to 'NONE'
>

Whoops.  that's a typo in the print out.  I'll send Dave a patch to fix that.

Alex

> Everything else is identical. I have attached complete dmesg from both
> kernels to this mail.
>
> Torsten
>
