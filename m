Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0LOQf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:35:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0LOQfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:35:55 -0500
Message-ID: <4D08EE11.3050603@zytor.com>
Date: Wed, 15 Dec 2010 08:34:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
References: <20101214162842.542421046@linux.com> <20101214162854.218751478@linux.com> <4D08EDA9.3090801@kernel.org>
In-Reply-To: <4D08EDA9.3090801@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 08:32 AM, Tejun Heo wrote:
> On 12/14/2010 05:28 PM, Christoph Lameter wrote:
>> The irq work queue is a per cpu object and it is sufficient for
>> synchronization if per cpu atomics are used. Doing so simplifies
>> the code and reduces the overhead of the code.
>>
>> Before:
>>
>> christoph@linux-2.6$ size kernel/irq_work.o
>>    text	   data	    bss	    dec	    hex	filename
>>     451	      8	      1	    460	    1cc	kernel/irq_work.o
>>
>> After:
>>
>> christoph@linux-2.6$ size kernel/irq_work.o 
>>    text	   data	    bss	    dec	    hex	filename
>>     438	      8	      1	    447	    1bf	kernel/irq_work.o
>>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Peter, can you please ack this one?
> 
> Thanks.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

... for tis whole series.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

