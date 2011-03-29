Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1C2JjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:39:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1C2JjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:39:24 -0400
Message-ID: <4D91A941.7090207@cn.fujitsu.com>
Date: Tue, 29 Mar 2011 17:41:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        serge.hallyn@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com> <4D8FF9BC.7050609@cn.fujitsu.com> <4D90647902000078000389CB@vpn.id2.novell.com>
In-Reply-To: <4D90647902000078000389CB@vpn.id2.novell.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-29 17:37:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-29 17:37:49,
	Serialize complete at 2011-03-29 17:37:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 04:35 PM, Jan Beulich wrote:
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

That will need to split >100 header files, it is almost impossible.

Thanks,
Lai
