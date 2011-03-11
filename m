Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1CKJGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:06:45 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:48632 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1CKJGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:06:35 -0500
Message-ID: <540c8e591f4cada4fb4646e69fd776e4.squirrel@webmail.greenhost.nl>
In-Reply-To: <b7da2f$qmkuio@fmsmga001.fm.intel.com>
References: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
    <b7da2f$qmkuio@fmsmga001.fm.intel.com>
Date: Fri, 11 Mar 2011 10:06:26 +0100 (CET)
Subject: Re: drm/i915: Fix DPMS and suspend interaction for intel_panel.c
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Keith Packard" <keithp@keithp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: a2d32f98be707cbcda8602d5fffa976a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 11, 2011 09:07, Chris Wilson wrote:
>> Nothing guarantees that those calls will be balanced, so having
>> backlight_enabled makes no sense, as the real state can change
>> without the panel code noticing. So keep things as stateless as
>> possible.
>
> The problem is wider than described since the BIOS/ACPI may modify
> the registers without notifying the driver, and we fail to honour
> any user requests whilst the panel is off. Also, there is the greater
> of problem that the PWM registers simply have no effect on many
> machines, and we need to make an ACPI call to adjust the backlight.

Actually, that makes more sense than what ASLE does: There you
have to make an ACPI call which generates the ASLE interrupt and
lets the driver change it, while the BIOS already knows how to
change the backlight, as it does it at boot.

Is the PWM totally ignored, or only when non-zero? Otherwise you
may need to clear bit 31 in BLC_PWM_CLT2 instead. That might be a
better way to enable/disable the backlight for gen >= 4 hardware
anyway, as you don't need to store the current backlight anymore.
But this is 2.6.39 material for sure.

> However, this behaviour has been there since the inception, we can
> wait until the next merge cycle.

I think it was introduced in 2.6.37, at least that when the backlight
problems started for me.

In my opinion this is a patch that fixes a bug by making the code
simpler, so I would merge it this cycle. I am uncertain whether
this bug is important enough to get fixed in stable too though.
Maybe once it has proven itself in 2.6.38 for a while. If you want
to fix it the next cycle then that's fine too, but only delays
things. I think at this point the backlight problems are known
well enough that the fix is obvious and low risk enough, but I've
sent too hasty patches before.

Greetings,

Indan


