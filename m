Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1LHAxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:53:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:10631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1LHAxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:53:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84109878"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Date: Wed, 7 Dec 2011 16:53:44 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acy1LuSW3oGVdkLGQVSZJW9VJ3SB+gAE7MQw
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EF3B51C@orsmsx508.amr.corp.intel.com>
References: <20111206084230.GC30062@elte.hu>
 <20111206085816.GA11116@elte.hu> <4EDDE5D0.7030906@linux.vnet.ibm.com>
 <20111206103500.GD15966@elte.hu> <4EDDF2DE.7020701@linux.vnet.ibm.com>
 <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
 <20111207074035.GC16942@elte.hu>
 <0207C53569FE594381A4F2EB66570B2A018EED1381@orsmsx508.amr.corp.intel.com>
 <20111207222151.GB18356@elte.hu>
In-Reply-To: <20111207222151.GB18356@elte.hu>
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

> The question is, how realistically does this report true CPU 
> troubles, statistically? The on-die cache might have the highest 
> transistor count, but it's not under nearly the same thermal 
> stress as functional units.
>
> If 90% of all hard CPU failures can be predicted that way then 
> it's probably useful. If it's only 20%, then not so much.

Intel doesn't release error rates - so I can't help with data here.

> Also, it's still all theoretical until there's systems out there 
> where the CPU socket is physically hotpluggable. If there's such 
> plans in the works then sure, theory becomes reality and then 
> it's all useful - and then we can do these patches (and more).

No - physical removal of the cpu is not a requirement for this
to be useful.  If you have a system that is reporting cache
problems via the "yellow" status in the MCi_STATUS msr, then
there is benefit in simply soft off-lining the cores that share
that cache - assuming that leaves you some online cores! A single
socket system with L3 cache troubles is not helped - but problems
in L1/L2 cache, or on multi-socket systems can be avoided (and
are already being avoided for the cases where CPU0 is not involved).

Physical removal of the cpu is a problem for Linux since Nehalem
(when memory controller moved on-die). Take away the cpu, and you
lose access to the memory connected to that socket - and we don't
have general solutions for memory removal.

-Tony
