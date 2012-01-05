Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab2AEJNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:13:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab2AEJND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:13:03 -0500
Date: Thu, 5 Jan 2012 10:10:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20120105091059.GA3249@elte.hu>
References: <20111230095147.GA10543@elte.hu>
 <878vlu4bgh.fsf@linux.vnet.ibm.com>
 <87pqf5mqg4.fsf@abhimanyu.in.ibm.com>
 <4F017AD2.3090504@redhat.com>
 <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
 <4F046536.5080207@redhat.com>
 <4F048295.1050907@redhat.com>
 <4F04898B.1080600@redhat.com>
 <1325712710.3084.10.camel@laptop>
 <4F04C789.40209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F04C789.40209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > So why wait for non-running vcpus at all? That is, why not 
> > paravirt the TLB flush such that the invalidate marks the 
> > non-running VCPU's state so that on resume it will first 
> > flush its TLBs. That way you don't have to wake it up and 
> > wait for it to invalidate its TLBs.
> 
> That's what Xen does, but it's tricky.  For example 
> get_user_pages_fast() depends on the IPI to hold off page 
> freeing, if we paravirt it we have to take that into 
> consideration.
> 
> > Or am I like totally missing the point (I am after all 
> > reading the thread backwards and I haven't yet fully paged 
> > the kernel stuff back into my brain).
> 
> You aren't, and I bet those kernel pages are unswappable 
> anyway.
> 
> > I guess tagging remote VCPU state like that might be 
> > somewhat tricky.. but it seems worth considering, the whole 
> > wake and wait for flush thing seems daft.
> 
> It's nasty, but then so is paravirt.  It's hard to get right, 
> and it has a tendency to cause performance regressions as 
> hardware improves.

Here it would massively improve performance - without regressing 
the scheduler code massively.

Or you accept that the hardware does not support intelligent TLB 
flushing yet, hope for future hw to fix it, and live with the 
performance impact for now.

Thanks,

	Ingo
