Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2JWFbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:31:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:4979 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab2JWFbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,633,1344236400"; 
   d="scan'208";a="209324662"
Message-ID: <50862B95.4020105@intel.com>
Date: Tue, 23 Oct 2012 13:31:01 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com> <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com> <1350902016.2768.85.camel@twins> <CABPqkBQ8XCwONGvoXpu8kwwwcFPM9yJce4r9OJU4E7iY0_9ZUA@mail.gmail.com>
In-Reply-To: <CABPqkBQ8XCwONGvoXpu8kwwwcFPM9yJce4r9OJU4E7iY0_9ZUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 07:23 PM, Stephane Eranian wrote:
> On Mon, Oct 22, 2012 at 12:33 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
>>> +       /* LBR callstack does not work well with FREEZE_LBRS_ON_PMI */
>>> +       if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
>>> +               debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
>>
> Is this a bug or a feature?
> 
It's a hardware bug. If FREEZE_LBRS_ON_PMI is set, PMI may corrupt the call stack records.

Regards
Yan, Zheng

>>
>> How useful it is without this? How many calls between PMI and us getting
>> to intel_pmu_lbr_read()?
> 
> Agreed with Peter. Freeze on PMI is critical for LBR in general.
> 

