Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2HOSCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:02:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:38338 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2HOSCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,774,1336374000"; 
   d="scan'208";a="181441991"
Message-ID: <502BE41B.4020508@linux.intel.com>
Date: Wed, 15 Aug 2012 11:02:03 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <20120815163400.GC14534@srcf.ucam.org>
In-Reply-To: <20120815163400.GC14534@srcf.ucam.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 9:34 AM, Matthew Garrett wrote:
> On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:
>> On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
>>> It bases on the following assumption:
>>> 1, If there are many task crowd in system, just let few domain cpus
>>> running and let other cpus idle can not save power. Let all cpu take the
>>> load, finish tasks early, and then get into idle. will save more power
>>> and have better user experience.
>>
>> I'm not sure this is a valid assumption. I've had it explained to me by
>> various people that race-to-idle isn't always the best thing. It has to
>> do with the cost of switching power states and the duration of execution
>> and other such things.
> 
> This is affected by Intel's implementation - if there's a single active 

not just intel.. also AMD
basically everyone who has the memory controller in the cpu package will end up with
a restriction very similar to this.

(this is because the exit-from-self-refresh latency is pretty high.. at least in DDR2/3)


