Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161018Ab1FAHFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:05:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42477 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab1FAHFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:05:51 -0400
Date: Wed, 1 Jun 2011 09:05:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, markus@trippelsdorf.de,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
Message-ID: <20110601070547.GB3368@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Borislav Petkov <bp@amd64.org>, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, markus@trippelsdorf.de,
	tglx@linutronix.de, mingo@elte.hu,
	linux-tip-commits@vger.kernel.org
References: <1306835745.2353.3.camel@twins>
 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
 <20110531125621.GA24439@gere.osrc.amd.com>
 <1306847516.2353.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1306847516.2353.80.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:11:56PM +0200, Peter Zijlstra wrote:
> Well, I don't have a modern AMD system to verify on, but the only
> explanation is sched_clock weirdness (different code from the GTOD tsc
> stuff). I could not reproduce on an Intel Westmere machine, but could on
> a Core2.
> 
> The sched_clock_cpu stuff basically takes a GTOD timestamp every tick
> and uses sched_clock() (tsc + cyc2ns) to provide delta increments, when
> TSCs are synced every cpu should return the same value and the patch is
> a nop.
> 
> If they aren't synced the per-cpu sched_clock_cpu() values can drift up
> to about 2 jiffies (when the ticks drift about 1 and the slower of the
> two has a stuck tsc while the faster of the two does progress at the
> normal rate). In that case doing a clock update cross-cpu will ensure
> time monotonicity between those two cpus.

Hmm, could it be that the sched_clock_tick() could be seeing different
TSC values due to propagation delays of IPIs and TSCs? Or, it could be
also that some TSCs don't start at the same moment after powerup but
still run synchronized though?

How can we trace this, do you do trace_printk() in the scheduler? I'm
asking because I remember reading somewhere that tracing the scheduler
is not that trivial like say a driver :). I could do that on a couple of
machines I have here and see what happens.

Thanks.

-- 
Regards/Gruss,
    Boris.
