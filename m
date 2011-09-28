Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1I1PO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:14:58 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48822 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1I1PO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:14:57 -0400
Message-ID: <4E8339BE.7010605@parallels.com>
Date: Wed, 28 Sep 2011 12:14:06 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>  <1316816432-9237-2-git-send-email-glommer@parallels.com> <1317157409.21836.5.camel@twins>
In-Reply-To: <1317157409.21836.5.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 06:03 PM, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>> @@ -623,6 +624,9 @@ static inline struct task_group *task_group(struct
>> task_struct *p)
>>          struct task_group *tg;
>>          struct cgroup_subsys_state *css;
>>
>> +       if (!p->mm)
>> +               return&root_task_group;
>> +
>>          css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
>>                          lockdep_is_held(&p->pi_lock) ||
>>                          lockdep_is_held(&task_rq(p)->lock));
>
> Hmm, why is that? Aren't kthreads part of the cgroup muck just as much
> as normal tasks are?
You're right. I had something else from another work I'm doing in mind 
and got confused.
Will remove it.
