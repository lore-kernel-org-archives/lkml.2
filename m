Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1CaOnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:43:20 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47602 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab1CaOnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:43:18 -0400
From: Kevin Hilman <khilman@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Organization: Texas Instruments, Inc.
References: <201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<alpine.LFD.2.00.1103301531420.28032@xanadu.home>
	<AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
	<alpine.LFD.2.00.1103301814250.28032@xanadu.home>
	<alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
	<alpine.LFD.2.00.1103302255280.28032@xanadu.home>
	<alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
	<alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<20110331080634.GA18022@elte.hu>
	<20110331083044.GB14323@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6>
Date: Thu, 31 Mar 2011 07:43:12 -0700
In-Reply-To: <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6>
	(Thomas Gleixner's message of "Thu, 31 Mar 2011 14:04:16 +0200
	(CEST)")
Message-ID: <87d3l7jqpr.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> But the current SoC maintainer model does not work either. The SoC
> maintainers care about their sandbox and have exactly zero incentive
> to look at the overall picture, e.g reuse of code for the same IP
> blocks, better abstraction mechanisms etc. 

zero incentive?  that's a bit strong, IMO.

That may be true for some SoCs, it's not really fair as a sweeping
statement.

Some SoCs families (like OMAP) have huge amount of diversity even within
the SoC family, so better abstractions and generic infrastrucure
improvements are an obvious win, even staying within the SoC.

There are several examples of SoC maintainers looking at the overall
picture and contributing to better abstractions and common
infrastructure code.

One is USB as Felipe already pointed out where the same USB OTG IP block
(with vendor tweaks of course) is used across several completely
different SoCs with common infrastructure code.

Another example that I'm more familiar with is power management.  In
OMAP land, we have been been very supportive and active in generic
infrastructure improvements (like runtime PM.)  In fact runtime PM was
born partially because one of the other ARM SoC maintainers (Magnus
Damm, SH-mobile) proposed the idea as he was implementing PM for that
SoC family.  We have been actively contributing to the runtime PM
infrastructure with both code, testing, converting our drivers over to
using runtime PM. and contributing back fixes and enhancements as we
find problems or limitations.  In addition, personally, I have spent the
last year evangelizing the importance of using common frameworks like
runtime PM to the embedded community via talks at the Embedded Linux
Conference (ELC, US and Europe.)  Especially as IP blocks are reused
across SoC families, abstractions like runtime PM are the only way to
keep the SoC specifics of PM out of the common driver.

Yes, ARM SoC maintainers have to make up some ground.  But compare this
to just a couple years ago where the common complaint was "why aren't
embedded SoC people contributing code to mainline", and you'll see we
have come a long way.

Kevin

Maintainer of parts of the ARM kernel:
- TI Davinci SoC family
- TI OMAP Power Management infrastructure
