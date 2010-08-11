Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0HKMpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 08:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab0HKMpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 08:45:06 -0400
Date: Wed, 11 Aug 2010 08:44:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100811124443.GC4879@redhat.com>
References: <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100810204856.GA16571@redhat.com>
 <20100811024451.GA26835@nowhere>
 <20100811111046.GQ26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811111046.GQ26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 01:10:46PM +0200, Robert Richter wrote:
> > > +		 *
> > > +		 * NOTE: We have no way of knowing if a second NMI was
> > > +		 * actually triggered, so we may accidentally skip a valid
> > > +		 * unknown nmi later.
> > > +		 */
> > > +		__get_cpu_var(perfctr_skip) +=1;
> 
> ... but this will not work. You have to mark the *absolute* nmi number
> here. If you only raise a flag, the next unknown nmi will be dropped,
> every. Because, in between there could have been other nmis that
> stopped the chain and thus the 'unknown' path is not executed. The
> trick in my patch is that you *know*, which nmi you want to skip.

I guess I am confused.  The way I read your patch was that you assumed the
next NMI would be the one you skip and if there was another NMI in between
the handled one and the one to skip, you would not skip it (nmi count !=
prev + 1) and it would produce an accidental unknown nmi.

I tried to change that with my patch by setting the skip flag which would
be drained on the next unknown nmi, independent of where it is in the NMI
backlog of NMIs.

Did I misread something?

Cheers,
Don
