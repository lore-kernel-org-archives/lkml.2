Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2GKCGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:06:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:5927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab2GKCGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="170206383"
Message-ID: <4FFCDF8C.9060204@intel.com>
Date: Wed, 11 Jul 2012 10:06:04 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 5/5] perf/x86: Add Intel Nehalem-EX uncore support
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>   <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>  <1341396293.2507.77.camel@laptop> <4FF534F1.3030307@intel.com> <1341922621.3462.130.camel@twins>
In-Reply-To: <1341922621.3462.130.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 08:17 PM, Peter Zijlstra wrote:
> On Thu, 2012-07-05 at 14:32 +0800, Yan, Zheng wrote:
>> The uncore subsystem in Nehalem-EX consists of 7 components
>> (U-Box, C-Box, B-Box, S-Box, R-Box, M-Box and W-Box). This
>> patch is large because the way to program these boxes is
>> diverse.
>>
> Thanks, I added the below little delta.
> 
> Did you manage to fix that SNB-EP crash already?

Yes, commit 42089697 (perf/x86: Detect number of instances of uncore CBox)
should fix that.

> 
> Also, should we be adding 58 (IVB) to the SNB uncore? The SDM states it
> should all be the same programming wise.
> 

It's completely untested, I think it's better not to do that now.

> ---
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> 
> @@ -893,7 +893,7 @@ static struct attribute_group nhmex_unco
>  static struct intel_uncore_type nhmex_uncore_cbox = {
>  	.name			= "cbox",
>  	.num_counters		= 6,
> -	.num_boxes		= 8,
> +	.num_boxes		= 10,
>  	.perf_ctr_bits		= 48,
>  	.event_ctl		= NHMEX_C0_MSR_PMON_EV_SEL0,
>  	.perf_ctr		= NHMEX_C0_MSR_PMON_CTR0,

This doesn't work. The MSRs for Cbox 8/9 in WSM-EX aren't contiguous with
Cbox 0~7. Furthermore the encoding for the FVC register in the Mbox are
different between NHM-EX and WSM-EX.

Please don't merge this patch, I will send a new one with WSM-EX support
and some fixes soon.

Regards
Yan, Zheng
