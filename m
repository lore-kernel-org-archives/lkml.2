Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1AUTn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:43:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43646 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1AUTn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:43:26 -0500
Date: Fri, 21 Jan 2011 20:43:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
Message-ID: <20110121194317.GA8908@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119083916.GA2166@elte.hu>
 <20110121174438.7521539f@tornado.gnet>
 <AANLkTi=p3=MkGevrW1YU0v_V5iXLw7iLDuWeb7Rf8Xx_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=p3=MkGevrW1YU0v_V5iXLw7iLDuWeb7Rf8Xx_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> HOWEVER, even then I think you should see the lockdep message as a
> problem. The automated toolchain is great because it shows problems
> that it thinks might happen - not when they happen, but based on a
> simpler theoretical model. Ignoring the error because there is some
> rule in place that is hard to explain to the automated toolchain is
> the wrong thing to do, because it makes the lockdep automation less
> reliable.

Yeah. Also, inevitably the false positives have a higher likelyhood
of making it into a released kernel, often because the bugs where
there was a real lockup as well got noticed via other means.

It's similar with compiler warnings as well: the questionable ones where
GCC is wrong or at least confused accumulate.

Also note that here there's a real lockup here as well, shortly after the lockdep 
message - the boot never continues, the box keep spewing the PPS debug messages:

[   76.240020] pps pps0: PPS event at 4294911356
[   76.244380] pps pps0: PPS event at 1295471377.240018362
[   76.249608] pps pps0: capture assert seq #2
[   77.252019] pps pps0: PPS event at 4294911609
[   77.256379] pps pps0: PPS event at 1295471378.252017372
[   77.261604] pps pps0: capture assert seq #3
[   78.264021] pps pps0: PPS event at 4294911862
[   78.268387] pps pps0: PPS event at 1295471379.264018619
[   78.273621] pps pps0: capture assert seq #4
[   79.276018] pps pps0: PPS event at 4294912115
[   79.280384] pps pps0: PPS event at 1295471380.276016791
[   79.285619] pps pps0: capture assert seq #5

But nothing happens, the boot never continues.

Thanks,

	Ingo
