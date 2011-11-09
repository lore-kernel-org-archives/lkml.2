Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1KIOSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:18:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41947 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1KIOSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:18:36 -0500
MIME-Version: 1.0
In-Reply-To: <4EBA6AF7.4020509@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-14-git-send-email-glommer@parallels.com>
	<CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com>
	<4EBA6AF7.4020509@parallels.com>
Date: Wed, 9 Nov 2011 17:18:35 +0300
Message-ID: <CANaxB-z0-VY=SVEjmYKXrF+i2VW3U3QCxz0yN4Wp8-qevnd4tA@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] provide a version of cpuusage statistics inside
 cpu cgroup
From: Andrew Wagin <avagin@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And look at cfs_rq->prev_sum_exec_runtime, probably it is not used too.
Usage of cfs_rq->sum_exec_runtime looks strange.

2011/11/9 Glauber Costa <glommer@parallels.com>:
> On 11/09/2011 09:51 AM, Andrew Wagin wrote:
>>
>> Hi Glauber,
>>
>>> diff --git a/kernel/sched.c b/kernel/sched.c
>>> index d93cfd4..b9296cd 100644
>>> --- a/kernel/sched.c
>>> +++ b/kernel/sched.c
>>> @@ -303,6 +303,7 @@ struct task_group {
>>>
>>>        struct cfs_bandwidth cfs_bandwidth;
>>>        struct kernel_cpustat __percpu *cpustat;
>>> +       u64 __percpu *cpuusage;
>>
>> I can't find where you use this variable, probably it may be removed.
>
> Indeed.
> This is a leftover from the previous attempt.
>
