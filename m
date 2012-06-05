Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2FETte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:49:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37096 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2FETtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:49:32 -0400
Message-ID: <1338925756.2749.36.camel@twins>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 21:49:16 +0200
In-Reply-To: <alpine.LFD.2.02.1206052106440.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	  <alpine.LFD.2.02.1206042203590.3086@ionos>
	  <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	  <1338881971.28282.150.camel@twins>
	  <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	 <1338912565.2749.9.camel@twins>
	  <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	  <1338913190.2749.10.camel@twins>
	  <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	 <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 21:43 +0200, Thomas Gleixner wrote:
> Vs. the interrupt/timer/other crap madness:
> 
>  - We really don't want to have an interrupt balancer in the kernel
>    again, but we need a mechanism to prevent the user space balancer
>    trainwreck from ruining the power saving party.

What's wrong with having an interrupt balancer tied to the scheduler
which optimistically tries to avoid interrupting nohz/isolated/idle
cpus?

>  - The timer issue is mostly solved by the existing nohz stuff
>    (plus/minus the few bugs in there).

Its not.. if you create an isolated domain there's no way to expel
existing timers from there.

>  - The other details (silly IPIs) and cross CPU timer arming) are way
>    easier to solve by a proper prohibitive state than by chasing that
>    nonsense all over the tree forever. 

But we need to solve all that without a prohibitibe state anyway for the
isolation stuff to be useful.


