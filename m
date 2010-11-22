Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0KVKnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:43:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:60142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0KVKnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:43:40 -0500
Subject: Re: [PATCH 3/5] scheduler: cpuacct: Enable platform hooks to track
 cpuusage for CPU frequencies
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Mike Chan <mike@android.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101122065129.072bba06@schatten.dmk.lab>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	 <1290218934-8544-4-git-send-email-john.stultz@linaro.org>
	 <1290250104.2118.4.camel@laptop> <20101122065129.072bba06@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 11:43:59 +0100
Message-ID: <1290422639.2110.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 06:51 +0100, Florian Mickler wrote:
> On Sat, 20 Nov 2010 11:48:24 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2010-11-19 at 18:08 -0800, John Stultz wrote:
> > > From: Mike Chan <mike@android.com>
> > > 
> > > Introduce new platform callback hooks for cpuacct for tracking CPU frequencies
> > > 
> > > Not all platforms / architectures have a set CPU_FREQ_TABLE defined
> > > for CPU transition speeds. In order to track time spent in at various
> > > CPU frequencies, we enable platform callbacks from cpuacct for this accounting.
> > > 
> > > Architectures that support overclock boosting, or don't have pre-defined
> > > frequency tables can implement their own bucketing system that makes sense
> > > given their cpufreq scaling abilities.
> > > 
> > > New file:
> > > cpuacct.cpufreq reports the CPU time (in nanoseconds) spent at each CPU
> > > frequency.
> > 
> > I utterly detest all such accounting crap.. it adds ABI constraints it
> > add runtime overhead. etc.. 
> > 
> > Can't you get the same information by using the various perf bits? If
> > you trace the cpufreq changes you can compute the time spend in each
> > power state, if you additionally trace the sched_switch you can compute
> > it for each task.
> > 
> > 
> This is probably used for "on-site" debugging of production systems.

Dude, its from the _android_ tree... its cpufreq crud.. it must be some
crack induced power management scheme.


