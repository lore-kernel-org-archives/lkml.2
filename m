Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1LGAPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:15:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:32588 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab1LGAPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:15:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,309,1320652800"; 
   d="scan'208";a="93136031"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
Date: Tue, 6 Dec 2011 16:15:31 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acy0F4VrFgz+G0QRSRKoig9ETSc2HgAXIP6A
Message-ID: <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com> <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com> <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
In-Reply-To: <20111206130351.GC28735@gere.osrc.amd.com>
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


> From: Borislav Petkov [mailto:bp@amd64.org]
> On Tue, Dec 06, 2011 at 04:55:02PM +0530, Srivatsa S. Bhat wrote:
> > By the way, this problem is not tied to CPU0 alone, it exists for any
> > CPU! (as long as we are talking about plugging in/out CPUs
> physically).
> 
> Just a reminder: before you guys go and wander off into the woods of
> hypothetical with this, please make sure this use case is relevant
> enough for the trouble. The only real reason given so far AFAICT was
> RAS
> and to be able to offline BSP in order to prolong system life before
> maintenance.
> 
> When you take it down for maintenance eventually, you don't need to
> suspend but simply poweroff.

Agree with you. To maintain a system with a bad CPU, either you hot plug or hot replace the CPU, or you power off then replace the CPU. Replacing the CPU between suspend and resume doesn't seem a normal RAS behavior.

If you choose hotplug or hot replace the CPU, then this patchset is useful.

CPU0 offline/online is a must-have if you want to replace a socket which has the BSP in it for any errors in uncore or a sibling CPU. Not mention that CPU0 itself is bad and you want to hot unplug it.

Thanks.

-Fenghua
