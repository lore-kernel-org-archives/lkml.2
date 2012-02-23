Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2BWLUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:20:16 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49964 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab2BWLUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:20:14 -0500
Date: Thu, 23 Feb 2012 16:50:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120223112005.GA7645@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
 <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <20120223104959.GA8454@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120223104959.GA8454@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022301-0260-0000-0000-0000009709AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2012-02-23 16:19:59]:

> > Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> > Maybe that has changed, but I doubt it.  (general aside: testing with a
> > bloated distro config is a big mistake)
> 
> I am seeing 2.6% _improvement_ in volanomark score by enabling SD_BALANCE_WAKE
> at SMT/MC domains.

Ditto with pipe benchmark.

> Machine : 2 Quad-core Intel X5570 CPU (H/T enabled)
> Kernel  : tip (HEAD at 6241cc8)

"perf bench sched pipe" was run 10 times and average ops/sec score
alongwith std. dev is noted as below.


		SD_BALANCE_WAKE		SD_BALANCE_WAKE
		 disabled		enabled

Avg. score	108984.900 		111844.300 (+2.6%)
std dev		20383.457		21668.604

Note:

SD_BALANCE_WAKE for SMT/MC domain was enabled by writing into appropriate 
flags file present in /proc:

	# cd /proc/sys/kernel/sched_domain/
	# for i in `find . -name flags | grep domain1`; do echo 4671 > $i; done
	# for i in `find . -name flags | grep domain0`; do echo 703 > $i; done

- vatsa

