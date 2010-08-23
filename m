Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0HWJvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:51:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:59257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0HWJva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:51:30 -0400
Message-ID: <4C72436A.8080000@kernel.org>
Date: Mon, 23 Aug 2010 11:46:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org
Subject: Re: [PATCH] workqueue: Add basic tracepoints to track workqueue	execution
References: <20100821131402.577c4d75@infradead.org> <20100822040101.GE5258@nowhere>
In-Reply-To: <20100822040101.GE5258@nowhere>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 09:51:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/22/2010 06:01 AM, Frederic Weisbecker wrote:
> On Sat, Aug 21, 2010 at 01:14:02PM -0700, Arjan van de Ven wrote:
>>
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Date: Sat, 21 Aug 2010 13:07:26 -0700
>> Subject: [PATCH] workqueue: Add basic tracepoints to track workqueue execution
>>
>> With the introduction of the new unified work queue thread pools,
>> we lost one feature: It's no longer possible to know which worker
>> is causing the CPU to wake out of idle. The result is that PowerTOP
>> now reports a lot of "kworker/a:b" instead of more readable results.
>>
>> This patch adds a pair of tracepoints to the new workqueue code,
>> similar in style to the timer/hrtimer tracepoints.
>>
>> With this pair of tracepoints, the next PowerTOP can correctly
>> report which work item caused the wakeup (and how long it took):
>>
>> Interrupt (43)            i915      time   3.51ms    wakeups 141
>> Work      ieee80211_iface_work      time   0.81ms    wakeups  29
>> Work              do_dbs_timer      time   0.55ms    wakeups  24
>> Process                   Xorg      time  21.36ms    wakeups   4
>> Timer    sched_rt_period_timer      time   0.01ms    wakeups   1
>>
>> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Ok, Linus applied it. That answers my doubts about the
> route for this patch :)

I was planning to work on wq tracing in this devel cycle but yeah
Arjan's patch seems like a good starting place.

We definitely need more tracing points tho.  Also, David was wondering
whether it would be possible to have simple file based interface to
monitor the current status of workers.  That's doable w/ tracing API,
right?

Thanks.

-- 
tejun
