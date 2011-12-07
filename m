Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab1LGRIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:08:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:8813 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab1LGRIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:08:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,314,1320652800"; 
   d="scan'208";a="99705121"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
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
Date: Wed, 7 Dec 2011 09:08:00 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acy0s8OVoATHaErkSeqxQxmVwdQRIgATV5hw
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EED1381@orsmsx508.amr.corp.intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com> <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com> <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
 <20111207074035.GC16942@elte.hu>
In-Reply-To: <20111207074035.GC16942@elte.hu>
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

> More importantly, you generally *cannot* realistically continue 
> with a bad CPU anyway - the system will crash or will show signs 
> of corruptions and you *want* a full powerdown and a clean 
> reboot.

See the "Enhanced cache error reporting" section in the Intel
Software Developers manual (section 15.4 in volume 3B of the
latest edition).  Intel provides what is probably a very early
notification in many cases that a processors cache is experiencing
problems. At the time of the notification the system is still
functioning correctly.  The SDM suggests that when the "yellow"
status is signaled you should schedule service "within a few weeks".

24x7 systems with a lot of sockets & cores, and highly paranoid
administrators, might want to take action to stop using the cores
that share the cache with problems sooner than they can schedule
downtime.

>- Special hardware environments that are deeply redundant and 
>   can warn about 'soft' failures well before hard failures
>   which gives a realistic window of time for a maintenance
>   hot-swap. [Such hardware actually exists, i even worked with
>   an x86 one eons ago.]

So not so special any more - every Xeon since Core Duo has the
cache error reporting capability.

-Tony
