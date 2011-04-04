Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1DDLEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 07:04:00 -0400
Received: from service87.mimecast.com ([94.185.240.25]:45744 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751741Ab1DDLD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 07:03:59 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Detlef Vollmann <dv@vollmann.ch>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, David Brown <davidb@codeaurora.org>,
        linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <201104040259.26601.arnd@arndb.de>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <201104031726.37420.arnd@arndb.de>
	 <20110403160324.GA8050@n2100.arm.linux.org.uk>
	 <201104040259.26601.arnd@arndb.de>
Organization: ARM Limited
Date: Mon, 04 Apr 2011 12:03:42 +0100
Message-ID: <1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 04 Apr 2011 11:03:45.0507 (UTC) FILETIME=[F7799B30:01CBF2B7]
X-MC-Unique: 111040412035103401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 01:59 +0100, Arnd Bergmann wrote:
> On Sunday 03 April 2011, Russell King - ARM Linux wrote:
> > Then there's those which change the cs->read function pointer at runtime,
...
> > and those which share that pointer with their sched_clock() implementation.
> 
> Abstracting sched_clock() to be run-time selected is something that
> needs to be taken care of. Maybe we could have a generic sched_clock
> implementation that is written on top of clocksource instead of jiffies,
> and always select that on architectures that have a decent clocksource.

On Cortex-A15 with the virtualisation extensions and architected timers
the clocksource is implemented using a physical counter (as we want
wall-clock timing). But for sched_clock() we may want to use a virtual
counter (which is basically an offset from the physical one, set by the
hypervisor during guest OS switching). Marc already posted some patches
for this.

-- 
Catalin


