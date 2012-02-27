Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2B0WMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:12:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:22991 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab2B0WMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:12:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="115409086"
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Mon, 27 Feb 2012 14:11:22 -0800
In-Reply-To: <1330158655.11655.58.camel@marge.simpson.net>
References: <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
	 <1329761661.6276.146.camel@marge.simpson.net>
	 <20120223104959.GA8454@linux.vnet.ibm.com>
	 <1329996064.7411.106.camel@marge.simpson.net>
	 <20120225065403.GB12313@linux.vnet.ibm.com>
	 <1330158655.11655.58.camel@marge.simpson.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330380683.23436.16.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-25 at 09:30 +0100, Mike Galbraith wrote:
> My less rotund config shows the L2 penalty decidedly more prominently.
> We used to have avg_overlap as a synchronous wakeup hint, but it was
> broken by preemption and whatnot, got the axe to recover some cycles.  A
> reliable and dirt cheap replacement would be a good thing to have.
> 
> TCP_RR and tbench are far way away from the overlap breakeven point on
> E5620, whereas with Q6600s shared L2, you can start converting overlap
> into throughput almost immediately. 
> 
> 2.4 GHz E5620
> Throughput 248.994 MB/sec 1 procs  SD_SHARE_PKG_RESOURCES
> Throughput 379.488 MB/sec 1 procs  !SD_SHARE_PKG_RESOURCES
> 
> 2.4 GHz Q6600
> Throughput 299.049 MB/sec 1 procs  SD_SHARE_PKG_RESOURCES
> Throughput 300.018 MB/sec 1 procs  !SD_SHARE_PKG_RESOURCES
> 

Also it is not always about just the L2 cache being shared/not or
warm/cold etc. It also depends on the core c-states/p-states etc. It
will cost waking up an idle core and the cost will depend on the what
core-c state it is in. And also if we ping-pong between cores often,
cpufreq governor will come and request for a lower core p-state even
though the load was keeping one core or the other in the socket always
busy at any given point of time.

thanks,
suresh

