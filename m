Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1BUVv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:51:29 -0500
Received: from www.tglx.de ([62.245.132.106]:45494 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1BUVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:51:27 -0500
Date: Mon, 21 Feb 2011 22:51:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, catalin.marinas@arm.com,
        glikely@secretlab.ca, jamie@jamieiles.com, linux-arch@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: CLOCK_TICK_RATE, was: Re: [PATCH V4 3/4] ARM: Xilinx: base header
 files and assembly macros
In-Reply-To: <201102212208.10231.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1102212250290.2701@localhost6.localdomain6>
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <201102211548.36296.arnd@arndb.de> <20110221151752.GR14495@n2100.arm.linux.org.uk> <201102212208.10231.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Arnd Bergmann wrote:

> On Monday 21 February 2011, Russell King - ARM Linux wrote:
> > Eg, LOW_RES_NSEC is exported to userspace via the posix clocks interface.
> > 
> > NSEC_PER_SEC and TICK_NSEC are used for cmos clock updates, so probably
> > don't matter too much there.  TICK_NSEC is also used by the scheduler,
> > time conversions (timespec/timeval to/from jiffies) and profiling code.
> > 
> > NSEC_PER_JIFFY is used by the jiffy clocksource code, which only matters
> > if you don't have your own clocksource.
> > 
> > So, I feel very uneasy about saying that CLOCK_TICK_RATE doesn't matter
> > anymore given all the places which reference something that's derived
> > from it.
> 
> All the calculations based off of CLOCK_TICK_RATE are derived from ACTHZ,
> which is either the correct value based on the underlying HW timer tick,
> or slightly off, when either the HW tick or the value of CLOCK_TICK_RATE
> is not a true multiple of HZ.
> 
> In fact, I'm pretty sure that it's off on a lot of machines:
> 
> arch/frv/include/asm/timex.h:#define CLOCK_TICK_RATE            1193180 /* Underlying HZ */
> arch/m68k/include/asm/timex.h:#define CLOCK_TICK_RATE   1193180 /* Underlying HZ */
> arch/mips/include/asm/timex.h:#define CLOCK_TICK_RATE 1193182
> arch/parisc/include/asm/timex.h:#define CLOCK_TICK_RATE 1193180 /* Underlying HZ */
> arch/s390/include/asm/timex.h:#define CLOCK_TICK_RATE   1193180 /* Underlying HZ */
> arch/sh/include/asm/timex.h:#define CLOCK_TICK_RATE             1193180
> arch/x86/include/asm/timex.h:#define CLOCK_TICK_RATE            PIT_TICK_RATE
> arch/xtensa/include/asm/timex.h:#define CLOCK_TICK_RATE         1193180 /* (everyone is using this value) */
> 
> None of these is actually using a PC-style PIT these days, the just copied the
> definition blindly from old i386. I think a simple
> 
> #define ACTHZ (HZ << 8)
> 
> would fix more than it can break, and most likely nobody would ever notice
> the difference. If we do that, CLOCK_TICK_RATE becomes unused.

Indeed.

	tglx
