Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab1IUVYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:24:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:51206 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1IUVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:24:33 -0400
Date: Wed, 21 Sep 2011 23:24:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Clark Williams <williams@redhat.com>
cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Carsten Emde <ce@ceag.ch>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: Re: rt-tests-0.82 available on github
In-Reply-To: <20110921155455.61ab4745@redhat.com>
Message-ID: <alpine.LFD.2.02.1109212313180.2723@ionos>
References: <20110921155455.61ab4745@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Clark Williams wrote:

> While kernel.org is sorting out the security stuff, the rt-tests code
> may be pulled from:
> 
> 	git://github.com/clrkwllms/rt-tests.git
> 
> Note that we're now at version 0.82. Presently I only have the git
> archive available (no tarballs). 
> 
> While investigating latency spikes in the 3.0.x-rt kernels, Thomas
> spotted a case where an Intel quad-core Xeon was going into deep
> sleep states and were all fighting to come out of sleep at the same
> time (and consequently causing a big latency spike in cyclictest). 
> 
> While trying to figure out how to prevent deep cstates I remembered a
> conversation I had with Arjan at the last Plumbers conference in
> Boston. He mentioned the /dev/cpu_dma_latency interface to the power
> managment code and that if you opened it and wrote a zero to it, you
> effectively put the system into "idle=poll" mode until you closed the
> file descriptor (see: Documentation/power/pm_qos_interface.txt). 
> 
> I've added a set_latency_target() function to cyclictest that by
> default opens /dev/cpu_dma_latency and writes a zero to it, then holds
> the file descriptor open for the duration of the cyclictest run. This
> made a *huge* difference on some Intel Xeon's. Without this option, when
> I was running cyclictest with the -b option, I saw latencies over
> 300us. When I added it, while tracing I never saw a latency over 30us.
> Turning of -b, I never saw it go over 10us. I am doing further testing
> now with other x86_64 systems. 
> 
> Of course this is very architecture specific, so YMMV, but I think it's
> a valid mechanism to be used when measuring latency and I believe a
> technique that many latency-sensitive applications might use to good
> effect. 

This is not a big surprise as the kernel got more agressive going into
deep C-states since 2.6.33-rt especially with "intel_idle" on modern
(Nehalem+) cpus.

Thanks,

	tglx
