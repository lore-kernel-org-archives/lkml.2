Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0EUJWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:22:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0EUJWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:22:38 -0400
Message-ID: <4BF65168.2010401@cn.fujitsu.com>
Date: Fri, 21 May 2010 17:24:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [RFD] Future tracing/instrumentation directions
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100520093131.GA30929@elte.hu>
In-Reply-To: <20100520093131.GA30929@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> More than a year and a half ago (September 2008), at 
>> Linux Plumbers, we had a meeting with several kernel 
>> developers to come up with a unified ring buffer. A 
>> generic ring buffer in the kernel that any subsystem 
>> could use. After coming up with a set of requirements, I 
>> worked on implementing it. One of the requirements was 
>> to start off simple and work to become a more complete 
>> buffering system.
>>
>> [...]
> 
> The thing is, in tracing land and more broadly in 
> instrumentation land we have _much_ more earthly problems 
> these days:
> 
>  - Lets face it, performance of the ring-buffer sucks, in 
>    a big way. I've recently benchmarked it and it takes 
>    hundreds of instructions to trace a single event. 
>    Puh-lease ...
> 

We ran some benchmarks with all the trace events enabled except
lock and kmem events, and the results showed the overhead was
quite small and acceptable.

But that was 2.6.31, we didn't benchmark newer kernels which have
more tracepoints.
