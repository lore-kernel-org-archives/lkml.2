Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2LETNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:13:53 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36816 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2LETNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:13:50 -0500
Message-ID: <50BF9C8A.3060806@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 00:42:10 +0530
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
Subject: Re: [RFC PATCH v2 10/10] cpu: No more __stop_machine() in	_cpu_down()
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184456.3750.35005.stgit@srivatsabhat.in.ibm.com> <20121205190836.GB13795@redhat.com>
In-Reply-To: <20121205190836.GB13795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120519-3864-0000-0000-000005DDE813
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 12:38 AM, Oleg Nesterov wrote:
> On 12/06, Srivatsa S. Bhat wrote:
>>
>> @@ -418,7 +418,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>>  	}
>>  	smpboot_park_threads(cpu);
>>
>> -	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
>> +	err = stop_cpus(cpumask_of(cpu), take_cpu_down, &tcd_param);
> 
> stop_one_cpu(cpu) ?
> 

Even I was thinking of using that. Paul, any particular reason you chose
stop_cpus() over stop_one_cpu() in [1]?

[1]. https://lkml.org/lkml/2012/10/30/359

Regards,
Srivatsa S. Bhat

