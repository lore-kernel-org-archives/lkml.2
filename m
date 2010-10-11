Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0JKNlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:41:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54781 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab0JKNlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <4CB2C154.5060303@euromail.se>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
	<s5hfwwg4p4t.wl%tiwai@suse.de>
	<1286558135.22715.162.camel@mini>
	<201010081104.01527.dmitry.torokhov@gmail.com>
	<s5h62xc4h2l.wl%tiwai@suse.de>
	<20101010210434.GC18455@core.coreip.homeip.net>
	<s5hy6a52ndd.wl%tiwai@suse.de>
	<4CB2C154.5060303@euromail.se>
Date: Mon, 11 Oct 2010 08:41:44 -0500
Message-ID: <AANLkTi=VTq+3-t4taR_22E1Wkos+yeHdMDkHd-Zc9Cbs@mail.gmail.com>
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Takashi Iwai <tiwai@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 2:48 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On 10/11/2010 09:35 AM, Takashi Iwai wrote:
> [...]
>
>> In anyway, feel free to add my sign-off there since I already posted
>> my own one as a reference.
>>
>> But, I have an open issue with Chase's patch.  Maybe it's rather a
>> question to Henrik:
>>
>> Shouldn't all points be reported as ABS_MT_* events?  So far, only the
>> second touch-point is reported via ABS_MT_* while the first  point is
>> still reported as ABX_[X|Y].
>>
>> I corrected this in my patch I posted, but I wasn't sure, too.
>
>
> I have issues with all submitted patches, but did not give explicit reasons
> since there were overlapping submissions. Perhaps Chase and yourself can work
> out how you want to submit the new patches? And yes, all points should be
> reported as ABS_MT events.
>
> Thanks,
> Henrik
>

And is it also safe to say that we need to continue to report
ABS_X/ABS_Y *and* those values need to always track 1st finger touch
for backwards compatibility?

It was brought up in thread but not stated as strong requirement.

BTW, there are patches in last couple months to x86-input-synaptics
that will allow it to ignore jumps in values of ABS_X/ABS_Y when
transition of multi-touch occur (both adding or removing fingers via
BTN_TOOL_*TAP).  So one new-ish option is for ABS_X/ABS_Y to not track
1st finger but become average of 2 fingers.

Chris
