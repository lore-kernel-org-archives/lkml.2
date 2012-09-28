Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab2I1M3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:29:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35517 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2I1M3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:29:45 -0400
Date: Fri, 28 Sep 2012 14:30:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120928123008.GA16372@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <1348727665.7059.160.camel@marge.simpson.net>
 <20120927064142.GB5996@gmail.com>
 <1348728852.7059.171.camel@marge.simpson.net>
 <20120927071011.GA8980@gmail.com>
 <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
 <20120927180507.GD8527@x1.osrc.amd.com>
 <CA+55aFyTrcmx3Uf7UGU=-K=BwTym8aN15fTo==cV2bCK6so0Fg@mail.gmail.com>
 <1348770584.3292.44.camel@twins>
 <20120927192426.GF8527@x1.osrc.amd.com>
 <1348804220.7072.2.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348804220.7072.2.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:50:20AM +0200, Mike Galbraith wrote:
> And wakeup preemption is still disabled as well, correct?

Yes it is by default anyway:

$ cat /mnt/dbg/sched_features
GENTLE_FAIR_SLEEPERS START_DEBIT NO_NEXT_BUDDY LAST_BUDDY CACHE_HOT_BUDDY NO_WAKEUP_PREEMPTION ARCH_POWER NO_HRTICK NO_DOUBLE_TICK LB_BIAS OWNER_SPIN NONTASK_POWER TTWU_QUEUE NO_FORCE_SD_OVERLAP RT_RUNTIME_SHARE NO_LB_MIN

NO_WAKEUP_PREEMPTION brings 9% improvement with pgbench, btw:

http://marc.info/?l=linux-kernel&m=134876312310048

-- 
Regards/Gruss,
Boris.
