Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2LETJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:09:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab2LETJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:09:18 -0500
Date: Wed, 5 Dec 2012 20:08:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 10/10] cpu: No more __stop_machine() in
	_cpu_down()
Message-ID: <20121205190836.GB13795@redhat.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184456.3750.35005.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205184456.3750.35005.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Srivatsa S. Bhat wrote:
>
> @@ -418,7 +418,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  	}
>  	smpboot_park_threads(cpu);
>
> -	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
> +	err = stop_cpus(cpumask_of(cpu), take_cpu_down, &tcd_param);

stop_one_cpu(cpu) ?

Oleg.

