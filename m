Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1KOACm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:02:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:44295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab1KOACk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:02:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="75495121"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Date: Mon, 14 Nov 2011 16:02:28 -0800
Subject: RE: [PATCH] kernel/cpu.c: Add right qualifiers for
 intel_thermal_interrupt() and cpu_hotplug_pm_sync_init()
Thread-Topic: [PATCH] kernel/cpu.c: Add right qualifiers for
 intel_thermal_interrupt() and cpu_hotplug_pm_sync_init()
Thread-Index: AcygQ8PkmGsESIxcSXG/ocKdEvXzowC2gd7Q
Message-ID: <493994B35A117E4F832F97C4719C4C0401EE048E46@orsmsx505.amr.corp.intel.com>
References: <1320956564-21334-1-git-send-email-fenghua.yu@intel.com>
 <4EBCCE33.2090708@linux.vnet.ibm.com>
In-Reply-To: <4EBCCE33.2090708@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -int cpu_hotplug_pm_sync_init(void)
> > +static int __init cpu_hotplug_pm_sync_init(void)
> >  {
> >  	pm_notifier(cpu_hotplug_pm_callback, 0);
> 
> pm_notifier() macro will declare a static variable. I agree this won't
> be any problem functionality-wise. But it doesn't seem elegant to say
> "throw away the function but keep the static variable".
> So, if you want to add __init qualifier to this function, I suggest
> that
> you declare the static variable outside the function, and call
> register_pm_notifier() in the function, just to ensure it doesn't
> obscure
> things.
> 
Rmoving __init cpu_hotplug_pm_sync_init() function after boot time and keep the static data defined in pm_notifier() is a normal behavior and normal usage in kernel. Same notifier registration usage function examples are ia64_mca_init() and msic_init() in mrst.c. There are quite a few other similar static data in __init functions usage examples in kernel source code.

So I would keep the same code in the patch.

I'll send an updated patch just to change the title typo.

Thanks.

-Fenghua

