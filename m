Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0DNUqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:46:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:27087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab0DNUqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,206,1270450800"; 
   d="scan'208";a="613169059"
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270189239.6513.78.camel@marge.simson.net>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1270099940.6707.148.camel@marge.simson.net>
	 <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
	 <1270189239.6513.78.camel@marge.simson.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 14 Apr 2010 13:45:23 -0700
Message-Id: <1271277923.2875.35.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 23:20 -0700, Mike Galbraith wrote:
> Do you have a compute load bouncing painfully which this patch cures?
> 
> I have no strong objections, and the result is certainly easier on the
> eye.  If I were making the decision, I'd want to see some numbers.

Mike, PeterZ,

Finally got sometime to get back to this and provide some data backing
up my patch under discussion. Here are my test results:

System is a two socket quad-core NHM-EP with SMT enabled and the
workload is specjbb2005.

Warehouses    	Throughput
	     tip   tip+proposed-fix
    1	    35142   35027
    2	    73563   75977
    3	   105806  109836
    4	   133421  142490
    5	   152151  168888
    6	   164936  195392
    7	   184763  208155
    8	   192419  223846

PeterZ, I think the above clearly shows that we have a problem with the
current -tip code. Please consider the proposed patch (which can be
found at http://marc.info/?l=linux-kernel&m=127007936408754&w=2)

Mike, with the above data, can I have your Ack for the patch?

thanks,
suresh

