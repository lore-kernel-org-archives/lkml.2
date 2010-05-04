Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0EDHSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:18:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0EDHSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:18:12 -0400
Message-ID: <4BDFC9FB.4020607@kernel.org>
Date: Tue, 04 May 2010 09:17:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpu_stop
References: <1271952554-22368-1-git-send-email-tj@kernel.org>	 <1271952554-22368-4-git-send-email-tj@kernel.org> <1272893192.5605.122.camel@twins>
In-Reply-To: <1272893192.5605.122.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 07:17:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/03/2010 03:26 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
>> @@ -2909,7 +2912,9 @@ redo:
>>                         }
>>                         raw_spin_unlock_irqrestore(&busiest->lock, flags);
>>                         if (active_balance)
>> -                               wake_up_process(busiest->migration_thread);
>> +                               stop_one_cpu_nowait(cpu_of(busiest),
>> +                                       active_load_balance_cpu_stop, busiest,
>> +                                       &busiest->active_balance_work); 
> 
> So who guarantees busiest->active_balance_work isn't already enqueued by
> some other cpu's load-balancer run?
> 

Hmmm... maybe I'm mistaken but isn't that guaranteed by
busiest->active_balance which is protected by the rq lock?
active_load_balance_cpu_stop is scheduled iff busiest->active_balance
was changed from zero and only active_load_balance_cpu_stop() can
clear it at the end of its execution at which point the
active_balance_work is safe to reuse.

Thanks.

-- 
tejun
