Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab2LUGoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:44:22 -0500
Received: from forward17.mail.yandex.net ([95.108.253.142]:59646 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LUGoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:44:18 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 01:44:18 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1356044865.5896.78.camel@gandalf.local.home>
References: <4807701355857948@web19f.yandex.ru>
	 <alpine.LFD.2.02.1212201852060.3148@ionos>
	 <401821356041818@web4f.yandex.ru> <1356044865.5896.78.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Move cpu rq properties from "struct rt_rq" to "struct rq"
MIME-Version: 1.0
Message-Id: <545781356071709@web16g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 21 Dec 2012 10:35:09 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



21.12.2012, 03:07, "Steven Rostedt" <rostedt@goodmis.org>:
> On Fri, 2012-12-21 at 02:16 +0400, Kirill Tkhai wrote:
>
>> š20.12.2012, 21:53, "Thomas Gleixner" <tglx@linutronix.de>:
>>> šOn Tue, 18 Dec 2012, Kirill Tkhai wrote:
>>>> ššThe members rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks are
>>>> ššproperties of cpu runqueue, not group rt_rq.
>>> šWhy?
>> šBecause, they depend on number and properties of all processes of rq, not of nested rt_rq.
>
> You're answer is still confusing.
>
> ššššššššstruct rq {
> šššššššššššššššš[...]
> ššššššššššššššššstruct rt_rq rt;
>
> rt_rq is just a part of rq. What's the point?
>
> ššššššššrq = container_of(rt_rq, struct rt_rq, rt);
>
> As the comment above struct rt_rq says:
>
> /* Real-Time classes' related field in a runqueue: */
>
> Those look like fields related to the Real-Time class. I don't see them
> used outside of kernel/sched/rt.c
>
                                    
           entity_1->my_q_1
           /                        
          /                         
rq->rt  -entity_2->my_q_2
          \                          
           \                           
             entity_n->my_q_n
                                        

I say about child rt_rqs (my_q_1....my_q_n). They don't have rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks.
The only use of overloaded, for example, is "rq->rt.overloaded". The same with other variables.

Kirill


> -- Steve
>
>>> šThanks,
>>>
>>> ššššššššštglx
