Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2FEXN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:13:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2FEXN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:13:57 -0400
Date: Wed, 6 Jun 2012 01:13:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or nmi
Message-ID: <20120605231352.GF27374@one.firstfloor.org>
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com> <1338912565.2749.9.camel@twins> <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com> <1338913190.2749.10.camel@twins> <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com> <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos> <m2ipf5jx27.fsf@firstfloor.org> <alpine.LFD.2.02.1206052305370.3086@ionos> <alpine.LFD.2.02.1206052318420.3086@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206052318420.3086@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And aside of the above requirements it should add the ability to deal
> with the fact that aside of server workloads this needs to be able to
> cope with appplications in the embedded/mobile space which know more
> about the future system state than the scheduler itself.

Well solving world hunger in one try is hard. Baby steps are easier.

What I think would be useful short term is a clean mechanism for drivers
to lock a interrupt onto a CPU, without irqbalanced touching it. 
This would be mainly for MSI-X drivers to spread their interrupts properly
and give better performance out of the box.

Another short term case is the power aware interrupt routing now on recent 
Intel CPUs.  In this case the interrupt needs logical focus to multiple CPUs 
and the hardware makes the decision (essentially it does power aware load 
balancing in hardware). Again nobody else should touch it.

Then maybe this mechanism could be extended with a power aware 
software solution with some input from the load balancer like you suggested. 
I don't have a firm picture on how exactly it should work.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
