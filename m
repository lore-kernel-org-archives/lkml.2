Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1LGAFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:05:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:65131 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab1LGAFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:05:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,309,1320652800"; 
   d="scan'208";a="44566434"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Date: Tue, 6 Dec 2011 16:04:56 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acy0HpwUzalDeSmQRsaez4gjH9nmhwAUv02w
Message-ID: <43F901BD926A4E43B106BF17856F075501A22B5A21@orsmsx508.amr.corp.intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com> <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com> <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com> <20111206135246.GC30018@elte.hu>
In-Reply-To: <20111206135246.GC30018@elte.hu>
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

> 
> The specific point i tried to make about s2ram is to make sure
> it does not break during normal usage: for example someone
> offlines the boot CPU, but the box then gets suspended - that
> should not hang or crash.
> 
This has been considered in the patch #7/7. There shouldn't be a problem here (in theory).

Suspend/hibernate calls callback bsp_pm_callback() and must pass this check before it can continue.

When CPU0 is offline, bsp_pm_callback() returns -ENODEV and suspend/hibernate fails. When CPU0 is online, bsp_pm_callback() returns 0 and suspend/hibernate can continue.

So when CPU0 is offline, system cannot suspend/hibernate. Suspend/hibernate can succeed only when CPU0 is online.

Plus the patch #7/7 considers race condition by pm_notifier_call_chain()'s priority in pm call chain. So there should be race issue here.

Thanks.

-Fenghua
