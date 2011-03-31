Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1CaUfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:35:33 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58191 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317Ab1CaUfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:35:32 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Organization: Texas Instruments, Inc.
References: <201103301906.42429.arnd@arndb.de>
	<alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6>
	<87d3l7jqpr.fsf@ti.com> <201103311723.02301.arnd@arndb.de>
Date: Thu, 31 Mar 2011 13:35:26 -0700
In-Reply-To: <201103311723.02301.arnd@arndb.de> (Arnd Bergmann's message of
	"Thu, 31 Mar 2011 17:23:01 +0200")
Message-ID: <87y63vav01.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Thursday 31 March 2011, Kevin Hilman wrote:
>> Some SoCs families (like OMAP) have huge amount of diversity even within
>> the SoC family, so better abstractions and generic infrastrucure
>> improvements are an obvious win, even staying within the SoC.
>
> But that's the point. The incentive is there for managing the infrastructure
> within the SoC, but not across SoCs. 

OK, but the rest of my thread went on to describe how at least a few ARM
SoC maintainers are actually actively working infrastructure that is
cross SoC, like runtime PM.  It might start because of an abstraction
within an SoC family like supporting both SH and SH-mobile, or
OMAP[12345], but it does sometimes result in not only cross-SoC code but
cross-platform frameworks.

Admiteddly, the percentage of ARM SoC developers actively working on
these common, cross-platform infrastructure layers is rather small, but
at least it is non-zero. :)    

> Allow me to use OMAP as a bad example while pointing out that it's
> really one of the best supported platforms we currently have, while
> the others are usually much worse in terms of working with the
> community (or at least they are behind on the learning curve but
> getting there):
>
> * OMAP2 introduced the hwmod concept as an attempt to reduce duplication
 >   between board code, but the code was done on the mach-omap2 level
>   instead of finding a way to make it work across SOC vendors, or using
>   an existing solution.

Well, before deciding whether something like hwmod should be a cross-SoC
abstraction, it's important to be clear about what level of abstraction
is needed, or practical for a given feature.  For power management, we
already have (and use) existing abstractions for the drivers.  The clock
framework, system PM and runtime PM framework are all existing
abstraction layers for drivers.

Remember that power management is one of those areas that ARM SoC
vendors like to "differentiate" on, so the hardware is vastly different
between ARM vendors.  Having worked on embedded Linux power management
for a while now, I currently do not think any cross-SoC abstractions
below the clock framework or runtime PM are worth it.  I'm certainly
willing to be pursuaded otherwise, but currently don't see the
usefulness.

With that as background, hwmod was never inteded as something to be
cross-SoC.  If you look at the data that's in an omap_hwmod, it's
entirely OMAP hardware specific, and mostly focused on power management
hardware details, register descriptions, feature capabilities etc.  This
allows the OMAP PM core code to be generalized and work across all SoCs
in the OMAP family.  But again, it was intended for OMAP PM core code.
At that level, there really isn't much to share with other SoCs since
the PM hardware for the various SoC vendors is so "differentiated"
(a.k.a fsck'd up in extremely different ways.)

Kevin
