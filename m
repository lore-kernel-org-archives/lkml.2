Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0F2QlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:41:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:3418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0F2Qkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:40:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,505,1272870000"; 
   d="scan'208";a="581111801"
Message-ID: <4C2A220B.8080006@linux.intel.com>
Date: Tue, 29 Jun 2010 09:40:43 -0700
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
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org>
In-Reply-To: <4C2A176F.1090101@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2010 8:55 AM, Tejun Heo wrote:
> Hello,
>
> On 06/29/2010 05:52 PM, Frederic Weisbecker wrote:
>    
>>>> If there is a question of slow ports to probe, then cmwq wouldn't seem the
>>>> right thing here, as it only forks when we go to sleep.
>>>>          
>>> I lost you here.  If something during boot has to burn cpu cycles
>>> (which it shouldn't, really), it has to burn cpu cycles and having
>>> multiple concurent threads won't help anything.
>>>        
>> It would on SMP.
>>      
> Oh, I see.  Parallel cpu hogs.  We don't have such users for async and
> I think using padata would be the right solution for those situations.
>    

uh? clearly the assumption is that if I have a 16 CPU machine, and 12 
items of work get scheduled,
that we get all 12 running in parallel. All the smarts of cmwq surely 
only kick in once you've reached the
"one work item per cpu" threshold ???


