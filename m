Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0DUJ5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:57:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0DUJ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:57:52 -0400
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271842974.3794.16.camel@minggr.sh.intel.com>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271764547.13968.69.camel@minggr.sh.intel.com>
	 <1271764993.1676.431.camel@laptop>
	 <1271837295.3794.3.camel@minggr.sh.intel.com>
	 <m2q7c86c4471004210132id258e98y47134ab3bd486efe@mail.gmail.com>
	 <1271839190.3794.5.camel@minggr.sh.intel.com>
	 <i2j7c86c4471004210144kd8223bfbve5d6bee2820d0ccf@mail.gmail.com>
	 <1271842974.3794.16.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 11:57:49 +0200
Message-ID: <1271843869.1776.65.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 17:42 +0800, Lin Ming wrote:
> +       /*
> +        * TBD: will move this to pmu register function
> +        * when multiple hw pmu support is added
> +        */
> +       pmu.flag = alloc_percpu(u8);
> +       if (!pmu.flag)
> +               return; 

Why not simply use a field in struct cpu_hw_events?

That's where we track all per-cpu pmu state.

