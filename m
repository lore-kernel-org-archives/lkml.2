Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab1JDSCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:02:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:14270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab1JDSCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,486,1312182000"; 
   d="scan'208";a="70245981"
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle
 balance
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Tue, 04 Oct 2011 11:03:32 -0700
In-Reply-To: <1317719121.25926.15.camel@twins>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
	 <1317719121.25926.15.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317751412.11592.170.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 02:05 -0700, Peter Zijlstra wrote:
> On Mon, 2011-10-03 at 15:09 -0700, Suresh Siddha wrote:
> > +               smp_mb();
> > +               /*
> > +                * Use smp_send_reschedule() instead of resched_cpu().
> > +                * This way we generate a sched IPI on the target cpu which
> > +                * is idle. And the softirq performing nohz idle load balance
> > +                * will be run before returning from the IPI.
> > +                */
> > +               smp_send_reschedule(ilb_cpu); 
> 
> Now the only thing missing is where the matching barrier is, does
> receiving an interrupt imply a mb? If so that wants mentioning
> somewhere, otherwise people will wonder how we can ever read the right
> value.

This is similar to resched_task()? Isn't it?

I am expecting the interrupt handlers will be already having the
necessary memory barriers, if the arch requires it.

thanks,
suresh


