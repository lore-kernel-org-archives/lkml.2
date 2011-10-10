Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1JJNwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1JJNwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:52:40 -0400
Date: Mon, 10 Oct 2011 09:52:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle
 balance
Message-ID: <20111010135220.GC21169@redhat.com>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
 <20111006172731.GA31781@redhat.com>
 <1318032586.11592.206.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318032586.11592.206.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 05:09:46PM -0700, Suresh Siddha wrote:
> On Thu, 2011-10-06 at 10:27 -0700, Vivek Goyal wrote:
> > On Mon, Oct 03, 2011 at 03:09:00PM -0700, Suresh Siddha wrote:
> > [..]
> > > 
> > >    [ This issue is present from 2.6.35+ kernels, but marking it -stable
> > >      only from v3.0+ as the proposed fix depends on the scheduler_ipi()
> > >      that is introduced recently. ]
> > > 
> > 
> > Hi Suresh,
> > 
> > Are you planning to fix this issue for older kernels too? I am wondering
> > how to go about fixing it there.
> > 
> 
> Vivek, Initially when Prarit brought this issue to me, I gave an ugly
> quick fix (Appended) for a quick try. But I would recommend we back port
> the couple of mainline patches that introduced scheduler_ipi() code
> along with these two patches. Thoughts?

I agree that backporting scheduler_ipi() patches makes more sense.
Browsing through the code looks like we need just one commit which
introduced scheduler_ipi().

commit 184748cc50b2dceb8287f9fb657eda48ff8fcfe7
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Apr 5 17:23:39 2011 +0200

    sched: Provide scheduler_ipi() callback in response to smp_send_reschedule()

I did partial backport of above to come up with a fix for rhel6 and put
your first patch on top of it. 

Once your current patches get merged, I can backport above and two of
your patches for older kernel is there is interest.

Thanks
Vivek
