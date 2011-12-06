Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab1LFNyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:54:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156Ab1LFNyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:54:47 -0500
Date: Tue, 6 Dec 2011 14:52:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Fenghua Yu <fenghua.yu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111206135246.GC30018@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
 <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com>
 <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com>
 <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206130351.GC28735@gere.osrc.amd.com>
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


* Borislav Petkov <bp@amd64.org> wrote:

> On Tue, Dec 06, 2011 at 04:55:02PM +0530, Srivatsa S. Bhat wrote:
>
> > By the way, this problem is not tied to CPU0 alone, it 
> > exists for any CPU! (as long as we are talking about 
> > plugging in/out CPUs physically).
> 
> Just a reminder: before you guys go and wander off into the 
> woods of hypothetical with this, please make sure this use 
> case is relevant enough for the trouble. The only real reason 
> given so far AFAICT was RAS and to be able to offline BSP in 
> order to prolong system life before maintenance.
> 
> When you take it down for maintenance eventually, you don't 
> need to suspend but simply poweroff.

I think it's definitely a marginal and speculative feature - but 
the patches don't look overly complicated, so i'm not 
*completely* against removing various boot-CPU assumptions 
(although i'm predisposed against it) - if it is correct and if 
there's someone interested in doing proper patches.

All in one, the quality threshold for inclusion is very high but 
not an infinite number.

The specific point i tried to make about s2ram is to make sure 
it does not break during normal usage: for example someone 
offlines the boot CPU, but the box then gets suspended - that 
should not hang or crash.

Thanks,

	Ingo
