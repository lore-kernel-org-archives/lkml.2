Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2GEPqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:46:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:13225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab2GEPqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:46:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="161744511"
Message-ID: <4FF5B6D9.3070507@intel.com>
Date: Thu, 05 Jul 2012 23:46:33 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@google.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 5/5] perf/x86: Add Intel Nehalem-EX uncore support
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com> <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com> <1341396293.2507.77.camel@laptop> <4FF534F1.3030307@intel.com> <20120705145124.GS11413@one.firstfloor.org>
In-Reply-To: <20120705145124.GS11413@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 10:51 PM, Andi Kleen wrote:
> On Thu, Jul 05, 2012 at 02:32:17PM +0800, Yan, Zheng wrote:
>> The uncore subsystem in Nehalem-EX consists of 7 components
>> (U-Box, C-Box, B-Box, S-Box, R-Box, M-Box and W-Box). This
>> patch is large because the way to program these boxes is
>> diverse.
> 
> Thanks for doing the driver. Lots of work.
> 
> May be worth adding a CONFIG for the uncore code now?
> Maybe even a module, so that not every distro kernel has it always
> in memory. I don't think perf has support for tracking
> module counts, but I guess it would be ok to have the module be not
> unloadable once loaded by setting the count to -1.
Yes, I think it's good to compile the uncore driver as a module. 

> 
> Also did you do some random testing by putting randomized values into
> all the exported registers and see if anything is crashable for 
> unpriv. userspace?
No, I just did functional tests for these registers. unpriv? I think perf
is only available to root by default. 

> 
>> +		 * events are functional identical, but use different
>> +		 * extra registers. If we failed to take an extra
>> +		 * register, try the alternative.
>> +		 */
>> +		if (idx % 2)
>> +			idx--;
>> +		else
>> +			idx++;
>> +		if (idx != reg1->idx % 6) {
>> +			if (idx == 2)
>> +				config1 >>= 8;
>> +			else if (idx == 3)
>> +				config1 <<= 8;
>> +			goto again;
> 
> Does this limit the retries?
Yes, the (idx != reg1->idx % 6) check does that.

Regards
Yan, Zheng


