Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2LIV2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 16:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2LIV2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 16:28:23 -0500
Date: Sun, 9 Dec 2012 21:40:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 7/9] yield_to(), cpu-hotplug: Prevent offlining
	of other CPUs properly
Message-ID: <20121209204053.GA6593@redhat.com>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173950.27305.39499.stgit@srivatsabhat.in.ibm.com> <20121209194826.GB2816@redhat.com> <50C4ED46.3070100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C4ED46.3070100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Srivatsa S. Bhat wrote:
>
> On 12/10/2012 01:18 AM, Oleg Nesterov wrote:
> >> -		if (preempt && rq != p_rq)
> >> +		if (preempt && rq != p_rq && cpu_online(task_cpu(p)))
> >
> > Why do we need this change?
> >
> > Afaics, you could add BUG_ON(!cpu_online(...)) instead?
> >
> > I am just curious.
> >
>
> Oh, I think that's a remnant of v1 (which needed readers to use
> cpu_online_stable()). You're right, we don't need it.

Ah OK, thanks.

> Or we could put a
> BUG_ON instead, like you suggested.

IMHO it would be better to simply drop this chunk.

Oleg.

