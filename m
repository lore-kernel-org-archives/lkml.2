Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2I0Sae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:30:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:46957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2I0Sad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:30:33 -0400
Message-ID: <1348770584.3292.44.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 20:29:44 +0200
In-Reply-To: <CA+55aFyTrcmx3Uf7UGU=-K=BwTym8aN15fTo==cV2bCK6so0Fg@mail.gmail.com>
References: <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <1348722568.7059.115.camel@marge.simpson.net>
	 <20120927054742.GA4370@gmail.com>
	 <1348727665.7059.160.camel@marge.simpson.net>
	 <20120927064142.GB5996@gmail.com>
	 <1348728852.7059.171.camel@marge.simpson.net>
	 <20120927071011.GA8980@gmail.com>
	 <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
	 <20120927180507.GD8527@x1.osrc.amd.com>
	 <CA+55aFyTrcmx3Uf7UGU=-K=BwTym8aN15fTo==cV2bCK6so0Fg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 11:19 -0700, Linus Torvalds wrote:
> On Thu, Sep 27, 2012 at 11:05 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Thu, Sep 27, 2012 at 10:44:26AM -0700, Linus Torvalds wrote:
> >> Or could we just improve the heuristics. What happens if the
> >> scheduling granularity is increased, for example? It's set to 1ms
> >> right now, with a logarithmic scaling by number of cpus.
> >
> > /proc/sys/kernel/sched_wakeup_granularity_ns=10000000 (10ms)
> > ------------------------------------------------------
> > tps = 4994.730809 (including connections establishing)
> > tps = 5000.260764 (excluding connections establishing)
> >
> > A bit better over the default NO_WAKEUP_PREEMPTION setting.
> 
> Ok, so this gives us something possible to actually play with.
> 
> For example, maybe SCHED_TUNABLESCALING_LINEAR is more appropriate
> than SCHED_TUNABLESCALING_LOG. At least for WAKEUP_PREEMPTION. Hmm?

Don't forget to run the desktop interactivity benchmarks after you're
done wriggling with this knob... wakeup preemption is important for most
those.


