Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab1LPAyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:54:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:64893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1LPAyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:54:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87108911"
Subject: Re: [RFC] sched: Ensure cpu_power periodic update
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>
Date: Thu, 15 Dec 2011 16:58:58 -0800
In-Reply-To: <CAKfTPtB7Lib71iGrf=fGC5qtKFwD_qw3yz2OSkNy+CW7fCDtgw@mail.gmail.com>
References: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
	 <1323943710.18942.24.camel@twins>
	 <CAKfTPtB7Lib71iGrf=fGC5qtKFwD_qw3yz2OSkNy+CW7fCDtgw@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323997138.1984.274.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 05:36 -0800, Vincent Guittot wrote:
> I'm using cyclictest to easily reproduce the problem on my dual cortex-A9

So does the cyclictest itself exhibit the problem or running cyclictest
with another workload showed the problem? In other words, what numbers
of the workload did you see change with this patch?

> 
> > Then again, its probably easier to keep update_group_power on this_cpu
> > than to allow a remote update of your cpu_power.
> >
> 
> This additional path for updating the cpu_power will only be used by
> this_cpu because it is called by idle_balance. But we still have a
> call to update_group_power by a remote cpu when nohz_idle_balance is
> called.

As Vincent mentioned, the current mainline kernel already updates the
remote cpu's group_power in the nohz idle load balancing patch.

Also with all the recent nohz idle load balancing using kick, on a
dual-core system there may not be any nohz idle load balancing if
multiple tasks wakeup, run for short time and go back to idle before the
next tick. We rely on the wakeup balance to get it right in this case.

thanks,
suresh

