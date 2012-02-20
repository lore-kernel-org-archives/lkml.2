Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2BTLxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:53:41 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42393 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BTLxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:53:40 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <1329735073.2293.305.camel@twins>
References: <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com> <4F048295.1050907@redhat.com> <4F04898B.1080600@redhat.com> <1325712710.3084.10.camel@laptop> <4F04C789.40209@redhat.com> <20120105091059.GA3249@elte.hu> <87fwe6ork3.fsf@abhimanyu.in.ibm.com> <1329735073.2293.305.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 20 Feb 2012 17:23:16 +0530
Message-ID: <877gzhpvpv.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12022001-5140-0000-0000-000000C597E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 11:51:13 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-02-20 at 13:38 +0530, Nikunj A Dadhania wrote:
> > +#ifdef CONFIG_PARAVIRT_FLUSH_TLB
> > +               while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
> > +                       cpu_relax();
> > +               if (!loop && !cpumask_empty(to_cpumask(f->flush_cpumask)))
> > +                       halt();
> 
> 
> That's just vile, you don't need to wait for it, all you need to make
> sure is that when that vcpu wakes up it does the flush.
>
Yes, but we are not sure the vcpu will be sleeping or running. In the
case where vcpus are running, it might be beneficial to wait a while.

For example: If its a remote flush to only one of the vcpu and its
already running, is it worthed to halt and come back?

Regards,
Nikunj

