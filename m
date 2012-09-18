Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2IQP1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:27:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:60790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2IQP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:27:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,437,1344236400"; 
   d="scan'208";a="223056392"
Date: Mon, 17 Sep 2012 23:30:20 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, arjan@linux.intel.com, lenb@kernel.org,
        Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH V2 0/3] x86,idle: Enhance cpuidle prediction to handle
	its failure
Message-ID: <20120918033020.GA20862@linux-youquan.bj.intel.com>
References: <1347933209-25939-1-git-send-email-youquan.song@intel.com> <50573934.4030102@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50573934.4030102@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One case is turbostat utility (tools/power/x86/turbostat) at kernel 3.3 or early
> > . turbostat utility will read 10 registers one by one at Sandybridge, so it will
> > generate 10 IPIs to wake up idle CPUs. So cpuidle menu governor will predict it
> >  is repeat mode and there is another IPI wake up idle CPU soon, so it keeps idle
> >  CPU stay at C1 state even though CPU is totally idle. However, in the turbostat
> > , following 10 registers reading is sleep 5 seconds by default, so the idle CPU
> >  will keep at C1 for a long time though it is idle until break event occurs.
> > In a idle Sandybridge system, run "./turbostat -v", we will notice that deep 
> > C-state dangles between "70% ~ 99%". After patched the kernel, we will notice
> > deep C-state stays at >99.98%.
> 
> Is there an impact on performances ?

In this case, turbostat is utility to measure cpu idle status and itself
also is a workload to system. Its purpose is that show cpu C-state
information every 5 seconds. After patched the kernel, it also does
the same thing as usual. So I think the performance has no/little impact.

I do not find performance impact in my tests. If you performance impact cases or
suggestions, I will be very glad to try. 

Thanks
-Youquan
