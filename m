Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0F2SWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:22:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:49989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0F2SWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:22:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,506,1272870000"; 
   d="scan'208";a="294408031"
Message-ID: <4C2A39D4.8040505@linux.intel.com>
Date: Tue, 29 Jun 2010 11:22:12 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, oleg@redhat.com,
       axboe@kernel.dk, dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de,
       florian@mickler.org, andi@firstfloor.org, mst@redhat.com,
       randy.dunlap@oracle.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org> <4C2A3652.7030806@linux.intel.com> <4C2A385B.3010909@kernel.org>
In-Reply-To: <4C2A385B.3010909@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2010 11:15 AM, Tejun Heo wrote:
> Hello, Arjan.
>
> On 06/29/2010 08:07 PM, Arjan van de Ven wrote:
>    
>> we might be talking past eachother. ;-)
>>
>> let me define an example that is simple so that we can get on the same page
>>
>> assume a system with "enough" cpus, say 32.
>> lets say we have 2 async tasks, that each do an mdelay(1000); (yes I
>> know stupid, but exagerating things makes things easier to talk about)
>>      
> That's the main point to discuss tho.  If you exaggerate the use case
> out of proportion, you'll end up with something which in the end is
> useful only in the imagination and we'll be doing things just because
> we can.  Creating full number of unbound threads might look like a
> good idea to extract maximum cpu parallelism if you exaggerate the use
> case like the above but with the current actual use case, it's not
> gonna buy us anything and might even cost us more via unnecessary
> thread creations.
>    

I'm not trying to suggest "unbound".
I'm trying to suggest "don't start bounding until you hit # threads >= # 
cpus
you have some clever tricks to deal with bounding things; but lets make 
sure that the simple case
of having less work to run in parallel than the number of cpus gets 
dealt with simple and unbound.
You also consolidate the thread pools so that you have one global pool, 
so unlike the current situation
where you get O(Nr pools * Nr cpus), you only get O(Nr cpus) number of 
threads... that's not too burdensome imo.
If you want to go below that then I think you're going too far in 
reducing the number of threads in your pool. Really.


so... back to my question; will those two tasks run in parallel or 
sequential ?

