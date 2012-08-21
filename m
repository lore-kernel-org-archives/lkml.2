Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2HUA63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:58:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:22358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2HUA61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:58:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="183203583"
Message-ID: <5032DD22.4000909@intel.com>
Date: Tue, 21 Aug 2012 08:58:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <CAKfTPtDst+DEW=E=+cMcGL39oKODMfx3gh+x04siSC_5jt-6dg@mail.gmail.com>
In-Reply-To: <CAKfTPtDst+DEW=E=+cMcGL39oKODMfx3gh+x04siSC_5jt-6dg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 11:36 PM, Vincent Guittot wrote:

>> > What you want it to keep track of a per-cpu utilization level (inverse
>> > of idle-time) and using PJTs per-task runnable avg see if placing the
>> > new task on will exceed the utilization limit.
>> >
>> > I think some of the Linaro people actually played around with this,
>> > Vincent?
> Sorry for the late reply but I had almost no network access during last weeks.
> 
> So Linaro also works on a power aware scheduler as Peter mentioned.
> 
> Based on previous tests, we have concluded that main drawback of the
> (now removed) old power scheduler was that we had no way to make
> difference between short and long running tasks whereas it's a key
> input (at least for phone) for deciding to pack tasks and for
> selecting the core on an asymmetric system.


It is hard to estimate future in general view point. but from hack
point, maybe you can add something to hint this from task_struct. :)

> One additional key information is the power distribution in the system
> which can have a finer granularity than current sched_domain
> description. Peter's proposal was to use a SHARE_POWERLINE flag
> similarly to flags that already describe if a sched_domain share
> resources or cpu capacity.


Seems I missed this. what's difference with current SD_SHARE_CPUPOWER
and SD_SHARE_PKG_RESOURCES.

> 
> With these 2 new information, we can have a 1st power saving scheduler
> which spread or packed tasks across core and package


Fine, I like to test them on X86, plus SMT and NUMA :)

> 
> Vincent


