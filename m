Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1LGHme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:42:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49286 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1LGHmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:42:32 -0500
Date: Wed, 7 Dec 2011 08:40:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111207074035.GC16942@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
 <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com>
 <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com>
 <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yu, Fenghua <fenghua.yu@intel.com> wrote:

> > When you take it down for maintenance eventually, you don't 
> > need to suspend but simply poweroff.
> 
> Agree with you. To maintain a system with a bad CPU, either 
> you hot plug or hot replace the CPU, or you power off then 
> replace the CPU. Replacing the CPU between suspend and resume 
> doesn't seem a normal RAS behavior.

More importantly, you generally *cannot* realistically continue 
with a bad CPU anyway - the system will crash or will show signs 
of corruptions and you *want* a full powerdown and a clean 
reboot.

The usecases for real CPU hotplug look pretty limited to me:

 - Special hardware environments that are deeply redundant and 
   can warn about 'soft' failures well before hard failures
   which gives a realistic window of time for a maintenance
   hot-swap. [Such hardware actually exists, i even worked with
   an x86 one eons ago.]

 - Swapping slower CPUs for a faster CPUs, without any downtime.
   Given that mixed steppings and mixed frequencies are
   generally pretty unpredictable even with no hotswap in the
   picture, i can see hw designers (and qa test matrix
   engineers) cringe at the idea.

Thanks,

	Ingo
