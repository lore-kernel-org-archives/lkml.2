Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1ARHaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 02:30:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54276 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1ARHa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 02:30:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4D35416C.7020706@jp.fujitsu.com>
Date: Tue, 18 Jan 2011 16:29:48 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [RFC][PATCH 0/2 v1.0]sched: updating /proc/schedstat
References: <4D341ECD.3020503@linux.vnet.ibm.com> <1295283289.30950.172.camel@laptop> <4D352CA6.7010109@linux.vnet.ibm.com>
In-Reply-To: <4D352CA6.7010109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ciju,

(2011/01/18 15:01), Ciju Rajan K wrote:
> Hi Peter,
>
>
> On 01/17/2011 10:24 PM, Peter Zijlstra wrote:
>> On Mon, 2011-01-17 at 16:19 +0530, Ciju Rajan K wrote:
>>> Hi All,
>>>
>>> Here is the first version of the patch set, which updates
>>> the /proc/schedstat statistics. Please review the patches and let me
>>> know your thoughts.
>>
>> Whats the impact on existing userspace, does the change warrant the
>> effort of changing the userspace tools?
>
> Since the fields are not at the end, there might be some changes required for the userspace scripts. But the benefits would be that we will have more relevant stats in /proc/schedstat.
>
> Most of the userspace applications will be considering the version field of /proc/schedstat. Since we have an updated version for these changes, there should not be any breakage for the existing applications. One more advantage is that who ever looks at /proc/schedstat will see the actual numbers rather than seeing more zeros. Basically the readability improves.
>
> "http://eaglet.rain.com/rick/linux/schedstat/" admits that the format for /proc/schedstat can change depending upon the version. If you are ok with the /proc/schedstat updates, I can also send a patch to update "http://eaglet.rain.com/rick/linux/schedstat/v15/latency.c" program which parses some of the schedstat entries.

I don't like this patches because it breaks backward compatibility.
If there are any user who uses these fields, they can't get
the information which these fields provides from this time on.
In this context, `user' means not only application but also the person
who refers to /proc/schedstat directly.

In fact, although I can't say "command XXX refers to these field",
I sometimes check {sbe_*,sbf_*} to confirm load_balance behavior
by issuing, for example,

===============================================================================
watch /proc/schedstat
===============================================================================

or

===============================================================================
while true ; do
   cat /proc/schedstat >>schedstat_log
   sleep 10
done
===============================================================================

Thanks
Satoru

>
>
>>
>> Also, attachment fail.
>
> It should be ok now.
>
> -Ciju
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


