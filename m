Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2FFPYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:24:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:28163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2FFPX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153746969"
Message-ID: <4FCF760A.7030501@linux.intel.com>
Date: Wed, 06 Jun 2012 08:23:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com> <1338913190.2749.10.camel@twins> <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com> <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos> <1338925756.2749.36.camel@twins> <alpine.LFD.2.02.1206052153200.3086@ionos> <1338931856.2749.57.camel@twins> <20120605221240.GW2388@linux.vnet.ibm.com> <1338972223.2749.79.camel@twins> <20120606144127.GF19601@linux.vnet.ibm.com>
In-Reply-To: <20120606144127.GF19601@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2012 7:41 AM, Paul E. McKenney wrote:
> On Wed, Jun 06, 2012 at 10:43:43AM +0200, Peter Zijlstra wrote:
>> On Tue, 2012-06-05 at 15:12 -0700, Paul E. McKenney wrote:
>>>> What I can't see is the isolated functional, aside from the above
>>>> mentioned things, that's not strictly a per-cpu property, we can have a
>>>> group that's isolated from the rest but not from each other.
>>>
>>> I suspect that Thomas is thinking that the CPU is so idle that it no
>>> longer has to participate in TLB invalidation or RCU.  (Thomas will
>>> correct me if I am confused.)  But Peter, is that the level of idle
>>> you are thinking of? 
>>
>> No, we're talking about isolated, so its very much running something.
> 
> From what I can see, if the CPU is running something, this is Thomas's
> "Isolated functional" state rather than his "Isolated idle" state.
> The isolated-idle state should not need to participate in TLB invalidation
> or RCU, so that the CPU never ever needs to wake up while in the
> isolated-idle state.

btw TLB invalidation I think is a red herring in this discussion
(other than "global PTEs" kind of kernel pte changes);
at least on x86 this is not happening for a long time; if a CPU is
really idle (which means the CPU internally flushes the tlbs anyway),
Linux also switches to the kernel PTE set so there's no need for a flush
later on.
