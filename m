Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2FERuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:50:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58548 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2FERut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:50:49 -0400
Message-ID: <1338918625.2749.29.camel@twins>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 19:50:25 +0200
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	 <1338881971.28282.150.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	 <1338912565.2749.9.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	 <1338913190.2749.10.camel@twins>
	 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 17:44 +0000, Luck, Tony wrote:
> > Like what? Offline is nothing more than a C state on x86. 
> 
> Offline is a bigger hammer than idle.
> 
> When a core is idle it may take an interrupt which wakes it up to use power.
> The scheduler may assign a process to run on it, which will wake it up to use power.
> 
> When a core is offline we take extra steps (re-routing interrupts, telling the
> scheduler it is not available for work) to make sure it STAYS in that low
> power state.

You also wreck cpusets, cpu affinity and you need some userspace crap to
poll state trying to figure out when to wake up again.

(And yes, I've heard stories about userspace hotplug daemons that cause
machine wakeups themselves and were a main source of power usage at some
point).

All the timer/interrupt nonsense needs to be fixed anyhow, the HPC and
RT people want isolation anyway.

So shouldn't we all start by fixing the entire
load-balancer/timer/interrupt madness before we start swinging stupid
big hammers around that break half the interfaces we have?
