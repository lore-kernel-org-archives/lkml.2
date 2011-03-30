Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab1C3W0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:26:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932964Ab1C3W0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:26:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110330214437.GH18334@atomide.com>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <20110330214437.GH18334@atomide.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 15:20:10 -0700
Message-ID: <AANLkTikE5LXMkaSH4t4=DPvAOWXDh5Zyp0ESi=v2mra3@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 2:44 PM, Tony Lindgren <tony@atomide.com> wrote:
>>
>> That's ridiculous. It's entirely due to the whole f*cked-up arm ecosystem.
>
> Yeh there's no BIOS and there are no scannable busses.. Which leads
> to huge amount of data patches that show up in the diffstat.

Yes. And due to all the traditional embedded models, there's no
historical "platform" model at all, unlike pretty much all other
architectures. Sure, other architectures often have more than a single
platform, but there's usually at least a couple of standard ways of
doing things, and defined interfaces to figure out at least most of
the big issues.

The embedded world has always been painfully different, and arm is
just the most successful entry (by far) in that world.

So as a result, it's not just "no scannable busses", it's pretty much
_everything_ that you can't take for granted. The clock chip details
and crazy irq controllers are a symptom.

Now, I'm not a huge fan of ACPI and always point out how firmware
people inevitably get something wrong, but the _real_ reason I think
ACPI was such a broken idea is that it was basically used as an excuse
to break the PC "platform" notion - the fundamental problem with ACPI
was that it was a way to avoid making platform decisions, and let all
the hw crazies make bad decisions and then "fix them up" in ACPI.

So I always felt that Intel should just have documented the hardware
standard instead, and pushed that as the platform (which, in all
honesty, Intel has done for a lot of very successful things - PCI,
AHCI, USB etc etc are all examples of Intel creating those kinds of
hardware platform standards). ACPI allowed (and still allows) Sony and
others to make crazy ad-hoc decisions about some random motherboard
device, and just encouranges _bad_ hardware without enumeration or
good high-level rules.

But for ARM, I suspect even ACPI would actually be an improvement.
Because on ARM, the crazy non-platform hw people already happened, and
took over the insane asylum.  So having a complicated description
language with an interpreter wouldn't be worse than what we already do
there.

I'm only half kidding. I wouldn't wish for ACPI even on ARM. But..

> Anyways, let's plan on kicking out per-SoC and per-board data from
> the kernel and get it from the bootloader via device tree in the
> long run. Most of the data is already separate from the code, so
> it should not be that hard to do, just takes some time.

This is basically my hope for the future. I just think that ARM people
should be very very aggressive about it, because the longer it isn't
done, the more crud there will be to convert.

I bet it will be painful to do. But it will be even more painful to
_not_ do it, and then five years from now realize that it should have
been done ten years ago.

                    Linus
