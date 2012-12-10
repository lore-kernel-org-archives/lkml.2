Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2LJEGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 23:06:46 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38487 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2LJEGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 23:06:44 -0500
Message-ID: <50C55F6A.4040909@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 09:34:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 7/9] yield_to(), cpu-hotplug: Prevent offlining
 of other CPUs properly
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173950.27305.39499.stgit@srivatsabhat.in.ibm.com> <20121209194826.GB2816@redhat.com> <50C4ED46.3070100@linux.vnet.ibm.com> <20121209204053.GA6593@redhat.com>
In-Reply-To: <20121209204053.GA6593@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121004-5816-0000-0000-000005C47470
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 02:10 AM, Oleg Nesterov wrote:
> On 12/10, Srivatsa S. Bhat wrote:
>>
>> On 12/10/2012 01:18 AM, Oleg Nesterov wrote:
>>>> -		if (preempt && rq != p_rq)
>>>> +		if (preempt && rq != p_rq && cpu_online(task_cpu(p)))
>>>
>>> Why do we need this change?
>>>
>>> Afaics, you could add BUG_ON(!cpu_online(...)) instead?
>>>
>>> I am just curious.
>>>
>>
>> Oh, I think that's a remnant of v1 (which needed readers to use
>> cpu_online_stable()). You're right, we don't need it.
> 
> Ah OK, thanks.
> 
>> Or we could put a
>> BUG_ON instead, like you suggested.
> 
> IMHO it would be better to simply drop this chunk.
> 

Sure, will drop it. Its distracting, if nothing else ;-)

Regards,
Srivatsa S. Bhat

