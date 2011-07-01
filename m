Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1GAF7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:59:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:10857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab1GAF7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:59:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="22238827"
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309442903.12449.55.camel@twins>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
	 <1309442903.12449.55.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 14:05:01 +0800
Message-ID: <1309500301.24590.116.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 22:08 +0800, Peter Zijlstra wrote:
> On Thu, 2011-06-30 at 08:09 +0000, Lin Ming wrote:
> > +static struct pmu uncore_pmu = {
> 
> 	.task_ctx_nr = perf_invalid_context,

OK.

usage: perf stat [<options>] [<command>]

Currently, "perf stat" always need a <command> to do counting.
Need to change it to be optional.

So I may add a "P" option to specify which physical processor to count.

perf stat -P 3 -e uncore:rXXXX

> 
> > +       .event_init     = uncore_pmu_event_init,
> > +       .add            = uncore_pmu_add,
> > +       .del            = uncore_pmu_del,
> > +       .start          = uncore_pmu_start,
> > +       .stop           = uncore_pmu_stop,
> > +       .read           = uncore_pmu_read,
> > +}; 
> 
> 


