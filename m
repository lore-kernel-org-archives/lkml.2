Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1KQROY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:14:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42664 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1KQROW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:14:22 -0500
MIME-Version: 1.0
In-Reply-To: <s5hlirelndd.wl%tiwai@suse.de>
References: <s5hlirgm1kg.wl%tiwai@suse.de>
	<yunsjlnl1f6.fsf@aiko.keithp.com>
	<s5hlirelndd.wl%tiwai@suse.de>
Date: Thu, 17 Nov 2011 18:14:20 +0100
Message-ID: <CACTFLAOJqj_szhSDqGV2BdKP8pnD-jAdAdNGBzmL+kBnUSNHNg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
From: Daniel Mack <zonque@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 5:33 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 16 Nov 2011 22:15:41 -0800,
> Keith Packard wrote:
>>
>> On Wed, 16 Nov 2011 18:14:55 +0100, Takashi Iwai <tiwai@suse.de> wrote:
>>
>> > While refactoring of backlight control code in commit [a95735569:
>> > drm/i915: Refactor panel backlight controls], the handling of the bit
>> > 0 of duty-cycle was gone except for pineview.  This resulted in invalid
>> > register values for old chips like 915GM.  When the bit 0 is set, the
>> > backlight is turned off suddenly.
>>
>> I'm looking at the mentioned patch and I don't see how that managed to
>> correctly handle bit 0; is this the patch that managed to break this?
>
> Hrm, then I must have been confused.  The gen < 4 check (formerly
> !IS_I965G()) was firstly introduced in this refactoring.  I thought
> this was done before, but apparently not.
>
> Looking more carefully again, actually the IS_PINEVIEW() part (former
> IS_GND()) was introduced in the commit [078a033f: drm/i915: fix
> opregion backlight chip detect and range].  Thus the same bug must
> have been present even in the earlier version, but didn't come up by
> some reason.
>
> So, I'll have to correct the patch commit log.  Sorry for that.
>
> Now, a question is whether the condition (gen < 4) is really correct.
> I *guess* the original code in the refactoring was intended to cover
> it:
>        if (!IS_I965G(dev))
>                max &= ~1;
>
> But this rule wasn't applied to set_backlight().
> The bit-0-clear above implies that it's a similar behavior like
> pineview.  And indeed Daniel's machine with 915GM hits this problem.
> If the above rule should be applied to all places, it'd make more
> sense to handle both in the same way like pineview.
>
> Unfortunately I have no old machines to test this, and the only
> material to judge was Daniel's case.  (Is Harald's machine also
> 915GM?)

I can test more patches if you want me to, no problem. Just let me know.


Daniel
