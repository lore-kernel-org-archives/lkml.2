Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab2JXIhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:37:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:42052 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2JXIhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:37:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="159732192"
Message-ID: <5087A8C8.2030200@intel.com>
Date: Wed, 24 Oct 2012 16:37:28 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V2 1/7] perf, x86: Reduce lbr_sel_map size
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com> <1351058350-9159-2-git-send-email-zheng.z.yan@intel.com> <CABPqkBRMo9o8bujM+aCqh-hWqVz1-Y1G_15Oovv+15SMBbK=aA@mail.gmail.com> <50879D71.3080108@intel.com> <CABPqkBQWvV5w-qyaWmbmqs9+7zaC8kBhmacuAF3FYvw-PCh=9A@mail.gmail.com> <5087A574.3040507@intel.com>
In-Reply-To: <5087A574.3040507@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 04:23 PM, Yan, Zheng wrote:
> On 10/24/2012 04:15 PM, Stephane Eranian wrote:
>> On Wed, Oct 24, 2012 at 9:49 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>> On 10/24/2012 03:28 PM, Stephane Eranian wrote:
>>>> On Wed, Oct 24, 2012 at 7:59 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>>>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>>>>
>>>>> The index of lbr_sel_map is bit value of perf branch_sample_type.
>>>>> By using bit shift as index, we can reduce lbr_sel_map size.
>>>>>
>>>>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>>>>> ---
>>>>>  arch/x86/kernel/cpu/perf_event.h           |  4 +++
>>>>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 50 ++++++++++++++----------------
>>>>>  include/uapi/linux/perf_event.h            | 42 +++++++++++++++++--------
>>>>>  3 files changed, 56 insertions(+), 40 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
>>>>> index d3b3bb7..ea6749a 100644
>>>>> --- a/arch/x86/kernel/cpu/perf_event.h
>>>>> +++ b/arch/x86/kernel/cpu/perf_event.h
>>>>> @@ -412,6 +412,10 @@ struct x86_pmu {
>>>>>         struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
>>>>>  };
>>>>>
>>>>> +enum {
>>>>> +       PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE = PERF_SAMPLE_BRANCH_MAX_SHIFT,
>>>>> +};
>>>>> +
>>>> What's the point on the extraneous definition?
>>>
>>> because later patches will add map PERF_SAMPLE_BRANCH_CALL_STACK, it will make
>>> "PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE != PERF_SAMPLE_BRANCH_MAX_SHIFT"
>>>
>> And you are not going to do:
>>
>> enum perf_branch_sample_type_shift {
>> ...
>> PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = 10
>> PERF_SAMPLE_BRANCH_MAX_SHIFT
>> };
>>
>> PERF_SAMPLE_BRANCH_CALL_STACK = 1 << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT
>>
>> Unless you're telling you are not going to add a mapping for
>> PERF_SAMPLE_CALL_STACK to the
>> lbr_sel_map[]?
>>
> 
> I think include/uapi/linux/perf_event.h should only contain definition for user API.
> So I added PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT and PERF_SAMPLE_BRANCH_CALL_STACK to
> arch/x86/kernel/cpu/perf_event.h. Please check patch 1.
> 

Sorry, I mean patch 2.

