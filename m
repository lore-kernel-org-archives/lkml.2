Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1I1OBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:01:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:43452 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab1I1OBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,455,1312182000"; 
   d="scan'208";a="56567863"
Message-ID: <4E8328A2.3070806@linux.intel.com>
Date: Wed, 28 Sep 2011 07:01:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Venki Pallipadi <venki@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
References: <1316804080-6396-1-git-send-email-venki@google.com>  <1316808181.9084.49.camel@twins>  <CABeCy1bng31kBhDT+=xumez0hjsXVi2V2ysqtDgUH=Y+3JRpuA@mail.gmail.com> <1317216203.24040.18.camel@twins>
In-Reply-To: <1317216203.24040.18.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 6:23 AM, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 16:47 -0700, Venki Pallipadi wrote:
>> On Fri, Sep 23, 2011 at 1:03 PM, Peter Zijlstra<peterz@infradead.org>  wrote:
>>> On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
>>>> Comments?
>>> Looks to be a possible IRQ latency issue as well, that can be a lot of
>>> timers to run..
>>>
>> We could add some rate limit on how many timers we service this way
>> and/or interrupt/disable-enable in the inner loop.
>> But, this would be a problem with current hrtimer as well. When
>> sched_tick timer is not around, we may end up servicing lot of timers
>> depending on number of them and slack. No?
> Right, still something to consider. We might just have to push down on
> slack for -rt or so when it becomes a problem.

that might not be the right answer ;-)
Slack gives you freedom to schedule these guys; without slack you can 
still get bursts of timers, but with no freedom to punt some for RT 
behavior.
with slack, you can run the mandatory ones first, and then the optionals 
until you hit some RT limit.. the optionals you do run are not going
to bunch up to you at the time they become mandatory.


