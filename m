Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0F2SHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:07:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:43492 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0F2SHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,506,1272870000"; 
   d="scan'208";a="294400612"
Message-ID: <4C2A3652.7030806@linux.intel.com>
Date: Tue, 29 Jun 2010 11:07:14 -0700
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
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org>
In-Reply-To: <4C2A2688.1020206@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2010 9:59 AM, Tejun Heo wrote:
> Hello, Arjan.
>
> On 06/29/2010 06:40 PM, Arjan van de Ven wrote:
>    
>> uh? clearly the assumption is that if I have a 16 CPU machine, and 12
>> items of work get scheduled,
>> that we get all 12 running in parallel. All the smarts of cmwq surely
>> only kick in once you've reached the
>> "one work item per cpu" threshold ???
>>      
> Hmmm... workqueue workers are bound to certain cpu, so if you schedule
> a work on a specific CPU, it will run there.  Once a cpu gets
> saturated, the issuing thread will be moved elsewhere.  I don't think
> it matters to any of the current async users one way or the other,
> would it?
>    

we might be talking past eachother. ;-)

let me define an example that is simple so that we can get on the same page

assume a system with "enough" cpus, say 32.
lets say we have 2 async tasks, that each do an mdelay(1000); (yes I 
know stupid, but exagerating things makes things easier to talk about)
lets also assume that they get scheduled right back to back from the 
same code on the same cpu.

will the end result be that the first mdelay() task complete before the 
second one gets started, or will the end result be that
the 2nd one will notice the first cpu is busy, and find a second cpu to 
run in parallel with.



