Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab1LIHaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:30:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1LIHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:30:12 -0500
Date: Fri, 9 Dec 2011 08:28:17 +0100
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
Message-ID: <20111209072817.GI24537@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
 <43F901BD926A4E43B106BF17856F075501A23A3010@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F075501A23A3010@orsmsx508.amr.corp.intel.com>
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

> > 
> > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > Then if demand for this picks up some more intelligent method of
> > cooperating with the firmware could be added: the firmware could
> > actually signal to us whether it supports suspend/resume from
> > other than the boot CPU.
> 
> We started to think how to handle the resume issue in 
> firmware, e.g. the way you talked, or change boot CPU to 
> another online CPU to execute resume procedure.
> 
> A firmware solution is a long run. Currently we don't 
> suspend/hibernate when BSP is offline. If a firmware solution 
> is available, we can change the sanity check to allow 
> suspend/hibernate if CPU0 is offline for new firmware. But 
> even when the solution is available in new firmware, we still 
> need to do the same sanity check on legacy firmware.

Right.

You convinced me, if there's no objections i guess we could try 
this feature carefully, if it's named in some more descriptive 
manner such as:

   x86: Arbitrary CPU hot(un)plug support

Nobody outside x86 devs knows 'BSP' means and why they should 
care.

The minor usability/testability/self-test improvements i 
suggested need to be added as well.

Thanks,

	Ingo
