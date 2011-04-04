Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1DDI0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:26:07 -0400
Received: from service87.mimecast.com ([94.185.240.25]:32768 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753848Ab1DDI0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:26:04 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>, Detlef Vollmann <dv@vollmann.ch>
In-Reply-To: <201104040259.26601.arnd@arndb.de>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <201104031726.37420.arnd@arndb.de>
	 <20110403160324.GA8050@n2100.arm.linux.org.uk>
	 <201104040259.26601.arnd@arndb.de>
Organization: ARM Ltd
Date: Mon, 04 Apr 2011 09:26:19 +0100
Message-ID: <1301905579.417.16.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 04 Apr 2011 08:25:52.0996 (UTC) FILETIME=[E96B2240:01CBF2A1]
X-MC-Unique: 111040409255707201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 02:59 +0200, Arnd Bergmann wrote:

> Abstracting sched_clock() to be run-time selected is something that
> needs to be taken care of. Maybe we could have a generic sched_clock
> implementation that is written on top of clocksource instead of jiffies,
> and always select that on architectures that have a decent clocksource.
> Are there any platforms on ARM where that would be a bad idea? I believe
> the main reaons why they are separate is that on x86 you can use the TSC
> for sched_clock in many cases where you cannot use it for clocksource.

I've proposed a mechanism for a run-time selectable sched_clock()
implementation as part of my A15 timer patch set:
http://www.spinics.net/lists/arm-kernel/msg116891.html
and more specifically patches #10 and #11.

I'm not completely pleased with it (the fact that it embeds a copy of
the generic sched_clock() to be used as a default is properly ugly), but
maybe this could be used as a base for further discussion.

Cheers,

	M.
-- 
Reality is an implementation detail.


