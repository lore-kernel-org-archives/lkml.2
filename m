Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1I1PQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:16:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48898 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1I1PQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:16:37 -0400
Message-ID: <4E833A28.8020508@parallels.com>
Date: Wed, 28 Sep 2011 12:15:52 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [RFD 3/9] Display /proc/stat information per cgroup
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>  <1316816432-9237-4-git-send-email-glommer@parallels.com> <1317160344.21836.16.camel@twins>
In-Reply-To: <1317160344.21836.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 06:52 PM, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>> +       root_task_group.cpustat = alloc_percpu(struct kernel_stat);
>> +       /* Failing that early an allocation means we're screwed anyway */
>> +       BUG_ON(!root_task_group.cpustat);
>> +       for_each_possible_cpu(i) {
>> +               kstat = per_cpu_ptr(root_task_group.cpustat, i);
>> +               kstat->cpustat[IDLE] = 0;
>> +               kstat->cpustat[IDLE_BASE] = 0;
>> +               kstat->cpustat[IOWAIT_BASE] = 0;
>> +               kstat->cpustat[IOWAIT] = 0;
>
> so alloc_percpu() will actually zero your memory for you, which you rely
> on for all other fields as well, so why reset these ones?

Just to be style-consistent with the non-root initialization, in which 
we actually put values on that. But I can easily remove it.

>
>> +       }
>
>

