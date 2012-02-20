Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2BTMCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:02:32 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46605 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BTMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:02:31 -0500
Date: Mon, 20 Feb 2012 17:32:00 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20120220120159.GA2350@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
 <4F046536.5080207@redhat.com>
 <4F048295.1050907@redhat.com>
 <4F04898B.1080600@redhat.com>
 <1325712710.3084.10.camel@laptop>
 <4F04C789.40209@redhat.com>
 <20120105091059.GA3249@elte.hu>
 <87fwe6ork3.fsf@abhimanyu.in.ibm.com>
 <1329735073.2293.305.camel@twins>
 <877gzhpvpv.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <877gzhpvpv.fsf@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022012-8256-0000-0000-00000152A5CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> [2012-02-20 17:23:16]:

> On Mon, 20 Feb 2012 11:51:13 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2012-02-20 at 13:38 +0530, Nikunj A Dadhania wrote:
> > > +#ifdef CONFIG_PARAVIRT_FLUSH_TLB
> > > +               while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
> > > +                       cpu_relax();
> > > +               if (!loop && !cpumask_empty(to_cpumask(f->flush_cpumask)))
> > > +                       halt();
> > 
> > 
> > That's just vile, you don't need to wait for it, all you need to make
> > sure is that when that vcpu wakes up it does the flush.
> >
> Yes, but we are not sure the vcpu will be sleeping or running. In the
> case where vcpus are running, it might be beneficial to wait a while.

I guess one possibility is for host scheduler to export run/preempt
information to guest OS, as was discussed in the context of this thread
as well:

http://lkml.org/lkml/2010/4/6/223

Essentially guest OS will know (using such exported information) which of its 
vcpus are currently running and thus do a busy-wait for them.

- vatsa

