Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2FEVPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:15:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:47635 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FEVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:15:33 -0400
Date: Tue, 5 Jun 2012 23:15:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Luck\\, Tony" <tony.luck@intel.com>,
        "Yu\\, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha\\, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick\\, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
In-Reply-To: <m2ipf5jx27.fsf@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1206052305370.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au> <1338881971.28282.150.camel@twins> <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
 <1338912565.2749.9.camel@twins> <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com> <1338913190.2749.10.camel@twins> <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com> <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos> <m2ipf5jx27.fsf@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Andi Kleen wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> >
> > Vs. the interrupt/timer/other crap madness:
> >
> >  - We really don't want to have an interrupt balancer in the kernel
> >    again, but we need a mechanism to prevent the user space balancer
> >    trainwreck from ruining the power saving party.
> 
> Why not? I think the kernel is exactly the right place for it.
> It's essentially a scheduling problem. Scheduling in user space
> is not a good idea.

No argument about scheduling in user space. Though the real problem is
where do you draw the line between mechanism and policy?
 
> With MSI-X the drivers just want a static setting. User space
> shouldn't mess with it. 
> 
> Some of the workarounds for user space messing with it (like that
> interrupt rmap code) are really bad and just a workaround for doing the
> scheduling in the wrong place.
> 
> For dynamic changes it should indeed by part of scheduling,
> following similar rules, with only high level policy input
> from userland.

I'd be happy to see a patch which implements all of that and avoids
the pitfalls of the old in kernel irq balancer along with the short
comings of the user space one.

Thanks,

	tglx
