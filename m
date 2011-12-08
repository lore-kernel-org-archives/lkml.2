Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1LHEpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:45:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41414 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1LHEpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:45:04 -0500
Date: Thu, 8 Dec 2011 05:43:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Borislav Petkov <bp@amd64.org>,
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
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111208044303.GA9485@elte.hu>
References: <4EDDE5D0.7030906@linux.vnet.ibm.com>
 <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com>
 <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
 <20111207074035.GC16942@elte.hu>
 <0207C53569FE594381A4F2EB66570B2A018EED1381@orsmsx508.amr.corp.intel.com>
 <20111207222151.GB18356@elte.hu>
 <0207C53569FE594381A4F2EB66570B2A018EF3B51C@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EF3B51C@orsmsx508.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > The question is, how realistically does this report true CPU 
> > troubles, statistically? The on-die cache might have the 
> > highest transistor count, but it's not under nearly the same 
> > thermal stress as functional units.
> >
> > If 90% of all hard CPU failures can be predicted that way 
> > then it's probably useful. If it's only 20%, then not so 
> > much.
> 
> Intel doesn't release error rates - so I can't help with data 
> here.

Well, precise data won't be needed - but we need *something* 
indicative to justify the feature - faith alone won't be enough.

Is there any third party research on this? I remember that 
Google released hard drive failure stats a few years ago, maybe 
there's some approximate data about CPU "soft" failure rates. 
Even anecdotal data and speculation/estimation would be a start 
- it could be contradicted later on by more precise data, once 
people start using the "generic CPU hot-unplug" feature. (which 
this feature should really be named, instead of the 'BSP unplug' 
name.)

> > Also, it's still all theoretical until there's systems out 
> > there where the CPU socket is physically hotpluggable. If 
> > there's such plans in the works then sure, theory becomes 
> > reality and then it's all useful - and then we can do these 
> > patches (and more).
> 
> No - physical removal of the cpu is not a requirement for this 
> to be useful. [...]

Indeed, you are right, i stand corrected there.

Okay, i'm convinced, i guess we can do this.

> [...]
>
> Physical removal of the cpu is a problem for Linux since 
> Nehalem (when memory controller moved on-die). Take away the 
> cpu, and you lose access to the memory connected to that 
> socket - and we don't have general solutions for memory 
> removal.

It's possible technically but not the easiest of features - also 
i suspect Linus would object to the naive breaking of the 
semi-linear kernel mapping we do today ;-)

But if someone implements that in a sane way, using at least 2MB 
granular mappings [or maybe ORDER_MAX granular mappings], which 
keeps 2MB TLBs, and uses a quick hash table for __pa() and 
__va(), i would definitely take a look at how ugly it ends up 
being. Our hibernation code already gives us a generic way to 
quiescence all DMA activity on the system, so most of the 
building blocks are in place.

Thanks,

	Ingo
