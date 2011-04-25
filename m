Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1DYHdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 03:33:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1DYHdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 03:33:18 -0400
Message-ID: <4DB520F7.6060808@cn.fujitsu.com>
Date: Mon, 25 Apr 2011 15:21:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, "H. Peter Anvin" <hpa@linux.intel.com>,
        Michal Marek <mmarek@suse.cz>, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D9CDACB.9050705@linux.intel.com>	 <20110407003041.GD2265@linux.vnet.ibm.com>	 <4D9D507F.2040006@cn.fujitsu.com>	 <20110407154737.GF2262@linux.vnet.ibm.com>	 <20110407162600.GA24227@linux.vnet.ibm.com>	 <4D9E6438.5030206@cn.fujitsu.com>	 <20110408051359.GA2318@linux.vnet.ibm.com> <4DA2709E.50902@cn.fujitsu.com>	 <20110411051241.GB18415@linux.vnet.ibm.com>	 <4DA2BC4E.4010000@cn.fujitsu.com>	 <20110411210223.GB2226@linux.vnet.ibm.com>	 <4DB12C1E.8050200@cn.fujitsu.com> <1303459820.2298.4.camel@twins>
In-Reply-To: <1303459820.2298.4.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-25 15:19:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-25 15:33:45,
	Serialize complete at 2011-04-25 15:33:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 04:10 PM, Peter Zijlstra wrote:
> On Fri, 2011-04-22 at 15:19 +0800, Lai Jiangshan wrote:
>>
>> What is the solution you prefer to?
>>
>> I insist on the solution which split rcupdate.h into 2 parts,
>> the first part is rcupdate_defs.h which only contains:
>> 1) struct rcu_head
>> 2) MACRO rcu_dereference*
>> 3) MACRO rcu_access_pointer rcu_access_index rcu_assign_pointer RCU_INIT_POINTER
>> 4) rcu_*_lock_held() which is required by 2)
>>
>> All of these is required by sched.h, it is all about 450 lines of code.
>>
>> It does not just separate struct rcu_head out only, because rcu_dereference*()
>> and APIs in rculist.h are required by in sched.h or headers included by sched.h.
> 
> The only usage of rculist.h in the whole of sched.h is that _one_
> list_entry_rcu, of which we already have a macro user, so why not make
> that one a macro too and safe ourselves a ton of grief?
> 
> You're just making stuff harder than it needs to be.
> 

No, opposite.
the more things(except rcu_read_[un]lock*()) are moved to rcupdate_defs.h the more easy.
the less things are moved to rcupdate_defs.h the more hard.

example, if rcu_dereference* is not moved to rcupdate_defs.h,
I have to do 2 more things:
1) convert inline functions next_thread() to macro.
2) find all .c which uses next_thread()/next_task() and ensure they all have rcupdate.h included.
3?) handle the complaints from LKML and told them should convert their new APIs to macro
    and should also do the same work like 2)

I'm just expressing my thinking, I will accept your requirement and make things progress.

Thanks,
Lai
