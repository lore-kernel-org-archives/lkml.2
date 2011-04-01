Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1DAVKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:10:12 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56218 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383Ab1DAVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:10:10 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Detlef Vollmann <dv@vollmann.ch>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Organization: Texas Instruments, Inc.
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<201104011554.07924.arnd@arndb.de> <4D95E112.4020400@vollmann.ch>
	<201104011659.40443.arnd@arndb.de>
Date: Fri, 01 Apr 2011 14:10:04 -0700
In-Reply-To: <201104011659.40443.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 1 Apr 2011 16:59:40 +0200")
Message-ID: <87vcyxllub.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Friday 01 April 2011, Detlef Vollmann wrote:
>> On 04/01/11 15:54, Arnd Bergmann wrote:
>
>> > 9. All interesting work is going into a handful of platforms, all of which
>> >     are ARMv7 based.
>> Define interesting.
>
> The ones that are causing the churn that we're talking about.
> Platforms that have been working forever and only need to get
> the occasional bug fix are boring, i.e. not the problem.

I'm not sure I follow the ARMv7-only thinking either.  

Picking ARMv7 only would be a good way to avoid part of the problem, but
IMO, it doesn't really address the root causes.  Part of the ugliness of
the platform-specific hackery (and the "churn" to clean some of it up)
is precisely due to support for multiple ARM architecture versions, and
the various SoCs in a family that use them.  For example, linux-omap
supports OMAP1 (ARMv5), OMAP2 (ARMv6), OMAP3 (ARMv7) and OMAP4 (ARMv7
SMP), and OMAP2/3/4 in a single binary.

Also, since we've only very recently got to the point of being able to
support ARMv6 + ARMv7 UP & SMP in the same kernel, making a decision now
that only ARMv7 is important seems like a step backwards.  If the
ultimate goal is getting to a point where we have infrastrucure that can
be cross-SoC, surely this same infrastrucure should support multiple ARM
architecture revisions.

The kernel is only part of many open-source projects, and many of these
projects are still using older hardware because it's cheap, available
and hackable.  Supporting ARMv7 only might be a win for those selling
new hardware, but not necessarily a win for the broader open-source
community.

Kevin (obviously not speaking for my new employer)
