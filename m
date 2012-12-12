Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2LLRYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:24:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2LLRY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:24:29 -0500
Date: Wed, 12 Dec 2012 18:24:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU
	offline from atomic context
Message-ID: <20121212172431.GA23328@redhat.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212171720.GA22289@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12, Oleg Nesterov wrote:
>
> On 12/11, Srivatsa S. Bhat wrote:
> >
> > IOW, the hotplug readers just increment/decrement their per-cpu refcounts
> > when no writer is active.
>
> plus cli/sti ;) and increment/decrement are atomic.
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

OOPS, sorry I was going to say "adds mb()".

And when I look at get_online_cpus_atomic() again it uses rmb(). This
doesn't look correct, we need the full barrier between this_cpu_inc()
and writer_active().

At the same time reader_nested_percpu() can be checked before mb().

Oleg.

