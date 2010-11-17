Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935406Ab0KQTkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:40:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:37881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab0KQTkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:40:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,212,1288594800"; 
   d="scan'208";a="678473925"
Message-ID: <4CE42FB7.8000806@linux.intel.com>
Date: Wed, 17 Nov 2010 11:40:39 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>	 <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>	 <1290003110.2109.822.camel@laptop>	 <1290006634.30543.61.camel@gandalf.stny.rr.com>	 <1290008637.2109.967.camel@laptop> <1290010521.30543.68.camel@gandalf.stny.rr.com>
In-Reply-To: <1290010521.30543.68.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 08:15 AM, Steven Rostedt wrote:
> On Wed, 2010-11-17 at 16:43 +0100, Peter Zijlstra wrote:
>> On Wed, 2010-11-17 at 10:10 -0500, Steven Rostedt wrote:
>>>
>>> Right, the problem with filtering is what do we want to filter, and what
>>> about copying?
>>>
>>> Currently, we copy the data into the buffer and then filter on that
>>> data. We could also easily filter on the parameters of the tracepoint,
>>> but sometimes those parameters do not match the final output (as the
>>> case with sched_switch). Do we copy the data into a separate "per cpu"
>>> temp buffer, and figure out the filter then? And if the filter is fine,
>>> then copy into the buffer. This obviously is slow, due to the multiple
>>> copies. We could do this only if the filtering is enabled.
>>
>> Right, so what is the primary purpose of this filtering stuff? As it
>> stands it makes stuff terribly slow, so you add overhead but the win
>> (presumably) is less data output, is that a sane trade-off?
>
> I've actually used filtering too. Not for speed up, but because I was
> recording a lot of data and the reader could not keep up. By filtering,
> I was able to get all the relevant information without needing to make
> the kernel buffer a Gig.

I have run into situations where the volume of output becomes a problem 
and not every system will have the memory to dedicate to massive trace 
buffers. This is, for me, probably the one motivating argument for doing 
filtering in the kernel as opposed to post-processing scripts.

-- 
Darren Hart
Yocto Linux Kernel
