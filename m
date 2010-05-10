Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0EJKMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:12:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:14265 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab0EJKM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="796961071"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273484401.5605.3333.camel@twins>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
Content-Type: text/plain
Date: Mon, 10 May 2010 18:11:53 +0800
Message-Id: <1273486313.15998.76.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:40 +0800, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 17:27 +0800, Lin Ming wrote:
> > Export pmus via sysfs /sys/devices/system/cpu/pmus/0...N
> > The file name is the pmu id, ie, /sys/devices/system/cpu/pmus/N
> > represents pmu id N.
> > So perf tool can use it to initialize perf_event_attr. 
> 
> Why create a whole new directory, why not:
> 
>  /sys/devices/system/cpu/cpuN/pmu_id ?


Do you mean /sys/devices/system/cpu/cpuN/pmu_id contain all ids?

For example, each cpu has 4 pmus and the file pmu_id shows something
like,

#cat /sys/devices/system/cpu/cpu0/pmu_id
0 1 2 3

....

#cat /sys/devices/system/cpu/cpuN/pmu_id
0 1 2 3

> 
> That way we can simply extend it to things like:
> 
>  /sys/devices/system/cpu/cpuN/nodeN/pmu_id
>  /sys/devices/system/node/nodeN/pmi_id
> 
> Instead of having to add something like:
> 
>  /sys/devices/system/node/pmus/0..N
> 
> 

