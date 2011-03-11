Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1CKBaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:30:08 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:52450 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab1CKBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:30:06 -0500
Message-ID: <8e40e6468e9cf03138a512550f1e519e.squirrel@webmail.greenhost.nl>
In-Reply-To: <yunr5ae4vjg.fsf@aiko.keithp.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
    <20110216192658.GA7225@blimp.localdomain>
    <20110217221329.GA3332@x61.home>
    <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
    <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
    <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
    <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
    <20110222130440.21a27714@jbarnes-desktop>
    <20110222223120.GA3567@x61.home>
    <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com>
    <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl>
    <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com>
    <1a06e2711df021a802d609ad1a75db17.squirrel@webmail.greenhost.nl>
    <s5h4o7btnxq.wl%tiwai@suse.de> <s5hy64ns7pq.wl%tiwai@suse.de>
    <a04bdafb8c7a97d92593e980b01b37fd.squirrel@webmail.greenhost.nl>
    <s5hr5afm8mj.wl%tiwai@suse.de> <yunr5ae4vjg.fsf@aiko.keithp.com>
Date: Fri, 11 Mar 2011 02:30:04 +0100 (CET)
Subject: Re: [PATCH] drm/i915: Revive combination mode for backlight control
From: "Indan Zupancic" <indan@nul.nu>
To: "Keith Packard" <keithp@keithp.com>
Cc: "Takashi Iwai" <tiwai@suse.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Alex Riesen" <raa.lkml@gmail.com>,
        "Tino Keitel" <tino.keitel@tikei.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>, stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 938925967a2432a0d8c7279c30be63be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 10, 2011 20:36, Keith Packard wrote:
> On Thu, 10 Mar 2011 14:02:12 +0100, Takashi Iwai <tiwai@suse.de> wrote:
>> +			val &= ~1;
>
> The reason for this is that some ancient platforms wire this bit to
> be "go to max backlight", or at least that's why this was in the 2D
> driver from which this code was derived.

If that is the case, then shouldn't it be at the end, after val *= lbpc?
I know it doesn't make much difference, as multiplying with an even number
always gives an even result, but it would make the intention clearer and
give a more precise result.

What about gen 3? Does it support combination mode too?

If you can confirm that there are no gen 2 systems with ASLE support,
we can remove the gen 2 check and only touch the PWM register, as the
ASLE code is the only one that changes the brightness. The panel code
only saves and restores it, and LBPC is saved and restored by the
BIOS already. Then those weird gen 2 quirks can be removed.

(Something for 2.6.39 perhaps.)

It's sad that something as simple as backlight control needs so much
code.

Greetings,

Indan


