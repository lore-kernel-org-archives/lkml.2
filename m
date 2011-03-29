Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1C2VOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:14:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:39581 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1C2VOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:14:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,264,1299484800"; 
   d="scan'208";a="903262958"
Message-ID: <4D924BAF.1020906@linux.intel.com>
Date: Tue, 29 Mar 2011 14:14:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com> <4D8FF9BC.7050609@cn.fujitsu.com> <4D90647902000078000389CB@vpn.id2.novell.com>
In-Reply-To: <4D90647902000078000389CB@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 01:35 AM, Jan Beulich wrote:
>>>> On 28.03.11 at 05:00, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>
>> We can not include linux/sched.h in linux/rcupdate.h.
>> If we access task's task_rcu_strut without linux/sched.h included,
>> We will failed with compiling error.
>>
>> So we add TASK_RCU_OFFSET, which help us access
>> task's task_rcu_strut without linux/sched.h included.
>> Now, task_rcu_struct(), current_task_rcu_struct(), task_of_task_rcu() and
>> rcu_copy_process() can be used anywhere without linux/sched.h included.
> 
> Aren't the offsets-generation methods meant for assembly
> consumption only? Header dependency problems normally can
> be solved by splitting headers into a type declaration one and
> a second one carrying inline function implementations. Is that
> indeed completely impossible here?
> 

I have to say that if we have to use hardcoded offsets in C then we have
bigger problems.

	-hpa
