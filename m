Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1LBNva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:51:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:36231 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756087Ab1LBNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:51:29 -0500
Date: Fri, 2 Dec 2011 08:51:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111202135126.GA20115@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com> <1322776568.4699.52.camel@twins> <20111201220445.GA10552@Krystal> <1322777407.4699.59.camel@twins> <20111201221500.GC10552@Krystal> <20111201223607.GF10552@Krystal> <1322780758.4699.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322780758.4699.60.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:44:41 up 373 days, 18:47,  6 users,  load average: 0.15, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2011-12-01 at 17:36 -0500, Mathieu Desnoyers wrote:
> > So what you are saying is that it is fine to export task_prio to
> > _userspace_, thus making it part of the ABI, but it's not OK to export
> > it to GPL modules ? 
> 
> that's a SCHED_DEBUG proc file.

Fair point. You'll then notice that /proc/<pid>/stat (18th field)
exports it too, and it's not under SCHED_DEBUG:

ok:/proc/20# cat stat
20 (migration/5) S 2 0 0 0 -1 2216722496 0 0 0 0 0 0 0 0 -100 0 1 0 70 0
0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744071579371389 0
0 17 5 99 1 0 0 0

(see -100 above)

as defined in Documentation/filesystems/proc.txt:

"Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
[...]
priority      priority level"

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
