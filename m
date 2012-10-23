Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2JWMJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:09:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49076 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2JWMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <50862E02.6020002@intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
	<1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
	<1350902138.2768.86.camel@twins>
	<50862E02.6020002@intel.com>
Date: Tue, 23 Oct 2012 14:09:05 +0200
Message-ID: <CABPqkBSzh1K5eDsnmrQdE9=YEkctvqLgfEyQe7wnS9ZbNqt9-Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 7:41 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 10/22/2012 06:35 PM, Peter Zijlstra wrote:
>> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
>>> --- a/include/uapi/linux/perf_event.h
>>> +++ b/include/uapi/linux/perf_event.h
>>> @@ -160,8 +160,9 @@ enum perf_branch_sample_type {
>>>         PERF_SAMPLE_BRANCH_ABORT        = 1U << 7, /* transaction aborts */
>>>         PERF_SAMPLE_BRANCH_INTX         = 1U << 8, /* in transaction (flag) */
>>>         PERF_SAMPLE_BRANCH_NOTX         = 1U << 9, /* not in transaction (flag) */
>>> +       PERF_SAMPLE_BRANCH_CALL_STACK   = 1U << 10, /* call stack */
>>>
>>> -       PERF_SAMPLE_BRANCH_MAX          = 1U << 10, /* non-ABI */
>>> +       PERF_SAMPLE_BRANCH_MAX          = 1U << 11, /* non-ABI */
>>>  };
>>
>> You add an ABI sample type without mentioning it in your changelog.. I
>> think I'll stop reading here.
>>
> Ok, I will add the ABI change to the change log. Do you think we should hide this
> branch sample type from user?
>
Certainly not. what's the point of this?
Unless, it is so broken that it does not work at all.

> Regards
> Yan, Zheng
