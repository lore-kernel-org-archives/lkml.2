Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0F2SIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:08:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:28380 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0F2SIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,506,1272870000"; 
   d="scan'208";a="294400920"
Message-ID: <4C2A368B.9020009@linux.intel.com>
Date: Tue, 29 Jun 2010 11:08:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, oleg@redhat.com,
       axboe@kernel.dk, dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de,
       florian@mickler.org, andi@firstfloor.org, mst@redhat.com,
       randy.dunlap@oracle.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org> <4C2A2979.3000609@gmail.com>
In-Reply-To: <4C2A2979.3000609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2010 10:12 AM, Tejun Heo wrote:
> On 06/29/2010 06:59 PM, Tejun Heo wrote:
>    
>> Hello, Arjan.
>>
>> On 06/29/2010 06:40 PM, Arjan van de Ven wrote:
>>      
>>> uh? clearly the assumption is that if I have a 16 CPU machine, and 12
>>> items of work get scheduled,
>>> that we get all 12 running in parallel. All the smarts of cmwq surely
>>> only kick in once you've reached the
>>> "one work item per cpu" threshold ???
>>>        
>> Hmmm... workqueue workers are bound to certain cpu, so if you schedule
>> a work on a specific CPU, it will run there.  Once a cpu gets
>> saturated, the issuing thread will be moved elsewhere.  I don't think
>> it matters to any of the current async users one way or the other,
>> would it?
>>      
> Thinking more about it.  It's now not difficult to add a gcwq for an
> unbound pseudo CPU number and use it as host for workers which can run
> on any CPU.  The automatic concurrency management doesn't make much
> sense for those workers, so @max_active can be used as the explicit
> concurrency throttle.  It's not even gonna take a lot of code but I'm
> just not convinced that there's much benefit in doing that.  So, yeah,
> if necessary, sure, but let's think whether it's gonna be actually
> useful.
>    


the point in general is to get maximum parallelism; with systems getting 
more and more cores, maximum parallelism is
a good design goal.

