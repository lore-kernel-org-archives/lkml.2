Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2GDQAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:00:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:18255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab2GDQAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:00:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173392740"
Message-ID: <4FF46885.2090609@intel.com>
Date: Thu, 05 Jul 2012 00:00:05 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf/x86: Add Intel Nehalem-EX uncore support
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>  <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com> <1341396293.2507.77.camel@laptop>
In-Reply-To: <1341396293.2507.77.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 06:04 PM, Peter Zijlstra wrote:
> On Wed, 2012-07-04 at 14:00 +0800, Yan, Zheng wrote:
>> +static void nhmex_uncore_msr_enable_event(struct intel_uncore_box *box,
>> +                                         struct perf_event *event)
>> +{
>> +       struct hw_perf_event *hwc = &event->hw;
>> +
>> +       if (box->pmu->type == &nhmex_uncore_bbox)
>> +               nhmex_bbox_msr_enable_event(box, event);
>> +       else if (box->pmu->type == &nhmex_uncore_sbox)
>> +               nhmex_sbox_msr_enable_event(box, event);
>> +       else if (box->pmu->type == &nhmex_uncore_mbox)
>> +               nhmex_mbox_msr_enable_event(box, event);
>> +       else if (box->pmu->type == &nhmex_uncore_rbox)
>> +               nhmex_rbox_msr_enable_event(box, event);
>> +       else if (hwc->idx >= UNCORE_PMC_IDX_FIXED)
>> +               wrmsrl(hwc->config_base, NHMEX_PMON_CTL_EN_BIT0);
>> +       else if (box->pmu->type->event_mask & NHMEX_PMON_CTL_EN_BIT0)
>> +               wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT22);
>> +       else
>> +               wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT0);
>> +} 
> 
> wouldn't it be easier to do something like:
> 
>   box->pmu->type->enable_event(box, event);
>
Ok, I will update the patch.
  
> The same for these other functions that are massive ->type switches.
>
 
> Also, can you please add more comments, note all the face_cpuc stuff,
> and there's some rather dense code in all the alternative stuff. 
> 
OK

> Also, how can a single extra register require 192 bits of config space?
> 
Some events in the M-Box and R-Box require programming up to 3 extra
registers. For example, the event 0x5 in the R-Box requires programming
extra registers XBR_SET1_MM_CFG, XBR_SET1_MATCH and XBR_SET1_MATCH.

Regards
Yan, Zheng
