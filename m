Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0HPRi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:38:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:39848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0HPRi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,377,1278313200"; 
   d="scan'208";a="313082967"
Subject: Re: [patch 2/3] sched: fix minimum power returned by
 update_cpu_power()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>
In-Reply-To: <1281945037.1926.954.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.909546779@sbsiddha-MOBL3.sc.intel.com>
	 <1281945037.1926.954.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 16 Aug 2010 10:37:59 -0700
Message-Id: <1281980279.2676.24.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 00:50 -0700, Peter Zijlstra wrote:
> On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> > plain text document attachment (fix_update_cpu_power.patch)
> > Default cpu_power needs to be multiples of SCHED_LOAD_SCALE and not '1'.
> > Fix it.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> >  kernel/sched_fair.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: tree/kernel/sched_fair.c
> > ===================================================================
> > --- tree.orig/kernel/sched_fair.c
> > +++ tree/kernel/sched_fair.c
> > @@ -2309,7 +2309,7 @@ static void update_cpu_power(struct sche
> >  	power >>= SCHED_LOAD_SHIFT;
> >  
> >  	if (!power)
> > -		power = 1;
> > +		power = SCHED_LOAD_SCALE;
> >  
> 
>                             smt_power   freq_power    rt_power
> power = SCHED_LOAD_SCALE * ---------- * ---------- * ----------
>                            LOAD_SCALE   LOAD_SCALE   LOAD_SCALE
> 
> Which, in the above case ends up being 0, so how does resetting it back
> to LOAD_SCALE make sense?

hmm, true, but I thought I saw some load balancing code which was
depending on SCHED_LOAD_SCALE value. Ignore this for now. Will get back
to you if this indeed is a problem.

thanks,
suresh

