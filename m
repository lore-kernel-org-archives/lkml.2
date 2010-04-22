Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0DVG0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:26:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56593 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab0DVG0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:26:10 -0400
Message-ID: <4BCFEBFF.4090505@us.ibm.com>
Date: Wed, 21 Apr 2010 23:26:07 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Lockdep usage
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having some trouble with lockstat. I've enabled CONFIG_LOCK_STATS 
and then run the following commands to collect the lock statistics for 
the futex_lock test case. I expect this test case to generate a fair 
amount of contention on the futex hash bucket locks, but they don't show 
up in the stats (in fact, nothing shows up in the stats). I have seen 
much longer lock_stat files when I forgot to clear them before the test, 
but no hb locks showed up there either.

Is my usage below incorrect? Do I have to somehow annotate the hb->lock 
in order for lockstat to track it?

This is as of:
commit a3d3203e4bb40f253b1541e310dc0f9305be7c84
Merge: f937331... ec28dcc...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Mar 14 20:29:21 2010 -0700


# echo 0 > /proc/lock_stat; echo 1 > /proc/sys/kernel/lock_stat; 
./futex_lock -i10000000 -p1000 -d20; cat /proc/lock_stat > 
lock.lockstat; echo 0 > /proc/sys/kernel/lock_stat
futex_lock: Measure FUTEX_LOCK operations per second
         Arguments: iterations=10000000 threads=256 adaptive=no
                    period=1000 duty-cycle=20%
Result: 731 Kiter/s

# cat lock.lockstat
lock_stat version 0.3
*WARNING* lock debugging disabled!! - possibly due to a lockdep warning
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                               class name    con-bounces    contentions 
   waittime-min   waittime-max waittime-total    acq-bounces 
acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
