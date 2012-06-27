Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2F0CJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:09:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:28781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2F0CJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:09:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116372300"
Message-ID: <4FEA6B3D.9010905@intel.com>
Date: Wed, 27 Jun 2012 10:09:01 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com> <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com> <4FD7EFCB.6060005@intel.com> <1339578142.31548.128.camel@twins> <4FD949FF.7060207@intel.com> <CABPqkBTPah786S+GR=TdGCTxGzBEVg-Q2r0YAUFrYAm5iVEf=w@mail.gmail.com> <CABPqkBSPFCmmd55EanLrb7e84UTHT4MqrZh-H-q7RE+Pg6Akcg@mail.gmail.com>
In-Reply-To: <CABPqkBSPFCmmd55EanLrb7e84UTHT4MqrZh-H-q7RE+Pg6Akcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 09:05 AM, Stephane Eranian wrote:
> Hi,
> 
> If you compile the uncore support in 32-bit mode, you will
> get a warning on the hrtimer_start_range_ns() functions
> because the interval is passed as ktime_t whereas the
> function expects unsigned long.  With 64-bit, no problem
> ktime_t is a union with s64. But in 32-bit mode, there is
> a possible truncation of the delta. This needs to be
> fixed.
> 
thank you for mention. but I think someone has already submitted a patch.

Yan, Zheng

> On Thu, Jun 14, 2012 at 7:41 AM, Stephane Eranian <eranian@google.com> wrote:
>> On Thu, Jun 14, 2012 at 4:18 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>> On 06/13/2012 05:02 PM, Peter Zijlstra wrote:
>>>> On Wed, 2012-06-13 at 09:41 +0800, Yan, Zheng wrote:
>>>>> Peter suggests keeping the uncore names as they're listed in the intel
>>>>> doc. For Sandybirdge-EP, uncore names are something like: Cbo, iMC,
>>>>> QPI.
>>>>
>>>> No they're not, they're C-Box etc.. but I'm fine with doing a tolower on
>>>> all of it.
>>>>
>>>
>>> The reason I choose CBox instead of C-Box is that '-' is a separate symbol
>>> in the flex rules. '-' is used for matching events such as LLC-load-misses.
>>> I don't know how to allow letter '-' in the pmu name, but without leading
>>> to ambiguity.
>>>
>> I would drop the -, just call it cbox.


