Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2FEU7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:59:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:34787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab2FEU7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:59:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108229230"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, "Luck\, Tony" <tony.luck@intel.com>,
        "Yu\, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick\, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or nmi
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	<alpine.LFD.2.02.1206042203590.3086@ionos>
	<1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	<1338881971.28282.150.camel@twins>
	<3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	<1338912565.2749.9.camel@twins>
	<3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	<1338913190.2749.10.camel@twins>
	<3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	<1338918625.2749.29.camel@twins>
	<alpine.LFD.2.02.1206052106440.3086@ionos>
Date: Tue, 05 Jun 2012 13:58:08 -0700
In-Reply-To: <alpine.LFD.2.02.1206052106440.3086@ionos> (Thomas Gleixner's
	message of "Tue, 5 Jun 2012 21:43:53 +0200 (CEST)")
Message-ID: <m2ipf5jx27.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>
> Vs. the interrupt/timer/other crap madness:
>
>  - We really don't want to have an interrupt balancer in the kernel
>    again, but we need a mechanism to prevent the user space balancer
>    trainwreck from ruining the power saving party.

Why not? I think the kernel is exactly the right place for it.
It's essentially a scheduling problem. Scheduling in user space
is not a good idea.

With MSI-X the drivers just want a static setting. User space
shouldn't mess with it. 

Some of the workarounds for user space messing with it (like that
interrupt rmap code) are really bad and just a workaround for doing the
scheduling in the wrong place.

For dynamic changes it should indeed by part of scheduling,
following similar rules, with only high level policy input
from userland.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
