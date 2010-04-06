Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0DFNM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:12:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab0DFNMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:12:52 -0400
Message-ID: <4BBB334D.5040308@suse.de>
Date: Tue, 06 Apr 2010 18:42:45 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: High priority threads causing severe CPU load imbalances
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a simple test program that accepts number of threads(pthreads) to
be created as a input. Each of these threads that gets created invokes a
function which is just a infinite while loop. The main function after
creating those threads goes in a infinite loop itself

My test machine is a Dual Core AMD Opteron(tm) 860 with 8
sockets(non-HT), I run this test program with number of threads ==
number of CPUs:

   ./loadcpu -t 16

I see 100% CPU utilization on almost all CPUs (via mpstat/htop/vmstat).

When the above threads are running, if I introduce a few high priority
threads by doing:

   nice -n -13 ./loadcpu -t 3

After a short while, I see a few CPUs becoming idle at ~0% utilization
(the number of CPUs becoming idle equals roughly the number of high
priority threads i.e. 3). When I stop the high priority threads, the CPU
utilization comes back to normal i.e. ~100%.

This is reproducible on 2.6.32.10 stable kernel with all the recent all
SMT fixes (I hope) and I think it would be reproducible in current
upstream as well.

sched_mc_power_savings has been always set to 0.

I spent a while staring at the load balancing and the thread migration
code, but could not figure out why this is happening. Would appreciate
any pointers.


Thanks,

-- 
Suresh Jayaraman
