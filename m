Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0IJImd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:42:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:37963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab0IJImb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:42:31 -0400
Message-ID: <4C89EF37.5080803@kernel.org>
Date: Fri, 10 Sep 2010 10:41:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>	 <1284040322.2589.174.camel@edumazet-laptop>	 <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com> <1284106566.402.26.camel@laptop>
In-Reply-To: <1284106566.402.26.camel@laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 08:41:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/10/2010 10:16 AM, Peter Zijlstra wrote:
> On Thu, 2010-09-09 at 23:41 +0200, Stephane Eranian wrote:
>>> alloc_percpu() is zalloc_percpu() in fact, memory is already cleared.
>>>
>> I remember thinking about this and trying to trace to the code down
>> to figure this out. But it is rather complicated. If alloc_percpu() always
>> clears the memory, then I think that calling is zalloc_percpu()
>> would be more helpful.... 

Maybe but at this point it might be a bit too late.  The allocator has
been that way since the beginning.

> pcpu_populate_chunk() in mm/percpu-vm.c does indeed do that memset, the
> one in mm/percpu-km.c does not.
> 
> It is not obviously clear to me the -km allocator does indeed result in
> zero filled memory.

Nice catch.  Fortunately, the -km allocator isn't currently being used
in upstrea although it was enabled for linux-next a couple of days
ago.  I'll fix it up.

Thank you.

-- 
tejun
