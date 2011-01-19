Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1ASGmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:42:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58910 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1ASGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:42:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4D3687C1.4000909@jp.fujitsu.com>
Date: Wed, 19 Jan 2011 15:42:09 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [RFC][PATCH 0/2 v1.0]sched: updating /proc/schedstat
References: <4D341ECD.3020503@linux.vnet.ibm.com> <1295283289.30950.172.camel@laptop> <4D352CA6.7010109@linux.vnet.ibm.com> <4D35416C.7020706@jp.fujitsu.com> <4D35462B.8010304@linux.vnet.ibm.com>
In-Reply-To: <4D35462B.8010304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ciju,

(2011/01/18 16:50), Ciju Rajan K wrote:
>
>
> On 01/18/2011 12:59 PM, Satoru Takeuchi wrote:
>> Hi Ciju,
>>
> Hello Satoru,
>
>> I don't like this patches because it breaks backward compatibility.
>> If there are any user who uses these fields, they can't get
>> the information which these fields provides from this time on.
>> In this context, `user' means not only application but also the person
>> who refers to /proc/schedstat directly.
>
> This patch set removes only those fields which are currently not in use.
> If you observe the fields of /proc/schedstat the following fields are not
> being updated.

Ah... I misunderstood the meaning of `unused' and complained based on too
old kernel's source. Sorry.

I confirmed that these fields are actually not treated by upstream kernel
at all. So I think it's OK if any userland tools are updated synchronized
with this change. Does its benefit is more than its cost? In my
understanding, its benefit is improving readability and reducing some memory
footprint, and its cost is changing all userspace tools referring /proc/schedstat.

# Unfortunately I don't know how much it costs.

Thanks,
Satoru

>
> For each cpu:
>
> 2) sched_switch
>
> For each domain:
>
> 28) sd->sbe_count
> 29) sd->sbe_balanced
> 30) sd->sbe_pushed
> 31) sd->sbf_count
> 32) sd->sbf_balanced
> 33) sd->sbf_pushed
> 36) sd->ttwu_move_balance
>
> The serial numbers indicate the positions of the fields in version 15
> of/proc/schedstat
>>
>> In fact, although I can't say "command XXX refers to these field",
>> I sometimes check {sbe_*,sbf_*} to confirm load_balance behavior
>> by issuing, for example,
>>
>> ===============================================================================
>> watch /proc/schedstat
>> ===============================================================================
>>
>> or
>>
>> ===============================================================================
>> while true ; do
>> cat /proc/schedstat>>schedstat_log
>> sleep 10
>> done
>> ===============================================================================
>
> Only concern is that the user might have to update the scripts to get the
> correct position of the fields. Which anyway the scripts have to take care
> depending on the version of /proc/schedstat.
>
> I hope this addresses your concern.
>
> -Ciju
>>
>> Thanks
>> Satoru
>>
>>>
>>>
>>>>
>>>> Also, attachment fail.
>>>
>>> It should be ok now.
>>>
>>> -Ciju
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at http://www.tux.org/lkml/
>>>
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


