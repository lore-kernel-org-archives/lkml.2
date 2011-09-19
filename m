Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1ISQfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:35:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34825 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab1ISQfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:35:43 -0400
Date: Mon, 19 Sep 2011 22:05:28 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110919163528.GC21064@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110908151433.GB6587@linux.vnet.ibm.com>
 <1315571462.26517.9.camel@twins>
 <20110912101722.GA28950@linux.vnet.ibm.com>
 <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
 <1315923579.5977.14.camel@twins>
 <20110913180146.GA12723@linux.vnet.ibm.com>
 <1315938226.4226.11.camel@twins>
 <4E730568.2030107@google.com>
 <1316161720.10174.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1316161720.10174.0.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-16 10:28:40]:

> > I think more compelling here is that it looks like nohz load-balance 
> > needs more love.
> 
> Quite probable,

Staring at nohz load-balancer for sometime, I see a potential issue:

'first_pick_cpu' and 'second_pick_cpu' can be idle without stopping
ticks for quite a while. When that happens, they stop bothering to
kick ilb cpu because of this snippet in nohz_kick_needed():

   static inline int nohz_kick_needed(struct rq *rq, int cpu)
   {

	..

        if (rq->idle_at_tick)
                return 0;

	..

   }


?

- vatsa
