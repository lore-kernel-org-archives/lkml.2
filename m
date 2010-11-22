Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0KVMXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:23:43 -0500
Received: from ist.d-labs.de ([213.239.218.44]:38472 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0KVMXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:23:41 -0500
Date: Mon, 22 Nov 2010 13:23:06 +0100
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Mike Chan <mike@android.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/5] scheduler: cpuacct: Enable platform hooks to track
 cpuusage for CPU frequencies
Message-ID: <20101122132306.245e0bcb@schatten.dmk.lab>
In-Reply-To: <1290422639.2110.3.camel@laptop>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	<1290218934-8544-4-git-send-email-john.stultz@linaro.org>
	<1290250104.2118.4.camel@laptop>
	<20101122065129.072bba06@schatten.dmk.lab>
	<1290422639.2110.3.camel@laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 11:43:59 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-11-22 at 06:51 +0100, Florian Mickler wrote:
> > On Sat, 20 Nov 2010 11:48:24 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2010-11-19 at 18:08 -0800, John Stultz wrote:
> > > > From: Mike Chan <mike@android.com>
> > > > 
> > > > Introduce new platform callback hooks for cpuacct for tracking CPU frequencies
> > > > 
> > > > Not all platforms / architectures have a set CPU_FREQ_TABLE defined
> > > > for CPU transition speeds. In order to track time spent in at various
> > > > CPU frequencies, we enable platform callbacks from cpuacct for this accounting.
> > > > 
> > > > Architectures that support overclock boosting, or don't have pre-defined
> > > > frequency tables can implement their own bucketing system that makes sense
> > > > given their cpufreq scaling abilities.
> > > > 
> > > > New file:
> > > > cpuacct.cpufreq reports the CPU time (in nanoseconds) spent at each CPU
> > > > frequency.
> > > 
> > > I utterly detest all such accounting crap.. it adds ABI constraints it
> > > add runtime overhead. etc.. 
> > > 
> > > Can't you get the same information by using the various perf bits? If
> > > you trace the cpufreq changes you can compute the time spend in each
> > > power state, if you additionally trace the sched_switch you can compute
> > > it for each task.
> > > 
> > > 
> > This is probably used for "on-site" debugging of production systems.
> 
> Dude, its from the _android_ tree... its cpufreq crud.. it must be some
> crack induced power management scheme.
> 
> 

:) 

what I wanted to get at, was that they probably need these stats
aggregated somewhere neat and tidy and can not compute them on the fly
recording massive amounts of data...

I wonder why they didn't put this in the
idle-driver.  I don't know. 

Regards,
Flo

