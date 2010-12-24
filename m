Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0LWPTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:19:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:47002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0LWPTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:19:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,219,1291622400"; 
   d="scan'208";a="586679405"
Date: Thu, 23 Dec 2010 23:28:09 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Youquan Song <youquan.song@intel.com>, davej@redhat.com,
        cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
	governor power efficiency
Message-ID: <20101224042809.GA15773@linux-youquan.bj.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com> <20101223144220.GB1402@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223144220.GB1402@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 02:42:20PM +0000, Matthew Garrett wrote:
> We've generally been assuming (rightly or wrongly) that getting into 
> deep C states is preferable to being active (even at a lower frequency), 
> and so the current behaviour of tending to rapidly switch to the maximum 
> P state isn't inherently a problem. What kind of power savings are you 
> benchmarking with this, and do you still see a saving if you just 
> disable turbo mode?

Thanks a lot! Matthew.
Running the well-known power and performance benchmark,
performance/watts improve around 10%, the performance without drop.
Other benchmarks: kernel buiding and compress-7zip, power saving 2%~5%,
the performance also without drop.
Exception was: apache benchmark, it will let the performance drop
without much power save.  These say that it depends on workload itself
to save how much power.

I also consider that this patchset is effective to save power when workload
intermediately be idle, during the idle period, the workload is purely
idle not waiting for something happened. Because the low frequency will
try to fill up these idle periods while Turbo frequency execute quickly
consume much more power than low frequency, then be purely idle.  In
this situation, use low frequency will save power.
But if the workload is not purely idle,we low the frequency to execute,
it will sacrifice the performance while it also do not save power. 
In this situation, I will try to decrease to sampling window to samping
rate (10ms), it will roll back and keep the same behaviour as original
ondemand does.  I need more investigation about how to identify out
these purely idle or not.  Do you have idea about it?

I run benchmark at two situations: one is userspace governor, set all cpu frequency
P1 and other is set to powersave, there is no much different between these two
result. So it say that there is not much value to tuning between Pn to
P1(no-turbo mode). 

While I compare result of userspace with all P1 frequency and
Performance(Turbo Mode), there are much room to tuning.  It is the
original drive for me to do this patchset. 
  
Thanks
-Youquan
