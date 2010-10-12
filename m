Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0JLLJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:09:02 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47921 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0JLLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:09:00 -0400
Message-ID: <4CB441CB.2000708@cs.helsinki.fi>
Date: Tue, 12 Oct 2010 14:08:59 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
References: <1286838210.30423.128.camel@edumazet-laptop>	<1286839363.30423.130.camel@edumazet-laptop>	<1286859925.30423.184.camel@edumazet-laptop>	<20101011230322.f0f6dd47.akpm@linux-foundation.org>	<1286866699.30423.234.camel@edumazet-laptop>	<20101012002435.f51f2c0e.akpm@linux-foundation.org>	<1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org>
In-Reply-To: <20101012005856.994bea6d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/10 10:58 AM, Andrew Morton wrote:
> On Tue, 12 Oct 2010 09:49:53 +0200 Eric Dumazet<eric.dumazet@gmail.com>  wrote:
>
>> Le mardi 12 octobre 2010 à 00:24 -0700, Andrew Morton a écrit :
>>
>>> I'd love to forget it, but it's faster for some things (I forget
>>> which).  Which is why it's still around.
>>
>> Yes, two years ago it was true on pathological/obscure cases.
>> Every time I did the comparison, SLUB won.
>> You asked me, I did yet another test this morning, and 40% is pretty
>> serious, I believe.
>>
>>> And the ghastly thing about this is that you're forced to care about it
>>> too because some people are, apparently, still using it.
>>
>> Yes, some people (in my company) still use linux 2.6.9 32bit on HP G6/G7
>> machines, I know...
>>
>> I am not saying we should not care, but for any serious network workload
>> on NUMA arches, SLUB is the best, and seeing Christoph recent work, it
>> might even get better.
>>
>> BTW, I believe all modern distros ship SLUB, dont they ?
>
> Dunno.
>
> Pekka, why haven't we deleted slab yet??

To make a long story short, we still have relevant performance 
regressions that need to be taken care of. The most interesting one is a 
regression in netperf TCP_RR that's been reported by David Rientjes a 
while back. There's bunch of SLUB cleanups queued for 2.6.37 that pave 
the way for Christoph's SLUB queueing work that should hopefully fix 
that particular issue for 2.6.38.

There's little point in discussing the removal of SLAB as long as there 
are performance regressions for real workloads from people who are 
willing to share results and test patches. I'm optimistic that we'll be 
able to try removing SLAB some time next year unless something 
interesting pops up...

			Pekka
