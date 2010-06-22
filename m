Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0FVHcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:32:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:48408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0FVHcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:32:50 -0400
Message-ID: <4C2066DF.6060404@kernel.org>
Date: Tue, 22 Jun 2010 09:31:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       mst@redhat.com, samudrala.sridhar@gmail.com
Subject: Re: [PATCH] kthread: implement kthread_worker
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<1276776066.2461.15.camel@localhost>	<20100617161619.d3ebd73d.akpm@linux-foundation.org>	<4C1B1D3F.8030509@kernel.org>	<20100618003127.10d9e6c8.akpm@linux-foundation.org>	<4C1B29BF.7080404@kernel.org>	<20100618100228.093ec17b.akpm@linux-foundation.org>	<4C1BACC6.5020602@kernel.org>	<4C1CE813.8080701@kernel.org> <20100621133321.6215b85b.randy.dunlap@oracle.com>
In-Reply-To: <20100621133321.6215b85b.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Jun 2010 07:31:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/21/2010 10:33 PM, Randy Dunlap wrote:
> On Sat, 19 Jun 2010 17:53:55 +0200 Tejun Heo wrote:
> 
>>  include/linux/kthread.h |   63 +++++++++++++++++++++++++
>>  kernel/kthread.c        |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 181 insertions(+)
>>
>> Index: work/kernel/kthread.c
>> ===================================================================
>> --- work.orig/kernel/kthread.c
>> +++ work/kernel/kthread.c
> 
>> @@ -247,3 +249,119 @@ int kthreadd(void *unused)
>>
>>  	return 0;
>>  }
>> +
>> +/**
>> + * kthread_worker_fn - kthread function to process kthread_worker
>> + * @data: pointer to initialized kthread_worker
> 
> s/data/worker_ptr/
> 
>> + *
>> + * This function can be used as @threadfn to kthread_create() or
>> + * kthread_run() with @data argument pointing to an initialized
> 
> ditto.

Yeah, that would be a much better idea.  Updated.

Thanks.

-- 
tejun
