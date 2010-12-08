Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0LHMkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:40:32 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44745 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0LHMka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:40:30 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20101205162151.GH9138@n2100.arm.linux.org.uk>
References: <19697.8378.717761.236202@pilspetsen.it.uu.se>
	 <19707.34405.791777.298955@pilspetsen.it.uu.se>
	 <20101205131702.GE9138@n2100.arm.linux.org.uk>
	 <20101205141921.GF9138@n2100.arm.linux.org.uk>
	 <19707.47304.977978.297596@pilspetsen.it.uu.se>
	 <20101205162151.GH9138@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 13:40:15 +0100
Message-ID: <1291812015.28378.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 16:21 +0000, Russell King - ARM Linux wrote:

> I'm not sure that's the correct fix - it looks like sched_clock_cpu()
> should already be preventing scheduler clock time going backwards.
> 
> Hmm. IOP32x seems to have a 32-bit timer clocked at 200MHz.  That means
> it wraps once every 21s.  However, we have that converted to ns by an
> unknown multiplier and shift.  It seems that those are chosen to
> guarantee that we will cover only 4s without wrapping in the clocksource
> conversion.  Maybe that's not sufficient?
> 
> Could you try looking into sched_clock_cpu(), sched_clock_local() and
> sched_clock() to see whether anything odd stands out?

# git grep HAVE_UNSTABLE_SCHED_CLOCK arch/arm | wc -l
0

That code won't help if you don't enable it ;-)

John Stultz was also looking into making the kernel/sched_clock.c code
deal with short clocks.
