Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2JWF2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:28:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:30807 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2JWF2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:28:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,633,1344236400"; 
   d="scan'208";a="209323979"
Message-ID: <50862AE7.7080901@intel.com>
Date: Tue, 23 Oct 2012 13:28:07 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>  <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com> <1350902016.2768.85.camel@twins>
In-Reply-To: <1350902016.2768.85.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 06:33 PM, Peter Zijlstra wrote:
> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
>> +       /* LBR callstack does not work well with FREEZE_LBRS_ON_PMI */
>> +       if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
>> +               debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI; 
> 
> How useful it is without this? How many calls between PMI and us getting
> to intel_pmu_lbr_read()?
> 

So far we use the call stack feature only for ring 3. but even for ring 0,
it's OK. because LBR is disabled at the very beginning of PMI hander, and
enabled when exiting the PMI hander. the depth to _intel_pmu_lbr_enable/
_intel_pmu_lbr_disable are the same. So entries that are added by calling
_intel_pmu_lbr_disable will be popped during enabling LBR.

Regards
Yan, Zheng
