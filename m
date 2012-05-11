Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2EKGbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:31:15 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33200 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab2EKGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:31:12 -0400
Message-ID: <4FACB228.40107@linux.vnet.ibm.com>
Date: Fri, 11 May 2012 12:01:04 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Yan, Zheng" <zheng.z.yan@intel.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com> <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051106-9574-0000-0000-000002A357F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012 07:37 AM, Yan, Zheng wrote:

> +static int __cpuinit uncore_cpu_prepare(int cpu)
> +{
> +	struct intel_uncore_type *type;
> +	struct intel_uncore_pmu *pmu;
> +	struct intel_uncore_box *exist, *box;
> +	int i, j, phyid;
> +
> +	phyid = topology_physical_package_id(cpu);
> +
> +	/* allocate the box data structure */
> +	for (i = 0; msr_uncores[i]; i++) {
> +		type = msr_uncores[i];
> +		for (j = 0; j < type->num_boxes; j++) {
> +			exist = NULL;
> +			pmu = &type->pmus[j];
> +
> +			if (pmu->func_id < 0)
> +				pmu->func_id = j;
> +			exist = uncore_pmu_find_box(pmu, phyid);
> +			if (exist)
> +				exist->refcnt++;
> +			if (exist)
> +				continue;



May be a redundant condition checking ^ ?

> +
> +			box = uncore_alloc_box(cpu);
> +			if (!box)
> +				return -ENOMEM;
> +
> +			box->pmu = pmu;
> +			box->phy_id = phyid;
> +			uncore_pmu_add_box(pmu, box);
> +		}
> +	}
> +	return 0;


