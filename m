Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0GCMzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 08:55:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab0GCMzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 08:55:39 -0400
Date: Sat, 3 Jul 2010 14:54:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
Subject: Re: [rfc] Describe events in a structured way via sysfs
Message-ID: <20100703125402.GA17661@elte.hu>
References: <1277191359.5025.4.camel@minggr.sh.intel.com>
 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
 <20100624093625.GA26931@elte.hu>
 <1277396053.3870.16.camel@jlt3.sipsolutions.net>
 <20100624173315.GA30403@elte.hu>
 <1277792114.5400.5.camel@minggr.sh.intel.com>
 <20100629085532.GE22344@elte.hu>
 <1277803248.5400.16.camel@minggr.sh.intel.com>
 <20100629102656.GA25512@elte.hu>
 <1278057996.3841.26.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278057996.3841.26.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3104]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> On Tue, 2010-06-29 at 18:26 +0800, Ingo Molnar wrote:
> > * Lin Ming <ming.m.lin@intel.com> wrote:
> > 
> > > > Also, we can (optionally) consider 'generic', subsystem level events to 
> > > > also show up under:
> > > > 
> > > >    /sys/bus/pci/drivers/i915/events/
> > > > 
> > > > This would give a model to non-device-specific events to be listed one 
> > > > level higher in the sysfs hierarchy.
> > > > 
> > > > This too would be done in the driver, not by generic code. It's generally 
> > > > the driver which knows how the events should be categorized.
> > > 
> > > This is a bit difficult. I'd like not to touch TRACE_EVENT(). [...]
> > 
> > We can certainly start with the simpler variant - it's also the more common 
> > case.
> > 
> > > [...] How does the driver know if an event is 'generic' if TRACE_EVENT is 
> > > not touched?
> > 
> > Well, it's per driver code which creates the 'events' directory anyway, so 
> > that code decides where to link things. It can link it to the per driver kobj 
> > - or to the per subsys kobj.
> > 
> > > > I'd imagine something similar for wireless drivers as well - most 
> > > > currently defined events would show up on a per device basis there.
> > > > 
> > > > Can you see practical problems with this scheme?
> > > 
> > > Not now. I may find some problems when write more detail code.
> > 
> > Ok. Feel free to post RFC patches (even if they are not fully complete yet), 
> > so that we can see how things are progressing.
> > 
> > I suspect the best approach would be to try to figure out the right sysfs 
> > placement for one or two existing driver tracepoints, so that we can see it 
> > all in practice. (Obviously any changes to drivers will have to go via the 
> > relevant driver maintainer tree(s).)
> 
> Well, take i915 tracepoints as an example, the sys structures as below
> 
> /sys/class/drm/card0/events/
> |-- i915_gem_object_bind
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_object_change_domain
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_object_clflush
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_object_create
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_object_destroy
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_object_get_fence
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_object_unbind
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_request_complete
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_request_flush
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_request_retire
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_request_submit
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_request_wait_begin
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_gem_request_wait_end
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> |-- i915_ring_wait_begin
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
> `-- i915_ring_wait_end
>     |-- enable
>     |-- filter
>     |-- format
>     `-- id
> 
> And below is the very draft patch to export i915 tracepoints in sysfs.
> Is it the right direction?

Yeah, i think so.

The per driver impact is small and to the point:

>  drivers/gpu/drm/i915/i915_drv.c |   15 +++-

>  i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
> -	return drm_get_dev(pdev, ent, &driver);
> +	struct kobject *kobj;
> +	struct drm_device *drm_dev;
> +	int ret;
> +
> +	ret = drm_get_dev(pdev, ent, &driver);
> +
> +	if (!ret) {
> +		drm_dev = pci_get_drvdata(pdev);
> +		kobj = &drm_dev->primary->kdev.kobj;
> +		perf_sys_register_tp(kobj, "i915");
> +	}
> +
> +	return ret;

(It could be even shorter - the same compactness comment as i made last time 
still holds for this function.)

Thanks,

	Ingo
