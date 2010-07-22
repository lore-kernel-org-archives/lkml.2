Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab0GVNIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:08:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759367Ab0GVNIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:08:04 -0400
Date: Thu, 22 Jul 2010 15:07:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lin Ming <ming.m.lin@intel.com>, Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
Subject: Re: [RFC][PATCH v1 15/15] perf: export tracepoint events via sysfs:
 mac80211
Message-ID: <20100722130700.GA4800@elte.hu>
References: <1279797496.20942.98.camel@minggr.sh.intel.com>
 <1279797702.12439.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279797702.12439.12.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Thu, 2010-07-22 at 19:18 +0800, Lin Ming wrote:
> > mac80211 tracepoint events are exported like below,
> > 
> > /sys/class/ieee80211/events/
> > |-- api_beacon_loss
> > |   |-- config
> > |   |-- type
> > ....
> > ....
> > |-- drv_add_interface
> > |   |-- config
> > |   |-- type
> > ....
> > ....
> > |-- stop_queue
> > |   |-- config
> > |   |-- type
> > |-- wake_queue
> > |   |-- config
> > |   |-- type
> > ---
> >  drivers/base/class.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/base/class.c b/drivers/base/class.c
> > index 8e231d0..57ada53 100644
> > --- a/drivers/base/class.c
> > +++ b/drivers/base/class.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/genhd.h>
> >  #include <linux/mutex.h>
> > +#include <linux/perf_event.h>
> >  #include "base.h"
> >  
> >  #define to_class_attr(_attr) container_of(_attr, struct class_attribute, attr)
> > @@ -160,6 +161,14 @@ static void klist_class_dev_put(struct klist_node *n)
> >  	put_device(dev);
> >  }
> >  
> > +extern struct class ieee80211_class;
> > +
> > +static void class_sys_add_tp(struct kobject *class_kobj, struct class *cls)
> > +{
> > +	if (cls == &ieee80211_class)
> > +		perf_sys_add_tp(class_kobj, "mac80211");
> > +}
> > +
> 
> Ick, what a bad hack! [...]

Yeah, putting driver specific code into generic code for a prototype is OK but 
not acceptable as an end result.

Thanks,

	Ingo
