Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1CKIai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:30:38 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:35390 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1CKIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:30:37 -0500
Message-ID: <b98da048b445e86006be4bae706a0247.squirrel@webmail.greenhost.nl>
In-Reply-To: <s5hei6erugz.wl%tiwai@suse.de>
References: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
    <s5hei6erugz.wl%tiwai@suse.de>
Date: Fri, 11 Mar 2011 09:30:27 +0100 (CET)
Subject: Re: drm/i915: Fix DPMS and suspend interaction for intel_panel.c
From: "Indan Zupancic" <indan@nul.nu>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Keith Packard" <keithp@keithp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 4c3c8b3d32e7d0cfaf2d58264fc1daa3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 11, 2011 08:23, Takashi Iwai wrote:
> [Removed stable-kernel from Cc]
>
> At Fri, 11 Mar 2011 02:35:45 +0100 (CET),
> Indan Zupancic wrote:
>>
>> drm/i915: Fix DPMS and suspend interaction for intel_panel.c
>>
>> When suspending intel_panel_disable_backlight() is never called,
>> but intel_panel_enable_backlight() is called at resume. With the
>> effect that if the brightness was ever changed after screen
>> blanking, the wrong brightness gets restored at resume time.
>>
>> Nothing guarantees that those calls will be balanced, so having
>> backlight_enabled makes no sense, as the real state can change
>> without the panel code noticing. So keep things as stateless as
>> possible.
>>
>> Signed-off-by: Indan Zupancic <indan@nul.nu>
>
> Indan, when you need a patch to be added to stable kernel, just put
> Cc to stable kernel around your sign-off line.  Then Greg will pick it
> up automatically once when the patch is merged to Linus tree.

Ah, okay. I'll do that in the future.

Reading through Documentation/stable_kernel_rules.txt I'm not
sure if this patch applies. It does fix a bug that bothers me
personally, but otherwise it's not very important.

> Anyway, the patch looks good to me.  A nice clean-up.

That was a nice side effect. I like it when fixing code makes
it cleaner. Unfortunately it didn't work for the LBPC thing,
but here it does. My combination removal patch hid this bug
accidentally because PWM was kept at max, it was the main
reason I thought something was horribly wrong with the LBPC
fiddling. But it was just improper state tracking, fixed by
this patch, and my combination removal patch was bogus. Oh
well.

> Reviewed-by: Takashi Iwai <tiwai@suse.de>
>
>
> thanks,
>
> Takashi
>

Greetings,

Indan


