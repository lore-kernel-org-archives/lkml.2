Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab1FUQl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:41:27 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57575 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab1FUQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:41:25 -0400
Message-ID: <4E00C977.1060800@linux.vnet.ibm.com>
Date: Tue, 21 Jun 2011 22:10:23 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_events: Enable idle state tracing for pseries (ppc64)
References: <20110601123554.GA12492@deepthi.in.ibm.com> <1308284659.32158.4.camel@pasglop>	<4DFF80FD.8080600@linux.vnet.ibm.com> <1308606133.32158.143.camel@pasglop> <4E00C6DE.1030001@linux.vnet.ibm.com>
In-Reply-To: <4E00C6DE.1030001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 June 2011 09:59 PM, deepthi wrote:
> On Tuesday 21 June 2011 03:12 AM, Benjamin Herrenschmidt wrote:
>> On Mon, 2011-06-20 at 22:48 +0530, deepthi wrote:
>>> On Friday 17 June 2011 09:54 AM, Benjamin Herrenschmidt wrote:
>>>> On Wed, 2011-06-01 at 18:05 +0530, Deepthi Dharwar wrote:
>>>>> Hi,
>>>>>
>>>>> Please find below a patch, which has perf_events added for pseries (ppc64)
>>>>> platform in order to emit the trace required for perf timechart. 
>>>>> It essentially enables perf timechart for pseries platfrom to analyse
>>>>> power savings events like cpuidle states.
>>>>
>>>> Unless I'm mistaken, you added traces to dedicated CPU idle sleep but
>>>> not shared processor. Any reason ?
>>>>
>>> Yes, the traces were added only to dedicated CPU idle sleep and not for 
>>> shared processor. This was added only for RFC purpose, and looking for 
>>> comments from trace implementation point of view. This can be
>>> easily extended to the latter too.
>>
>> Please do both.
>>
> Yes, I ll do so.
> 
>>>> Also I don't really know that tracing stuff but what's the point of
>>>> having start/end _and trace_cpu_idle if you're going to always start &
>>>> end around a single occurence of trace_cpu_idle ?
>>>>
>>> power_start/end are the APIs that were used initially
>>> and they are going to be deprecated in the upcoming kernel releases.
>>> trace_cpu_idle call is going to replace power start/end routines. 
>>> To maintain backward compatibility and uniformity, both the routines 
>>> have been used.
>>> (ref:https://lkml.org/lkml/2010/11/14/60ref:https://lkml.org/lkml/2010/11/14/60)
>>
>> Backward compatible with what ? Userspace ? Do we care in that specific
>> case since it's a new feature ?
>>
> Going forward, we can just have trace_cpu_idle call and 
> remove the power_start/end calls.
> 
>>>> Wouldn't there be a way to start/end and then trace the snooze and
>>>> subsequent cede within the same start/end section or that makes no
>>>> sense ?
>>>>
>>> We wanted to find the residency time of both Snooze as well as cede 
>>> separately. Knowing this will help us tweak our cpuidle code. So, both 
>>> have been captured separately.
>>>
>>>> Also would there be any interest in doing the tracing more generically
>>>> in idle.c ?
>>>>
>>> Yes, this tracing is already implemented for Intel platform. This would
>>> be a part of cpuidle framework. Going further, once the power cpuidle 
>>> framework is ported and ready, we will extend this trace there as well.
>>> (ref:https://lkml.org/lkml/2011/6/7/375)
>>
>> So do we need to apply this patch at all since the cpuidle stuff is
>> happening too ?
>>
> 
> Well, not really. This is more for RFC purpose. 
> I just wanted to share this patch, as we are using it to evaluate
> cpu idle on ppc64.
> 
  I will re-base the patch and move it to the cpu idle for power 
  framework. So the tracing too gets in along with the 
  cpu idle support. 

  Thanks Ben. 

>> Cheers,
>> Ben.
>>
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

Regards,
Deepthi
