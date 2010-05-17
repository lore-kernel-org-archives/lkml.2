Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab0EQWj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:39:27 -0400
Received: from crca.org.au ([74.207.252.120]:58335 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0EQWj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:39:26 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BF1C595.3070707@crca.org.au>
Date: Tue, 18 May 2010 08:39:17 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [patch 0/7] sched: change nohz idle load balancing logic to push
 model
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
In-Reply-To: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh.

On 18/05/10 04:27, Suresh Siddha wrote:
> This is an updated version of patchset which is posted earlier at
> http://lkml.org/lkml/2009/12/10/470
>
> Description:
> Existing nohz idle load balance logic uses the pull model, with one
> idle load balancer CPU nominated on any partially idle system and that
> balancer CPU not going into nohz mode. With the periodic tick, the
> balancer does the idle balancing on behalf of all the CPUs in nohz mode.
>
> This is not very optimal and has few issues:
> * the balancer will continue to have periodic ticks and wakeup
>    frequently (HZ rate), even though it may not have any rebalancing to do on
>    behalf of any of the idle CPUs.
> * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
>    wakeup can result in an additional interrupt on a CPU doing the timer
>    broadcast.
>
> The alternative is to have a push model, where all idle CPUs can enter nohz
> mode and any busy CPU kicks one of the idle CPUs to take care of idle
> balancing on behalf of a group of idle CPUs.
>
> Following patches switches idle load balancer to this push approach.
>
> Updates from the previous version:
>
> * Busy CPU uses send_remote_softirq() for invoking SCHED_SOFTIRQ on the
>    idle load balancing cpu, which does the load balancing on behalf of
>    all the idle CPUs.
>
> * Dropped the per NUMA node nohz load balancing as it doesn't detect
>    certain imbalance scenarios. This will be addressed later.
>
> Signed-off-by: Suresh Siddha<suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi<venki@google.com>

Sounds great.

I'm in the middle of packing at the moment, but will try to find time to 
test the patches.

It might help to show the difference that the patch series makes 
(powertop output?)

Regards,

Nigel
