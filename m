Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1AaTTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:19:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab1AaTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:19:13 -0500
Date: Mon, 31 Jan 2011 20:11:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110131191109.GA10906@redhat.com>
References: <1296134077.15234.161.camel@laptop> <20110127165712.GC25060@redhat.com> <1296148294.15234.242.camel@laptop> <20110127221856.GA10539@redhat.com> <1296215577.15234.333.camel@laptop> <1296226667.15234.337.camel@laptop> <20110128162847.GA25088@redhat.com> <1296238278.15234.340.camel@laptop> <20110131172626.GA5407@redhat.com> <1296498205.26581.54.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296498205.26581.54.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Peter Zijlstra wrote:
>
> On Mon, 2011-01-31 at 18:26 +0100, Oleg Nesterov wrote:
>
> > I do not understand the point of cpu_function_call() though, it looks
> > equal to smp_call_function_single() ?
>
> Very nearly so, except it takes a function that returns an int..

Ah, indeed...

> > >  	raw_spin_lock(&ctx->lock);
> > > -	ctx->is_active = 1;
> > > +	WARN_ON_ONCE(!ctx->is_active);
> >
> > This looks wrong if ctx->task == NULL.
>
> cpuctx->ctx should still have ->is_active = 1 I think.

Unless this is the first cpu counter, no?

Oleg.

