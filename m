Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2E3Kox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:44:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43145 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2E3Kow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:44:52 -0400
Message-ID: <4FC5F99B.2060109@parallels.com>
Date: Wed, 30 May 2012 14:42:35 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>   <1338371317-5980-2-git-send-email-glommer@parallels.com>  <1338373759.26856.238.camel@twins> <4FC5F727.2040804@parallels.com> <1338374555.26856.243.camel@twins>
In-Reply-To: <1338374555.26856.243.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 02:42 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 14:32 +0400, Glauber Costa wrote:
>>>> +    for_each_sched_rt_entity(rt_se) {
>>>> +            rt_rq = rt_rq_of_se(rt_se);
>>>> +            schedstat_add(rt_rq, exec_clock, delta_exec);
>>>> +    }
>>>> +
>>>>       if (!rt_bandwidth_enabled())
>>>>               return;
>>>
>>> See, this just makes me sad.. you now have a double
>>> for_each_sched_rt_entity() loop.
>>
>> The way I read the rt.c code, it it is called from enqueue_task_rt only
>> once.
>
> Ah, what I meant was, right after that !rt_bandwidth_enabled() muck we
> do another for_each_sched_rt_entity() walk.
I guess I can fold it there...

