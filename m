Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab1LGWYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:24:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496Ab1LGWYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:24:03 -0500
Date: Wed, 7 Dec 2011 23:21:51 +0100
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
Message-ID: <20111207222151.GB18356@elte.hu>
References: <20111206084230.GC30062@elte.hu>
 <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com>
 <20111206103500.GD15966@elte.hu>
 <4EDDF2DE.7020701@linux.vnet.ibm.com>
 <4EDDFB8E.10801@linux.vnet.ibm.com>
 <20111206130351.GC28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5A53@orsmsx508.amr.corp.intel.com>
 <20111207074035.GC16942@elte.hu>
 <0207C53569FE594381A4F2EB66570B2A018EED1381@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EED1381@orsmsx508.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > More importantly, you generally *cannot* realistically 
> > continue with a bad CPU anyway - the system will crash or 
> > will show signs of corruptions and you *want* a full 
> > powerdown and a clean reboot.
> 
> See the "Enhanced cache error reporting" section in the Intel 
> Software Developers manual (section 15.4 in volume 3B of the 
> latest edition).  Intel provides what is probably a very early 
> notification in many cases that a processors cache is 
> experiencing problems. At the time of the notification the 
> system is still functioning correctly.  The SDM suggests that 
> when the "yellow" status is signaled you should schedule 
> service "within a few weeks".

The question is, how realistically does this report true CPU 
troubles, statistically? The on-die cache might have the highest 
transistor count, but it's not under nearly the same thermal 
stress as functional units.

If 90% of all hard CPU failures can be predicted that way then 
it's probably useful. If it's only 20%, then not so much.

Also, it's still all theoretical until there's systems out there 
where the CPU socket is physically hotpluggable. If there's such 
plans in the works then sure, theory becomes reality and then 
it's all useful - and then we can do these patches (and more).

Thanks,

	Ingo
