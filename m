Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0DTFAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:00:46 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45778 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0DTFAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:00:44 -0400
Date: Tue, 20 Apr 2010 10:30:13 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Salman Qazi <sqazi@google.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, csadler@google.com,
       ranjitm@google.com, kenchen@google.com, dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100420050013.GC2915@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
 <1271317886.32749.69.camel@laptop>
 <h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
 <1271703701.1676.235.camel@laptop>
 <20100419180032.15586a90@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100419180032.15586a90@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2010-04-19 18:00:32]:

> On Mon, 19 Apr 2010 21:01:41 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Right, so the IBM folks who were looking at power aware scheduling
> > were working on an interface to quantify the amount of power to save.
> > 
> > But their approach, was an extension of the regular power aware
> > load-balancer, which basically groups tasks onto sockets so that whole
> > sockets can go idle.
> > 
> > However Arjan explained to me that your approach, which idles the
> > whole machine, has the advantage that also memory banks can go into
> > idle mode and save power.
> > 
> > Still in the interest to cut back on power-saving interfaces it would
> > be nice to see if there is anything we can do to merge these things,
> > but I really haven't thought much about that yet.
> 
> one correction, this is not about power *saving*, it is about power
> *capping*. Power capping is pretty much energy inefficient by
> definition (and surely in practice), but it's about dealing with
> reality about underdimensioned airconditioning or voltage rails....
> 
> Due to the reality that socket offlining isn't as good as idle
> insertion.. I rather focus on the later...

The power reduction benefit is architecture and topology dependent.
Like on POWER platform, socket offlining could provide better power
reduction than idle injection.

As mentioned by Arjan, these approaches help reduce average power
consumption to meet power and cooling limitation over a short
interval.  These are not general optimizations to improve operating
efficiency, however when use at certain workload and utilization
levels, these can potentially provide overall energy savings.

Having the SMP load balancer pull jobs away form a core or socket to
allow it to remain idle  for short burst of time will be an good
implementation.

--Vaidy

