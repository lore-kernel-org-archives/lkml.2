Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab1LOSiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:38:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:24691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1LOSiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:38:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86992560"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Date: Thu, 15 Dec 2011 10:38:20 -0800
Subject: RE: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Topic: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Thread-Index: Acyz80FWSVwMVpHLRvmP5EOvAk1d4wHZBMOw
Message-ID: <43F901BD926A4E43B106BF17856F075501A4A62498@orsmsx508.amr.corp.intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
In-Reply-To: <20111206084230.GC30062@elte.hu>
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

> We need a debug feature for this: CONFIG_DEBUG_BOOT_CPU_OFF=y or
> such (disabled by default): this feature would offline the boot
> CPU as soon as possible, and boot up userspace with the boot CPU
> offlined.

I would think the earliest time when CPU0 can be offline is right after do_initcalls() because do_initcalls() installs some cpu hotplug notifier.

But this will change generic code (e.g. add arch hook in init/main.c or add a new initcall level which is after level 7s).

Another way is to offline CPU0 (or any CPU) in /etc/rc.local. By this way, we don't change kernel. And this is safe, but a bit later than in kernel.

Any comment?

Thanks.

-Fenghua
