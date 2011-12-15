Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab1LOS7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:59:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322Ab1LOS7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:59:08 -0500
Date: Thu, 15 Dec 2011 19:57:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
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
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111215185707.GA12654@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
 <43F901BD926A4E43B106BF17856F075501A4A62498@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F075501A4A62498@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yu, Fenghua <fenghua.yu@intel.com> wrote:

> > We need a debug feature for this: 
> > CONFIG_DEBUG_BOOT_CPU_OFF=y or such (disabled by default): 
> > this feature would offline the boot CPU as soon as possible, 
> > and boot up userspace with the boot CPU offlined.
> 
> I would think the earliest time when CPU0 can be offline is 
> right after do_initcalls() because do_initcalls() installs 
> some cpu hotplug notifier.
> 
> But this will change generic code (e.g. add arch hook in 
> init/main.c or add a new initcall level which is after level 
> 7s).
> 
> Another way is to offline CPU0 (or any CPU) in /etc/rc.local. 
> By this way, we don't change kernel. And this is safe, but a 
> bit later than in kernel.
> 
> Any comment?

I think we should try to do this in the kernel, to keep the 
debug feature independent of user-space code. This also helps
us clean init code from boot CPU assumptions.

Not sure we need a new initlevel - why not just offline the CPU? 
I suspect the cpu hotplug notifier installation that is done in 
do_initcalls() should be moved earlier so that the boot CPU can 
be offlined as early as a secondary CPU is up and running.

Thanks,

	Ingo
