Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1KOUOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:14:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40863 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab1KOUOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:14:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] kernel/cpu.c: Add right qualifiers for alloc_frozen_cpus() and cpu_hotplug_pm_sync_init()
Date: Tue, 15 Nov 2011 21:17:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>,
        "linux-next" <linux-next@vger.kernel.org>
References: <1321315040-4644-1-git-send-email-fenghua.yu@intel.com> <4EC200D4.9040505@linux.vnet.ibm.com>
In-Reply-To: <4EC200D4.9040505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111152117.15026.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 15, 2011, Srivatsa S. Bhat wrote:
> On 11/15/2011 05:27 AM, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > 
> > Add __init for functions alloc_frozen_cpus() and cpu_hotplug_pm_sync_init()
> > because they are only called during boot time.
> > 
> > Add static for function cpu_hotplug_pm_sync_init() because its scope is limited
> > in this file only.
> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Well, I guess I can take this one, right?  Any objections from anyone?

Rafael


> > ---
> > v2: Change a function name typo in the title.
> > 
> >  kernel/cpu.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index 563f136..cf915b8 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -470,7 +470,7 @@ out:
> >  	cpu_maps_update_done();
> >  }
> > 
> > -static int alloc_frozen_cpus(void)
> > +static int __init alloc_frozen_cpus(void)
> >  {
> >  	if (!alloc_cpumask_var(&frozen_cpus, GFP_KERNEL|__GFP_ZERO))
> >  		return -ENOMEM;
> > @@ -543,7 +543,7 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
> >  }
> > 
> > 
> > -int cpu_hotplug_pm_sync_init(void)
> > +static int __init cpu_hotplug_pm_sync_init(void)
> >  {
> >  	pm_notifier(cpu_hotplug_pm_callback, 0);
> >  	return 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

