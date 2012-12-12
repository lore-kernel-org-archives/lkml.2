Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2LLSXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:23:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:23:06 -0500
Date: Wed, 12 Dec 2012 19:23:08 +0100
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
Message-ID: <20121212182308.GA26094@redhat.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com> <20121212172431.GA23328@redhat.com> <50C8C8C9.2070605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C8C8C9.2070605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12, Srivatsa S. Bhat wrote:
>
> On 12/12/2012 10:54 PM, Oleg Nesterov wrote:
>
> > And when I look at get_online_cpus_atomic() again it uses rmb(). This
> > doesn't look correct, we need the full barrier between this_cpu_inc()
> > and writer_active().
>
> Hmm..
>
> > At the same time reader_nested_percpu() can be checked before mb().
>
> I thought that since the increment and the check (reader_nested_percpu)
> act on the same memory location, they will naturally be run in the given
> order, without any need for barriers. Am I wrong?

And this is what I meant, you do not need a barrier before
reader_nested_percpu().

But you need to ensure that WRITE(reader_percpu_refcnt) and READ(writer_signal)
can't be reordered, so you need mb() in between. rmb() can serialize LOADs and
STOREs.

Or I misunderstood?

Oleg.

