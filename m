Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2DLERg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:17:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:13662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab2DLERW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140717121"
Message-ID: <4F86571F.7090005@intel.com>
Date: Thu, 12 Apr 2012 12:16:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        venki@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kernel panic on NHM EX machine
References: <4F7ED569.6080103@intel.com> <20120409223100.GQ2430@linux.vnet.ibm.com> <4F838734.9090700@intel.com> <20120410143551.GA2428@linux.vnet.ibm.com> <20120412024651.GA7250@localhost>
In-Reply-To: <20120412024651.GA7250@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 10:46 AM, Fengguang Wu wrote:

> Hi all,
> 
> This commit makes a difference. Found by auto bisection and confirmed
> by reverting it on top of v3.4-rc2.  Attached is my kconfig.
> 
> commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Fri Nov 4 17:18:21 2011 -0700
> 
>     clockevents: Leave the broadcast device in shutdown mode when not needed
>     
>     Platforms with Always Running APIC Timer doesn't use the broadcast timer
>     but the kernel is leaving the broadcast timer (HPET in this case)
>     in oneshot mode.
>     
>     On these platforms, before the switch to oneshot mode, broadcast device is
>     actually in shutdown mode. Code checks for empty tick_broadcast_mask and
>     avoids going into the periodic mode.
>     
>     During switch to oneshot mode, add the same tick_broadcast_mask checks in the
>     tick_broadcast_switch_to_oneshot() and avoid the broadcast device going into
>     the oneshot mode.
>     
>     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Cc: john stultz <johnstul@us.ibm.com>
>     Cc: venki@google.com
>     Link: http://lkml.kernel.org/r/1320452301.15071.16.camel@sbsiddha-desk.sc.intel.com
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


It made loopback netperf performance regression on NHM-EP, I thought it
is due to few local timers missing on EP, but didn't know it is totally
out of work on EX.



