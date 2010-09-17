Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0IQCHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:07:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:15120 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab0IQCHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,380,1280732400"; 
   d="scan'208";a="838431286"
Subject: Re: high power consumption in recent kernels
From: "Alex,Shi" <alex.shi@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1284355277.26157.8109.camel@debian>
References: <1283840425.26157.6486.camel@debian>
	 <20100909093140.GC29648@gamma.logic.tuwien.ac.at>
	 <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
	 <1284355277.26157.8109.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 10:09:34 +0800
Message-ID: <1284689374.17745.89.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > - how to reduce the "extra timer interrupt"?
> The timer was listed in /proc/timer_stats, you can post its contents,
> and let's see what is abnormal here. 
> 
Norbert, did you try the patch? 
We are still thinking the too many "extra timer interrupts" on your
system, maybe the following message can give some help. So, could you
like to check if your system is using pit timer? 
#cat /proc/timer_list
Or some APP/system services in your system is using lots of timer? 

===
http://www.linuxpowertop.org/faq.php 

Even with a tickless kernel, there are some timer ticks still happening:

1.) For userspace events (also shown in the lower "top 10 events" list).
2.) The kernel still has timer ticks when userspace is executing code,
to sample and get data for the "top" program.
3.) Hardware timers have a maximum time they can be set for, for the PIT
timer (the one used if you don't have HPET active). This is around 27
milliseconds. If you would have longer sleep times than the maximum, the
kernel has no choice but to set the timer to the maximum repeatedly
until the actual event is approaching.

The "extra timer interrupts" data is a combination fo 1 and 3.

