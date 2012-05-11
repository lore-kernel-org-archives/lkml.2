Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab2EKGmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:42:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:63101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab2EKGmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164815369"
Message-ID: <4FACB4B5.8040702@intel.com>
Date: Fri, 11 May 2012 14:41:57 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com> <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com> <4FACB228.40107@linux.vnet.ibm.com>
In-Reply-To: <4FACB228.40107@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 02:31 PM, Anshuman Khandual wrote:
> On Wednesday 02 May 2012 07:37 AM, Yan, Zheng wrote:
> 
>> +static int __cpuinit uncore_cpu_prepare(int cpu)
>> +{
>> +	struct intel_uncore_type *type;
>> +	struct intel_uncore_pmu *pmu;
>> +	struct intel_uncore_box *exist, *box;
>> +	int i, j, phyid;
>> +
>> +	phyid = topology_physical_package_id(cpu);
>> +
>> +	/* allocate the box data structure */
>> +	for (i = 0; msr_uncores[i]; i++) {
>> +		type = msr_uncores[i];
>> +		for (j = 0; j < type->num_boxes; j++) {
>> +			exist = NULL;
>> +			pmu = &type->pmus[j];
>> +
>> +			if (pmu->func_id < 0)
>> +				pmu->func_id = j;
>> +			exist = uncore_pmu_find_box(pmu, phyid);
>> +			if (exist)
>> +				exist->refcnt++;
>> +			if (exist)
>> +				continue;
> 
> 
> 
> May be a redundant condition checking ^ ?

Yes, it's redundant. I will remove it in later patches.

Regards
Yan, Zheng
> 
>> +
>> +			box = uncore_alloc_box(cpu);
>> +			if (!box)
>> +				return -ENOMEM;
>> +
>> +			box->pmu = pmu;
>> +			box->phy_id = phyid;
>> +			uncore_pmu_add_box(pmu, box);
>> +		}
>> +	}
>> +	return 0;
> 
> 

