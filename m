Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2HPJ66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:58:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:60919 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab2HPJ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:58:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="134917039"
Message-ID: <502CC454.6070405@intel.com>
Date: Thu, 16 Aug 2012 17:58:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: preeti <preeti@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com>
In-Reply-To: <502C98E8.20800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 02:53 PM, preeti wrote:

> 
> Hi everyone,
> 
> From what I have understood so far,I try to summarise pin pointed
> differences between the performance and power policies as found
> relevant to the scheduler-load balancing mechanism.Any thoughts?


Currently, the load_balance trigger will be called in timer for periodic
tick, or dynamic tick.
In periodic tick, the cpu is waked, so do load_balance is not cost much.
But in dynamic tick. we'd better do power policy suitable scenario
checking in nohz_kick_needed(), and then do nohz_balancer_kick on least
but non-idle cpu if possible. that reduce the idle cpu waking chance.

Any comments?

