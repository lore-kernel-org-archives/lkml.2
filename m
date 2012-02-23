Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2BWMSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:18:50 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43764 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab2BWMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:18:49 -0500
Date: Thu, 23 Feb 2012 17:48:25 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120223121825.GC8454@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <20120223104959.GA8454@linux.vnet.ibm.com>
 <20120223111929.GA23646@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120223111929.GA23646@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022312-5816-0000-0000-0000016B2DC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-02-23 12:19:29]:

> sysbench is one of the best ones punishing bad scheduler 
> balancing mistakes.

Here are the sysbench oltp score on same machine i.e:

Machine : 2 Quad-core Intel X5570 CPU (H/T enabled)
Kernel  : tip (HEAD at 6241cc8)
sysbench : 0.4.12

sysbench was run with 16 threads as:

./sysbench --num-threads=16 --max-requests=100000 --test=oltp --oltp-table-size=500000 --mysql-socket=/var/lib/mysql/mysql.sock --oltp-read-only --mysql-user=root --mysql-password=blah run

sysbench was run 5 times with fs-cache being purged before each run
(echo 3 > /proc/sys/vm/drop_caches).

Average of 5 runs alongwith % std. dev. is noted for various OLTP stats

				SD_BALANCE_WAKE		SD_BALANCE_WAKE	
				disabled		enabled

transactions (per sec)		4833.826 (+- 0.75%)	4837.354 (+- 1%)
read/write requests (per sec)	67673.580 (+- 0.75%)	67722.960 (+- 1%)
other ops (per sec)		9667.654 (+- 0.75%)	9674.710 (+- 1%)

There is minor improvement seen when SD_BALANCE_WAKE is enabled at SMT/MC
domains, but no degradation observed with it enabled.

- vatsa

