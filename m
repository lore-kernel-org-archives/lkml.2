Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2ADVaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:30:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:45729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2ADVaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:30:12 -0500
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
In-Reply-To: <4F04898B.1080600@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
	 <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com>
	 <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com>
	 <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com>
	 <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com>
	 <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com>
	 <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com>
	 <4F048295.1050907@redhat.com>  <4F04898B.1080600@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 22:31:50 +0100
Message-ID: <1325712710.3084.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 19:16 +0200, Avi Kivity wrote:
> 
> 
> I think we can solve it at the guest level.  The paravirt ticketlock
> stuff introduces wait/wake calls (actually wait is just a HLT
> instruction); we could spin for a while, then HLT until the other side
> wakes us.  We should do this for all sites that busy wait.
> 
This is all TLB invalidates, right?

So why wait for non-running vcpus at all? That is, why not paravirt the
TLB flush such that the invalidate marks the non-running VCPU's state so
that on resume it will first flush its TLBs. That way you don't have to
wake it up and wait for it to invalidate its TLBs.

Or am I like totally missing the point (I am after all reading the
thread backwards and I haven't yet fully paged the kernel stuff back
into my brain).

I guess tagging remote VCPU state like that might be somewhat tricky..
but it seems worth considering, the whole wake and wait for flush thing
seems daft.

