Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0KRGAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:00:43 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46953 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0KRGAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:00:41 -0500
X-AuditID: b753bd60-a69a5ba000003e7d-1f-4ce4c105bcfb
Message-ID: <4CE4C101.9010905@hitachi.com>
Date: Thu, 18 Nov 2010 15:00:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>	 <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>	 <1290003110.2109.822.camel@laptop>	 <1290006634.30543.61.camel@gandalf.stny.rr.com> <1290008637.2109.967.camel@laptop>
In-Reply-To: <1290008637.2109.967.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/18 0:43), Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 10:10 -0500, Steven Rostedt wrote:
>>
>> Right, the problem with filtering is what do we want to filter, and what
>> about copying?
>>
>> Currently, we copy the data into the buffer and then filter on that
>> data. We could also easily filter on the parameters of the tracepoint,
>> but sometimes those parameters do not match the final output (as the
>> case with sched_switch). Do we copy the data into a separate "per cpu"
>> temp buffer, and figure out the filter then? And if the filter is fine,
>> then copy into the buffer. This obviously is slow, due to the multiple
>> copies. We could do this only if the filtering is enabled.
> 
> Right, so what is the primary purpose of this filtering stuff? As it
> stands it makes stuff terribly slow, so you add overhead but the win
> (presumably) is less data output, is that a sane trade-off?
> 
> Most people I've heard -- both at LinuxCon.JP and LPC -- are asking for
> lower overhead tracing (while at the same time demanding more features).

I've also heard a dynamic filtering (or kicking buffer snapshot) request
in LinuxCon.JP. I think filtering is not only for filtering-out purpose,
but also useful for hooking event to take some action. :)

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
