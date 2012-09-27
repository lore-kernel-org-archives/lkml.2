Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2I0UeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:34:11 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45120 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2I0UeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:34:09 -0400
Message-ID: <5064B814.9010106@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 02:03:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Chuansheng Liu <chuansheng.liu@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
References: <1348681092.19514.10.camel@cliu38-desktop-build> <1348703122.19514.17.camel@cliu38-desktop-build> <50632767.5050607@linux.vnet.ibm.com> <1348679199.26695.455.camel@sbsiddha-desk.sc.intel.com> <50633BA0.5030700@linux.vnet.ibm.com> <1348699588.6644.21.camel@sbsiddha-desk.sc.intel.com> <50649E1C.40602@linux.vnet.ibm.com> <1348773658.6644.36.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1348773658.6644.36.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092720-5140-0000-0000-000002228DA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 12:50 AM, Suresh Siddha wrote:
> On Fri, 2012-09-28 at 00:12 +0530, Srivatsa S. Bhat wrote:
>> On 09/27/2012 04:16 AM, Suresh Siddha wrote:
>>>
>>> No. irq_set_affinity()
>>>
>>
>> Um? That takes the updated/changed affinity and sets data->affinity to
>> that value no? You mentioned that probably the intention of the original
>> code was to preserve the user-set affinity mask, but still change the
>> underlying interrupt routing. Sorry, but I still didn't quite understand
>> what is that part of the code that achieves that.
> 
> For the HW routing to be changed we AND it with cpu_online_map and use
> that for programming the interrupt entries etc.

Ah, now I see.. you were referring to the __assign_irq_vector() code, whereas
I was looking only at fixup_irqs() and was trying to find the code that did
what you said.. that's what got me confused earlier :-)

> The user-specified
> affinity still has the cpu that is offlined.
> 

Right, so data->affinity is untouched, whereas cfg->domain is updated when
the CPU is offlined..

> And when the cpu comes online and if it is part of the user-specified
> affinity, then the HW routing can be again modified to include the new
> cpu.
> 

Right, got it.

> hope this clears it!
>

Yep, thanks a lot!

Regards,
Srivatsa S. Bhat

