Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0GWB76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:59:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:61927 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0GWB75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:59:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="303404227"
Subject: Re: Fwd: [RFC][PATCH v1 11/15] perf: export tracepoint events via
 sysfs: 	power
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTincVAsbxJk0IR4mkdP1kIuefQiSxy--_0Xeskbc@mail.gmail.com>
References: <1279797433.20942.94.camel@minggr.sh.intel.com>
	 <201007222353.48942.rjw@sisk.pl>
	 <AANLkTincVAsbxJk0IR4mkdP1kIuefQiSxy--_0Xeskbc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 10:00:06 +0800
Message-ID: <1279850406.24607.29.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Rafael J. Wysocki <rjw@sisk.pl>
> Date: Fri, Jul 23, 2010 at 5:53 AM
> Subject: Re: [RFC][PATCH v1 11/15] perf: export tracepoint events via
> sysfs: power
> 
> 
> On Thursday, July 22, 2010, Lin Ming wrote:
> > power tracepoint events are exported like below,
> >
> > /sys/power/events/
> > |-- power_end
> > |   |-- config
> > |   `-- type
> > |-- power_frequency
> > |   |-- config
> > |   `-- type
> > `-- power_start
> >     |-- config
> >     `-- type
> 
> Any details?

Sorry that I didn't include you in the patch description.

[RFC][PATCH v1 00/15] perf: export events in a structured way via sysfs
http://lkml.org/lkml/2010/7/22/141

> 
> > ---
> >  kernel/power/main.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/power/main.c b/kernel/power/main.c
> > index b58800b..6749374 100644
> > --- a/kernel/power/main.c
> > +++ b/kernel/power/main.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/string.h>
> >  #include <linux/resume-trace.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/perf_event.h>
> >
> >  #include "power.h"
> >
> > @@ -269,6 +270,9 @@ static int __init pm_init(void)
> >       power_kobj = kobject_create_and_add("power", NULL);
> >       if (!power_kobj)
> >               return -ENOMEM;
> > +
> > +     perf_sys_add_tp(power_kobj, "power");
> > +
> 
> Why isn't it done in drivers/base/power/sysfs.c ?

The sysfs thing in drivers/base/power/sysfs.c is per device.
But the power tracepoint events are not per device, right?

Lin Ming

> 
> >       return sysfs_create_group(power_kobj, &attr_group);
> >  }
> 
> Rafael


