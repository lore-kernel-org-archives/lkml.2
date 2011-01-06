Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1AFHtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 02:49:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:22189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1AFHtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 02:49:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,282,1291622400"; 
   d="scan'208";a="643983356"
Subject: Re: [PATCH 7/7] perf: Add load latency monitoring on Intel
 Nehalem/Westmere v2
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1294149804.2016.142.camel@laptop>
References: <1293464397.2695.109.camel@localhost>
	 <1294142361.2016.131.camel@laptop>  <1294149804.2016.142.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 15:49:15 +0800
Message-ID: <1294300155.9261.62.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 22:03 +0800, Peter Zijlstra wrote:
> On Tue, 2011-01-04 at 12:59 +0100, Peter Zijlstra wrote:
> > 
> > Right, so I think I want this in 3 patches, one adding the load-latency
> > extra reg thing and PERF_SAMPLE_ADDR usage, one adding
> > PERF_SAMPLE_LATENCY and one adding PERF_SAMPLE_EXTRA, I really dislike
> > the LATENCY_DATA name since that ties the extra data to the latency
> > thing, which isn't at all true for other platforms.
> 
> Also, this wants a 4th patch to be fully mergable, we want to have
> tools/perf/ support for these things..

I am thinking what can be added to perf tools....

Seems the average load latency values for each data source and data
linear address is useful.

We may add these support to perf stat or perf record/report.

Any other idea?

data source			average load latency(cycles)
=========			=============================
Unknown L3			xxx
L1-local			xxx
L2-snoop			xxx
....
....
L3-miss,remote,exclusive        xxx
IO                              xxx
Uncached memory                 xxx


data linear address		avergage load latency(cycles)
===================		=============================
xxxxxxx				xxx
xxxxxxx				xxx
xxxxxxx				xxx
....
....

Thanks,
Lin Ming

