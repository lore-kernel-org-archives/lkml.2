Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0F2SlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:41:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:5780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab0F2SlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:41:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,506,1272870000"; 
   d="scan'208";a="294416654"
Message-ID: <4C2A3E4D.9050607@linux.intel.com>
Date: Tue, 29 Jun 2010 11:41:17 -0700
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
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org> <4C2A3652.7030806@linux.intel.com> <4C2A385B.3010909@kernel.org> <4C2A39D4.8040505@linux.intel.com> <4C2A3CD0.70706@kernel.org>
In-Reply-To: <4C2A3CD0.70706@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2010 11:34 AM, Tejun Heo wrote:
> Hello,
>
> On 06/29/2010 08:22 PM, Arjan van de Ven wrote:
>    
>> I'm not trying to suggest "unbound".  I'm trying to suggest "don't
>> start bounding until you hit # threads>= # cpus you have some
>> clever tricks to deal with bounding things; but lets make sure that
>> the simple case of having less work to run in parallel than the
>> number of cpus gets dealt with simple and unbound.
>>      
> Well, the thing is, for most cases, binding to cpus is simply better.
>    

depends on the user.

For "throw over the wall" work, this is unclear.
Especially in the light of hyperthreading (sharing L1 cache) or even 
modern cpus (where many cores share a fast L3 cache).

I'm fine with a solution that has the caller say 'run anywhere' vs 'try 
to run local'.
I suspect there will be many many cases of 'run anywhere'.isn't hard at 
all. I just wanna know whether it's something which is

> actually useful.  So, where would that be useful?
>    

I think it's useful for all users of your worker pool, not (just) async.

it's a severe limitation of the current linux infrastructure, and your 
infrastructure has the chance to fix this...

