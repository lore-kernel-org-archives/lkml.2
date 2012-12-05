Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2LEMp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:45:58 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51624 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LEMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:45:51 -0500
Message-ID: <50BF41A4.8010709@linux.vnet.ibm.com>
Date: Wed, 05 Dec 2012 18:14:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, tj@kernel.org,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] smp, cpu hotplug: Fix smp_call_function_*()
 to prevent CPU offline properly
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com> <20121204085419.25919.79543.stgit@srivatsabhat.in.ibm.com> <87obi9gzf9.fsf@rustcorp.com.au>
In-Reply-To: <87obi9gzf9.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120512-2674-0000-0000-000006FDCA74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 05:09 AM, Rusty Russell wrote:
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
>>
>> With stop_machine() gone from the CPU offline path, we can't depend on
>> preempt_disable() to prevent CPUs from going offline from under us.
> 
> Minor gripe: I'd prefer this paragraph to use the future rather than
> past tense, like: "Once stop_machine() is gone ... we won't be able to
> depend".
> 

Fixed in the new version.

> Since you're not supposed to use the _stable() accessors without calling
> get_online_cpus_stable_atomic(), why not have
> get_online_cpus_stable_atomic() return a pointer to the stable cpumask?
> (Which is otherwise static, at least for debug).
>

We don't have to worry about this now because the new version doesn't
use stable cpumask.
 
> Might make the patches messier though...
> 
> Oh, and I'd love to see actual benchmarks to make sure we've actually
> fixed a problem with this ;)
> 

Of course :-) They will follow, once we have a proper implementation
that we are happy with :-)

Regards,
Srivatsa S. Bhat

