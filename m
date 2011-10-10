Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1JJP0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab1JJP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:26:13 -0400
Date: Mon, 10 Oct 2011 11:25:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle
 balance
Message-ID: <20111010152542.GD21169@redhat.com>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
 <20111006172731.GA31781@redhat.com>
 <1318032586.11592.206.camel@sbsiddha-desk.sc.intel.com>
 <20111010135220.GC21169@redhat.com>
 <1318255564.14400.45.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318255564.14400.45.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 04:06:04PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-10 at 09:52 -0400, Vivek Goyal wrote:
> 
> > I did partial backport of above to come up with a fix for rhel6 and put
> > your first patch on top of it. 
> 
> You might also want to look at these for PPC64:
> 
> 23d72bfd8f9f24aa9efafed3586a99f5669c23d7

This seems to be just cleanup of the way IPI are handled in ppc64
(mux/demux). I don't understand the details but looks like not a
necessary component of the problem at hand.

> 880102e78547c1db158a17e36cf0cdd98e7ad710

Here Benjamin talks about following.

    Manual merge of arch/powerpc/kernel/smp.c and add missing scheduler_ipi()
    call to arch/powerpc/platforms/cell/interrupt.c

And I can't find any scheduler_ipi() call in current cell/interrupt.c. So
either it got moved or something else happend. CCing him to find out. 

Thanks
Vivek
