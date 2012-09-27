Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2I0SEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:04:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50387 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab2I0SEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:04:45 -0400
Date: Thu, 27 Sep 2012 20:05:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927180507.GD8527@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Suresh Siddha <suresh.b.siddha@intel.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:44:26AM -0700, Linus Torvalds wrote:
> Or could we just improve the heuristics. What happens if the
> scheduling granularity is increased, for example? It's set to 1ms
> right now, with a logarithmic scaling by number of cpus.

/proc/sys/kernel/sched_wakeup_granularity_ns=10000000 (10ms)
------------------------------------------------------
tps = 4994.730809 (including connections establishing)
tps = 5000.260764 (excluding connections establishing)

A bit better over the default NO_WAKEUP_PREEMPTION setting.

-- 
Regards/Gruss,
Boris.
