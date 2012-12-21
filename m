Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2LUMwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:52:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9210 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2LUMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:51:54 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=kMKUP9VcE-gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ErkLabmjQQoA:10 a=R8mZSiGc1X9eDgQI46QA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356094312.5896.97.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Move cpu rq properties from "struct rt_rq" to
 "struct rq"
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 07:51:52 -0500
In-Reply-To: <545781356071709@web16g.yandex.ru>
References: <4807701355857948@web19f.yandex.ru>
	 <alpine.LFD.2.02.1212201852060.3148@ionos>
	 <401821356041818@web4f.yandex.ru>
	 <1356044865.5896.78.camel@gandalf.local.home>
	 <545781356071709@web16g.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 10:35 +0400, Kirill Tkhai wrote:
> 
>                                    
>            entity_1->my_q_1
>            /                        
>           /                         
> rq->rt  -entity_2->my_q_2
>           \                          
>            \                           
>              entity_n->my_q_n
>                                         
> 
> I say about child rt_rqs (my_q_1....my_q_n). They don't have rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks.
> The only use of overloaded, for example, is "rq->rt.overloaded". The same with other variables.

You're missing the point. rt_rq is not just for entities, it's the
encapsulation of the rt class.

Now if you want to encapsulate the rt sched group, then you could add a
new struct and put that into the rt_rq struct and use that for all the
group functions. But please don't just cludder the rq struct with rt
specific data. The rt_rq was created as a container for the rt class.

-- Steve


