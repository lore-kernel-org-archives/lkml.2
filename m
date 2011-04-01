Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1DABzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 21:55:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1DABzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 21:55:51 -0400
Message-ID: <4D953121.6090901@cn.fujitsu.com>
Date: Fri, 01 Apr 2011 09:57:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        paulmck@linux.vnet.ibm.com, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF9BC.7050609@cn.fujitsu.com>	 <4D90647902000078000389CB@vpn.id2.novell.com>	 <4D924BAF.1020906@linux.intel.com>	 <20110329213130.GK2261@linux.vnet.ibm.com>	 <4D924FEE.8040804@linux.intel.com>	 <20110329214704.GM2261@linux.vnet.ibm.com>	 <4D9256AF.5000308@linux.intel.com>	 <20110330004725.GO2261@linux.vnet.ibm.com> <4D92BECA.50802@cn.fujitsu.com>	 <4D92DA32.2010809@cn.fujitsu.com>  <20110330105505.GA3195@sepie.suse.cz>	 <1301482656.4859.171.camel@twins> <4D931814.9090100@suse.cz>	 <4D93D29C.5010702@cn.fujitsu.com> <1301558691.2250.486.camel@laptop>	 <4D944E60.8080704@cn.fujitsu.com> <1301570320.4859.242.camel@twins>
In-Reply-To: <1301570320.4859.242.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-01 09:54:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-01 09:54:17,
	Serialize complete at 2011-04-01 09:54:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 07:18 PM, Peter Zijlstra wrote:
> On Thu, 2011-03-31 at 17:50 +0800, Lai Jiangshan wrote:
>> On 03/31/2011 04:04 PM, Peter Zijlstra wrote:
>>> On Thu, 2011-03-31 at 09:02 +0800, Lai Jiangshan wrote:
>>>> I like this cleanup, could you continue for this hard job? I will help
>>>> you if required.
>>>>
>>>> Ingo & Peter - will you accept the patches when it is done.
>>>>
>>> No, like I said, I think the proposed patch is utterly horrid.
>>>
>>
>> But how about my kernel-offset.c patch? It is clean & simple,
>> it just seems not so normal.
>>
>> If the proposed splitting patch is horrid, I think we will try to
>> update it as you expect.
>>
>> If splitting sched.h is wrong, I will try to persuade more people
>> accept the kernel-offset.c patch.
> 
> Well, I'm all for cleaning up sched.h, it includes way too much things
> not strongly related to kernel/sched*.c like a lot of the signal things
> and the misnamed signal_struct (should be called process_struct or
> somesuch).
> 
> That also causes the inversion between sched.h and wait.h
> 
> What I don't like is those _types.h headers, and definitely not the
> massive explosion of those as per the proposed patch.
> 
> Nor do I quite get why all that is needed, sched_types which would
> define task_struct still needs the new task_rcu_struct bits, and as per
> the patch you need to split the rcu headers into two. Once you've done
> that, I don't see why sched.h still needs splitting too.
> 
> 

"struct task_rcu_struct" is just a cleanup patch.

We are trying to use inlined read_read_[un]lock(), it is required that sched.h
needs include rcupdate.h which causes many recursive including. Splitting rcupdate.h
only does not help.
