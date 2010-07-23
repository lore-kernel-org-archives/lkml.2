Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0GWMC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:02:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab0GWMC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:02:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: Fwd: [RFC][PATCH v1 11/15] perf: export tracepoint events via sysfs: 
 =?utf-8?q?=09power?=
Date: Fri, 23 Jul 2010 13:58:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
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
References: <1279797433.20942.94.camel@minggr.sh.intel.com> <AANLkTincVAsbxJk0IR4mkdP1kIuefQiSxy--_0Xeskbc@mail.gmail.com> <1279850406.24607.29.camel@minggr.sh.intel.com>
In-Reply-To: <1279850406.24607.29.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007231358.31002.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Lin Ming wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Date: Fri, Jul 23, 2010 at 5:53 AM
> > Subject: Re: [RFC][PATCH v1 11/15] perf: export tracepoint events via
> > sysfs: power
> > 
> > 
> > On Thursday, July 22, 2010, Lin Ming wrote:
> > > power tracepoint events are exported like below,
> > >
> > > /sys/power/events/
> > > |-- power_end
> > > |   |-- config
> > > |   `-- type
> > > |-- power_frequency
> > > |   |-- config
> > > |   `-- type
> > > `-- power_start
> > >     |-- config
> > >     `-- type
> > 
> > Any details?
> 
> Sorry that I didn't include you in the patch description.
> 
> [RFC][PATCH v1 00/15] perf: export events in a structured way via sysfs
> http://lkml.org/lkml/2010/7/22/141

Thanks, I'll have a look at this later today.
 
> > > ---
> > >  kernel/power/main.c |    4 ++++
> > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/kernel/power/main.c b/kernel/power/main.c
> > > index b58800b..6749374 100644
> > > --- a/kernel/power/main.c
> > > +++ b/kernel/power/main.c
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/string.h>
> > >  #include <linux/resume-trace.h>
> > >  #include <linux/workqueue.h>
> > > +#include <linux/perf_event.h>
> > >
> > >  #include "power.h"
> > >
> > > @@ -269,6 +270,9 @@ static int __init pm_init(void)
> > >       power_kobj = kobject_create_and_add("power", NULL);
> > >       if (!power_kobj)
> > >               return -ENOMEM;
> > > +
> > > +     perf_sys_add_tp(power_kobj, "power");
> > > +
> > 
> > Why isn't it done in drivers/base/power/sysfs.c ?
> 
> The sysfs thing in drivers/base/power/sysfs.c is per device.
> But the power tracepoint events are not per device, right?

Right, sorry.

Rafael
