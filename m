Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2FOBop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:44:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33276 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2FOBoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:44:44 -0400
Date: Fri, 15 Jun 2012 10:44:37 +0900
From: Tejun Heo <tj@kernel.org>
To: Silas Boyd-Wickizer <sbw@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
Message-ID: <20120615014437.GB12624@mtj.dyndns.org>
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.132283147@linutronix.de>
 <20120614221308.GA31815@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614221308.GA31815@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 03:13:31PM -0700, Silas Boyd-Wickizer wrote:
> Hello,
> 
> Attached is a rough patch that uses park/unpark for workqueue idle
> threads.  The patch is a hack, it probably has bugs, and it certainly
> doesn't simplify the workqueue code.  Perhaps, however, the patch
> might be useful in guiding future changes to smp_boot_threads or
> workqueues.
> 
> A difficulty in applying park/unpark (or smp_boot_threads
> potentially), it that there is no single per-CPU thread for each CPU.
> That is, the thread that starts out as the initial worker/idle thread
> could be different from any thread that is idling when a CPU goes
> offline.  An additional complication is that a per-cpu worker that is
> idle may have initially been unbound (e.g. worker creation in the
> trustee_thread can cause this).

I haven't looked at it in any detail yet but if the goal is just
keeping workers around for temporarily down CPUs, workqueue changes
can be pretty simple.  I *think* all that's necessary is trustee not
butchering on cpu down.  wq already has mechanisms to recycle dangling
workers when a cpu comes back online.  I'll give it a shot next week.

Thanks.

-- 
tejun
