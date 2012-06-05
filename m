Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2FETvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:51:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:45012 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab2FETva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:51:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148585824"
Message-ID: <4FCE6341.3080105@linux.intel.com>
Date: Tue, 05 Jun 2012 12:51:29 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
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
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>   <alpine.LFD.2.02.1206042203590.3086@ionos>   <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>   <1338881971.28282.150.camel@twins>   <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>  <1338912565.2749.9.camel@twins>   <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>   <1338913190.2749.10.camel@twins>   <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>  <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos> <1338925756.2749.36.camel@twins>
In-Reply-To: <1338925756.2749.36.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2012 12:49 PM, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 21:43 +0200, Thomas Gleixner wrote:
>> Vs. the interrupt/timer/other crap madness:
>>
>>  - We really don't want to have an interrupt balancer in the kernel
>>    again, but we need a mechanism to prevent the user space balancer
>>    trainwreck from ruining the power saving party.
> 
> What's wrong with having an interrupt balancer tied to the scheduler
> which optimistically tries to avoid interrupting nohz/isolated/idle
> cpus?

ideally threaded interrupts are like this.. we really should push for
more usage of such and it all falls into place


